import 'package:drift/drift.dart';

import '../tables/raw_health_records.dart';
import '../app_database.dart';

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

  /// Get the daily minimum resting HR for a trailing window.
  /// Returns list of (date, minValue) pairs.
  Future<List<RawHealthRecord>> getRestingHrRecords({
    required DateTime start,
    required DateTime end,
  }) async {
    return (select(rawHealthRecords)
          ..where((r) =>
              (r.recordType.equals('RESTING_HEART_RATE') |
                  r.recordType.equals('HEART_RATE')) &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();
  }

  /// Get the max HR observed during exercise sessions in a trailing window.
  Future<double?> getMaxExerciseHr({
    required DateTime start,
    required DateTime end,
  }) async {
    final records = await (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('HEART_RATE') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.desc(r.value)])
          ..limit(1))
        .get();
    return records.isEmpty ? null : records.first.value;
  }

  /// Get sleep session records for baseline computation.
  Future<List<RawHealthRecord>> getSleepRecords({
    required DateTime start,
    required DateTime end,
  }) async {
    return (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('SLEEP_SESSION') &
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

  /// Get total steps within a date range.
  Future<int> getTotalSteps({required DateTime start, required DateTime end}) async {
    final records = await getRecordsByType('STEPS', start: start, end: end);
    double sum = 0;
    for (final r in records) {
      sum += r.value;
    }
    return sum.round();
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
    return records.isEmpty ? null : records.first.value;
  }

  /// Get sleep stages records within a date range.
  Future<List<RawHealthRecord>> getSleepStages({
    required DateTime start,
    required DateTime end,
  }) async {
    return (select(rawHealthRecords)
          ..where((r) =>
              (r.recordType.equals('SLEEP_DEEP') |
                  r.recordType.equals('SLEEP_LIGHT') |
                  r.recordType.equals('SLEEP_REM') |
                  r.recordType.equals('SLEEP_AWAKE') |
                  r.recordType.equals('SLEEP_ASLEEP') |
                  r.recordType.equals('SLEEP_SESSION')) &
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
}
