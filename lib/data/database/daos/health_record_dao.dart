import 'dart:math';
import 'package:drift/drift.dart';

import '../tables/raw_health_records.dart';
import '../app_database.dart';
import '../../../core/utils/ppg_hrv_calculator.dart';


part 'health_record_dao.g.dart';

@DriftAccessor(tables: [RawHealthRecords])
class HealthRecordDao extends DatabaseAccessor<AppDatabase>
    with _$HealthRecordDaoMixin {
  HealthRecordDao(super.db);

  /// Upsert a health record. Uses the composite unique key
  /// (recordType, sourceId, startTime) to handle re-reported values.
  Future<void> upsertRecord(RawHealthRecordsCompanion record) async {
    await into(rawHealthRecords).insert(
      record,
      onConflict: DoUpdate(
        (_) => record,
        target: [
          rawHealthRecords.recordType,
          rawHealthRecords.sourceId,
          rawHealthRecords.startTime,
        ],
      ),
    );
  }

  /// Batch upsert multiple records.
  Future<void> upsertRecords(List<RawHealthRecordsCompanion> records) async {
    await batch((batch) {
      for (final record in records) {
        batch.insert(
          rawHealthRecords,
          record,
          onConflict: DoUpdate(
            (_) => record,
            target: [
              rawHealthRecords.recordType,
              rawHealthRecords.sourceId,
              rawHealthRecords.startTime,
            ],
          ),
        );
      }
    });
  }

  /// Get records of a specific type within a date range.
  Future<List<RawHealthRecord>> getRecordsByType(
    String type, {
    required DateTime start,
    required DateTime end,
  }) async {
    return (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals(type) &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();
  }

  /// Get resting HR records for a trailing window.
  /// Prioritizes explicit RESTING_HEART_RATE records written by wearable/Health Connect.
  /// Only falls back to raw HEART_RATE records if no RESTING_HEART_RATE records exist.
  Future<List<RawHealthRecord>> getRestingHrRecords({
    required DateTime start,
    required DateTime end,
  }) async {
    final rhrRecords = await (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('RESTING_HEART_RATE') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();

    if (rhrRecords.isNotEmpty) {
      return rhrRecords;
    }

    // Fallback: only if no RESTING_HEART_RATE records exist in the entire window
    return (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('HEART_RATE') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();
  }

  /// Get the max HR observed during exercise sessions in a trailing window.
  ///
  /// 1. Finds actual WORKOUT sessions within [start, end].
  /// 2. For each workout, inspects heart rates recorded during that workout window.
  /// 3. Filters out single-sample optical sensor spikes (> 220 bpm or isolated glitches)
  ///    by taking the sustained peak HR (98th percentile for >= 5 samples, or max).
  /// 4. If no workouts exist, looks for sustained aerobic exertion (> 120 bpm, <= 215 bpm).
  /// 5. Returns null if no exercise data is available (allowing age fallback).
  Future<double?> getMaxExerciseHr({
    required DateTime start,
    required DateTime end,
  }) async {
    // 1. Fetch workout sessions in window
    final workouts = await (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('WORKOUT') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end)))
        .get();

    if (workouts.isNotEmpty) {
      final List<double> workoutPeakHrs = [];
      for (final w in workouts) {
        final hrs = await (select(rawHealthRecords)
              ..where((r) =>
                  r.recordType.equals('HEART_RATE') &
                  r.startTime.isBiggerOrEqualValue(w.startTime) &
                  r.endTime.isSmallerOrEqualValue(w.endTime) &
                  r.value.isSmallerOrEqualValue(220.0) &
                  r.value.isBiggerValue(60.0))
              ..orderBy([(r) => OrderingTerm.asc(r.value)]))
            .get();

        if (hrs.isNotEmpty) {
          if (hrs.length >= 5) {
            // Sustained peak (98th percentile to eliminate 1-sample optical spikes)
            final p98Index =
                ((hrs.length - 1) * 0.98).floor().clamp(0, hrs.length - 1);
            workoutPeakHrs.add(hrs[p98Index].value);
          } else {
            workoutPeakHrs.add(hrs.last.value);
          }
        }
      }

      if (workoutPeakHrs.isNotEmpty) {
        workoutPeakHrs.sort((a, b) => b.compareTo(a));
        return workoutPeakHrs.first;
      }
    }

    // 2. Fallback: if no WORKOUT records logged, look for sustained aerobic heart rates
    final aerobicHrs = await (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('HEART_RATE') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end) &
              r.value.isBiggerValue(120.0) &
              r.value.isSmallerOrEqualValue(215.0))
          ..orderBy([(r) => OrderingTerm.desc(r.value)]))
        .get();

    if (aerobicHrs.length >= 3) {
      // Avoid isolated single-sample spike
      return aerobicHrs[1].value;
    } else if (aerobicHrs.isNotEmpty) {
      return aerobicHrs.first.value;
    }

    return null;
  }

  /// Get sleep session records for baseline computation.
  Future<List<RawHealthRecord>> getSleepRecords({
    required DateTime start,
    required DateTime end,
  }) async {
    return (select(rawHealthRecords)
          ..where((r) =>
              (r.recordType.equals('SLEEP_SESSION') |
                  r.recordType.equals('SLEEP_ASLEEP')) &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();
  }

  /// Get SpO2 records for baseline computation.
  Future<List<RawHealthRecord>> getSpo2Records({
    required DateTime start,
    required DateTime end,
  }) async {
    return (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('BLOOD_OXYGEN') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();
  }

  /// Total record count (for UI stats).
  Future<int> getRecordCount() async {
    final count = rawHealthRecords.id.count();
    final query = selectOnly(rawHealthRecords)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count)!;
  }

  /// Get total steps within a date range (strictly for the requested interval).
  ///
  /// Prevents:
  /// 1. Weekly/multi-day rollups (>24h duration) from contaminating day steps.
  /// 2. Multi-source doubling (e.g. Phone accelerometer + CMF Watch).
  /// 3. Cumulative daily updates from being repeatedly summed.
  Future<int> getTotalSteps({required DateTime start, required DateTime end}) async {
    final rawRecords = await (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('STEPS') &
              r.startTime.isSmallerOrEqualValue(end) &
              r.endTime.isBiggerOrEqualValue(start))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();

    if (rawRecords.isEmpty) return 0;

    // 1. Filter out records that span > 24 hours (weekly or multi-day rollups)
    final validRecords = rawRecords.where((r) {
      final duration = r.endTime.difference(r.startTime);
      if (duration.inHours > 24) return false;
      if (r.value <= 0) return false;
      return true;
    }).toList();

    if (validRecords.isEmpty) return 0;

    // 2. Group records by sourceId
    final Map<String, List<RawHealthRecord>> recordsBySource = {};
    for (final r in validRecords) {
      recordsBySource.putIfAbsent(r.sourceId, () => []).add(r);
    }

    // 3. For each source, compute its daily total, detecting cumulative vs delta reporting
    final Map<String, int> sourceTotals = {};
    for (final entry in recordsBySource.entries) {
      final source = entry.key;
      final srcRecords = entry.value;

      if (srcRecords.isEmpty) continue;
      if (srcRecords.length == 1) {
        sourceTotals[source] = srcRecords.first.value.round();
        continue;
      }

      // Check if records represent cumulative daily updates via temporal interval overlap
      bool hasTimeOverlaps = false;
      for (int i = 0; i < srcRecords.length; i++) {
        for (int j = i + 1; j < srcRecords.length; j++) {
          final a = srcRecords[i];
          final b = srcRecords[j];
          if (a.startTime == b.startTime) {
            hasTimeOverlaps = true;
            break;
          }
          final overlapStart =
              a.startTime.isAfter(b.startTime) ? a.startTime : b.startTime;
          final overlapEnd =
              a.endTime.isBefore(b.endTime) ? a.endTime : b.endTime;
          if (overlapEnd.isAfter(overlapStart)) {
            if (overlapEnd.difference(overlapStart).inMinutes > 5) {
              hasTimeOverlaps = true;
              break;
            }
          }
        }
        if (hasTimeOverlaps) break;
      }

      double maxVal = 0;
      double sumVal = 0;
      for (final r in srcRecords) {
        if (r.value > maxVal) maxVal = r.value;
        sumVal += r.value;
      }

      if (hasTimeOverlaps) {
        sourceTotals[source] = maxVal.round();
      } else {
        sourceTotals[source] = sumVal.round();
      }
    }

    if (sourceTotals.isEmpty) return 0;

    // 4. Multi-source de-duplication:
    // If multiple sources exist (e.g. phone pedometer + Nothing X / CMF Watch),
    // DO NOT SUM THEM TOGETHER! Summing them doubles or triples steps.
    // Instead, prefer Nothing/CMF/wearable source, or take the maximum realistic source count.
    int bestSteps = 0;
    String? preferredSource;

    for (final source in sourceTotals.keys) {
      final lower = source.toLowerCase();
      if (lower.contains('nothing') ||
          lower.contains('cmf') ||
          lower.contains('watch') ||
          lower.contains('wear')) {
        preferredSource = source;
        break;
      }
    }

    if (preferredSource != null && sourceTotals[preferredSource]! > 0) {
      bestSteps = sourceTotals[preferredSource]!;
    } else {
      bestSteps = sourceTotals.values.reduce((a, b) => a > b ? a : b);
    }

    // 5. Sanity cap: single-day human limit (80,000 steps)
    return bestSteps.clamp(0, 80000);
  }


  /// Get total calories (active or total) within a date range.
  Future<double> getTotalCalories({
    required DateTime start,
    required DateTime end,
    bool activeOnly = false,
  }) async {
    final records = await (select(rawHealthRecords)
          ..where((r) =>
              (activeOnly
                  ? r.recordType.equals('ACTIVE_ENERGY_BURNED')
                  : (r.recordType.equals('TOTAL_CALORIES_BURNED') |
                      r.recordType.equals('ACTIVE_ENERGY_BURNED'))) &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end)))
        .get();
    double sum = 0;
    for (final r in records) {
      sum += r.value;
    }
    return sum;
  }

  /// Get all workouts within a date range.
  Future<List<RawHealthRecord>> getWorkouts({
    required DateTime start,
    required DateTime end,
  }) async {
    return (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('WORKOUT') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.desc(r.startTime)]))
        .get();
  }

  /// Get latest HRV (SDNN or RMSSD) record within a date range.
  /// If no direct HRV records exist from the wearable, derives HRV (rMSSD)
  /// from optical Photoplethysmography (PPG) heart rate telemetry samples.
  Future<double?> getLatestHrv({
    required DateTime start,
    required DateTime end,
  }) async {
    final records = await (select(rawHealthRecords)
          ..where((r) =>
              (r.recordType.equals('HEART_RATE_VARIABILITY_SDNN') |
                  r.recordType.equals('HEART_RATE_VARIABILITY_RMSSD')) &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.desc(r.startTime)])
          ..limit(1))
        .get();
    if (records.isNotEmpty) return records.first.value;

    // Fallback: derive HRV (rMSSD) from resting / overnight PPG heart rate records
    final hrRecords = await (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('HEART_RATE') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();
    return PpgHrvCalculator.computeRmssdFromHeartRates(hrRecords);
  }

  /// Get sleep stages records within a date range.
  /// Only returns actual stage breakdowns (deep, light, rem, awake),
  /// NOT session-level records (SLEEP_SESSION, SLEEP_ASLEEP).
  Future<List<RawHealthRecord>> getSleepStages({
    required DateTime start,
    required DateTime end,
  }) async {
    return (select(rawHealthRecords)
          ..where((r) =>
              (r.recordType.equals('SLEEP_DEEP') |
                  r.recordType.equals('SLEEP_LIGHT') |
                  r.recordType.equals('SLEEP_REM') |
                  r.recordType.equals('SLEEP_AWAKE')) &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();
  }

  /// Get heart rate records within a date range.
  Future<List<RawHealthRecord>> getHeartRates({
    required DateTime start,
    required DateTime end,
  }) async {
    return (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('HEART_RATE') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();
  }

  /// Get last night's sleep session (most recent SLEEP_SESSION or SLEEP_ASLEEP).
  /// Searches from [start] to [end] for the latest session-level sleep record.
  Future<RawHealthRecord?> getLastNightSleep({
    required DateTime start,
    required DateTime end,
  }) async {
    final records = await (select(rawHealthRecords)
          ..where((r) =>
              (r.recordType.equals('SLEEP_SESSION') |
                  r.recordType.equals('SLEEP_ASLEEP')) &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.desc(r.startTime)])
          ..limit(1))
        .get();
    return records.isEmpty ? null : records.first;
  }

  /// Get today's latest SpO2 reading.
  Future<double?> getTodayLatestSpo2({
    required DateTime start,
    required DateTime end,
  }) async {
    final records = await (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('BLOOD_OXYGEN') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.desc(r.startTime)])
          ..limit(1))
        .get();
    return records.isEmpty ? null : records.first.value;
  }

  /// Get today's resting heart rate.
  /// Prefers RESTING_HEART_RATE records, falls back to minimum HEART_RATE.
  Future<double?> getTodayRestingHr({
    required DateTime start,
    required DateTime end,
  }) async {
    // First try explicit RESTING_HEART_RATE records
    final rhrRecords = await (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('RESTING_HEART_RATE') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.desc(r.startTime)])
          ..limit(1))
        .get();
    if (rhrRecords.isNotEmpty) return rhrRecords.first.value;

    // Fallback: minimum HEART_RATE value today
    final hrRecords = await (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('HEART_RATE') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.value)])
          ..limit(1))
        .get();
    return hrRecords.isEmpty ? null : hrRecords.first.value;
  }

  /// Get today's latest respiratory rate reading.
  Future<double?> getTodayLatestRespiratoryRate({
    required DateTime start,
    required DateTime end,
  }) async {
    final records = await (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('RESPIRATORY_RATE') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.desc(r.startTime)])
          ..limit(1))
        .get();
    return records.isEmpty ? null : records.first.value;
  }

  /// Get HRV records for charting and analysis.
  /// If direct records are not present from the wearable, derives optical PPG rMSSD records from heart rate telemetry.
  Future<List<RawHealthRecord>> getHrvRecords({
    required DateTime start,
    required DateTime end,
    bool allowIntraday = false,
  }) async {
    final direct = await (select(rawHealthRecords)
          ..where((r) =>
              (r.recordType.equals('HEART_RATE_VARIABILITY_SDNN') |
                  r.recordType.equals('HEART_RATE_VARIABILITY_RMSSD')) &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();
    if (direct.isNotEmpty) return direct;

    // Fallback: derive optical PPG HRV from heart rate records
    final hrRecords = await (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('HEART_RATE') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();

    final buckets = <String, List<RawHealthRecord>>{};
    for (final r in hrRecords) {
      final key = allowIntraday
          ? '${r.startTime.year}-${r.startTime.month}-${r.startTime.day}-${(r.startTime.hour ~/ 2) * 2}'
          : '${r.startTime.year}-${r.startTime.month}-${r.startTime.day}';
      buckets.putIfAbsent(key, () => []).add(r);
    }

    final ppgRecords = <RawHealthRecord>[];
    for (final bucketRecords in buckets.values) {
      final rmssd = PpgHrvCalculator.computeRmssdFromHeartRates(bucketRecords);
      if (rmssd != null) {
        ppgRecords.add(bucketRecords.first.copyWith(
          recordType: 'HEART_RATE_VARIABILITY_RMSSD',
          value: rmssd,
          unit: 'MILLISECOND',
        ));
      }
    }
    return ppgRecords;
  }

  /// Get all HRV records for rolling baseline calculation.
  /// If no direct HRV records exist from the wearable, derives daily PPG rMSSD records from heart rates.
  Future<List<RawHealthRecord>> getHrvBaselineRecords({
    required DateTime start,
    required DateTime end,
  }) async {
    return getHrvRecords(start: start, end: end, allowIntraday: false);
  }

  /// Get all respiratory rate records for rolling baseline calculation.
  Future<List<RawHealthRecord>> getRespiratoryRateBaselineRecords({
    required DateTime start,
    required DateTime end,
  }) async {
    return (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('RESPIRATORY_RATE') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();
  }
}
