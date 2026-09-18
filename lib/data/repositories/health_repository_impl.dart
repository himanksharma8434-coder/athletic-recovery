import 'package:drift/drift.dart';

import '../../core/constants/health_types.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/entities/health_record.dart';
import '../../domain/repositories/health_source_repository.dart';
import '../../domain/usecases/compute_baselines.dart';
import '../../domain/usecases/compute_vo2max.dart';
import '../../domain/usecases/compute_recovery_score.dart';
import '../database/app_database.dart';
import '../datasources/health_platform_datasource.dart';

/// Concrete implementation of [HealthSourceRepository].
/// Orchestrates: platform reads → local DB upserts → baseline/metric recomputation.
class HealthRepositoryImpl implements HealthSourceRepository {
  final HealthPlatformDatasource _platform;
  final AppDatabase _db;
  final ComputeBaselines _computeBaselines;
  final ComputeVo2Max _computeVo2Max;
  final ComputeRecoveryScore _computeRecoveryScore;

  HealthRepositoryImpl({
    required HealthPlatformDatasource platform,
    required AppDatabase db,
    ComputeBaselines? computeBaselines,
    ComputeVo2Max? computeVo2Max,
    ComputeRecoveryScore? computeRecoveryScore,
  // ignore: prefer_initializing_formals
  })  : _platform = platform,
        // ignore: prefer_initializing_formals
        _db = db,
        _computeBaselines = computeBaselines ?? const ComputeBaselines(),
        _computeVo2Max = computeVo2Max ?? const ComputeVo2Max(),
        _computeRecoveryScore =
            computeRecoveryScore ?? const ComputeRecoveryScore();

  @override
  Future<bool> requestPermissions() async {
    await _platform.configure();
    return _platform.requestPermissions();
  }

  @override
  Future<bool> hasPermissions() => _platform.hasPermissions();

  @override
  Future<bool> hasBackgroundReadPermission() =>
      _platform.hasBackgroundReadPermission();

  @override
  Future<List<HealthRecord>> fetchRecords({
    required DateTime startTime,
    required DateTime endTime,
  }) {
    return _platform.fetchRecords(startTime: startTime, endTime: endTime);
  }

  @override
  Future<int> syncHealthData({required String taskType}) async {
    final syncDao = _db.syncDao;
    final recordDao = _db.healthRecordDao;
    final now = DateTime.now();
    int totalWritten = 0;

    try {
      await _platform.configure();

      // For each health data type, do a delta sync
      for (final type in HealthTypes.requestedTypes) {
        final typeName = type.name;
        final lastSynced = await syncDao.getLastSyncedAt(typeName);

        // First sync: use initial lookback window
        final startTime = lastSynced ??
            now.subtract(HealthTypes.initialLookback);

        final records = await _platform.fetchRecords(
          startTime: startTime,
          endTime: now,
        );

        // Filter to only this type's records
        final typeRecords =
            records.where((r) => r.recordType == typeName).toList();

        if (typeRecords.isNotEmpty) {
          // Upsert into Drift
          final companions = typeRecords
              .map((r) => RawHealthRecordsCompanion(
                    recordType: Value(r.recordType),
                    value: Value(r.value),
                    valueSecondary: Value(r.valueSecondary),
                    unit: Value(r.unit),
                    startTime: Value(r.startTime),
                    endTime: Value(r.endTime),
                    sourceId: Value(r.sourceId),
                    syncedAt: Value(r.syncedAt),
                  ))
              .toList();

          await recordDao.upsertRecords(companions);
          totalWritten += typeRecords.length;

          // Update lastSyncedAt ONLY after successful write
          await syncDao.updateLastSyncedAt(typeName, now);
        }
      }

      // Recompute baselines and derived metrics
      await _recomputeBaselines(now);
      await _recomputeDerivedMetrics(now);

      // Log success
      await syncDao.logSync(
        taskType: taskType,
        recordsRead: totalWritten,
        recordsWritten: totalWritten,
        success: true,
      );

      return totalWritten;
    } catch (e) {
      // Log failure — leave lastSyncedAt untouched so next run retries
      await syncDao.logSync(
        taskType: taskType,
        recordsRead: 0,
        recordsWritten: 0,
        success: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  /// Recompute 7-day and 30-day baselines for today.
  Future<void> _recomputeBaselines(DateTime now) async {
    final today = AppDateUtils.startOfDay(now);
    final recordDao = _db.healthRecordDao;
    final baselineDao = _db.baselineDao;

    // ── Resting HR baselines ──
    final rhrRecords7d = await recordDao.getRestingHrRecords(
      start: AppDateUtils.daysAgo(7, from: now),
      end: now,
    );
    final rhrRecords30d = await recordDao.getRestingHrRecords(
      start: AppDateUtils.daysAgo(30, from: now),
      end: now,
    );

    final dailyMins7d = _computeBaselines.extractDailyMinimums(
        rhrRecords7d.map((r) => (date: r.startTime, value: r.value)).toList());
    final dailyMins30d = _computeBaselines.extractDailyMinimums(
        rhrRecords30d
            .map((r) => (date: r.startTime, value: r.value))
            .toList());

    // ── Sleep baseline ──
    final sleepRecords = await recordDao.getSleepRecords(
      start: AppDateUtils.daysAgo(7, from: now),
      end: now,
    );
    final sleepDurations = sleepRecords.map((r) => r.value).toList();

    // ── SpO2 baseline ──
    final spo2Records = await recordDao.getSpo2Records(
      start: AppDateUtils.daysAgo(7, from: now),
      end: now,
    );
    final spo2Values = spo2Records.map((r) => r.value).toList();

    await baselineDao.upsertBaseline(DailyBaselinesCompanion(
      date: Value(today),
      restingHrBaseline7d:
          Value(_computeBaselines.restingHrBaseline(dailyMins7d)),
      restingHrBaseline30d:
          Value(_computeBaselines.restingHrBaseline(dailyMins30d)),
      sleepDurationBaseline7d:
          Value(_computeBaselines.sleepDurationBaseline(sleepDurations)),
      spo2Baseline7d: Value(_computeBaselines.spo2Baseline(spo2Values)),
    ));
  }

  /// Recompute VO2max and recovery score for today.
  Future<void> _recomputeDerivedMetrics(DateTime now) async {
    final today = AppDateUtils.startOfDay(now);
    final recordDao = _db.healthRecordDao;
    final baselineDao = _db.baselineDao;
    final metricDao = _db.derivedMetricDao;

    final baseline = await baselineDao.getBaseline(today);
    if (baseline == null) return;

    // ── VO2max ──
    final maxHr = await recordDao.getMaxExerciseHr(
      start: AppDateUtils.daysAgo(60, from: now),
      end: now,
    );

    // Determine age from health platform if no exercise max HR is available
    int? userAge;
    if (maxHr == null) {
      final dob = await _platform.fetchDateOfBirth();
      if (dob != null) {
        userAge = (now.difference(dob).inDays / 365.25).floor();
      }
    }

    final vo2max = _computeVo2Max(
      restingHr7dBaseline: baseline.restingHrBaseline7d,
      maxHrFromExercise: maxHr,
      userAge: userAge,
    );

    // ── Recovery Score ──
    // Get today's latest RHR
    final todayRhrRecords = await recordDao.getRecordsByType(
      'RESTING_HEART_RATE',
      start: today,
      end: now,
    );
    final todayRhr = todayRhrRecords.isEmpty ? null : todayRhrRecords.last.value;

    // Get last night's sleep
    final yesterday = today.subtract(const Duration(days: 1));
    final sleepRecords = await recordDao.getSleepRecords(
      start: yesterday,
      end: today,
    );
    final lastNightSleep =
        sleepRecords.isEmpty ? null : sleepRecords.last.value;

    // Get today's SpO2
    final spo2Records = await recordDao.getSpo2Records(
      start: today,
      end: now,
    );
    final todaySpo2 = spo2Records.isEmpty ? null : spo2Records.last.value;

    final recovery = _computeRecoveryScore(
      todayRhr: todayRhr,
      rhrBaseline7d: baseline.restingHrBaseline7d,
      lastNightSleepMinutes: lastNightSleep,
      sleepBaseline7d: baseline.sleepDurationBaseline7d,
      todaySpo2: todaySpo2,
      spo2Baseline7d: baseline.spo2Baseline7d,
    );

    await metricDao.upsertMetric(DerivedMetricsCompanion(
      date: Value(today),
      estimatedVo2Max: Value(vo2max),
      recoveryScore: Value(recovery.score),
      recoveryComponentRhr: Value(recovery.rhrComponent),
      recoveryComponentSleep: Value(recovery.sleepComponent),
      recoveryComponentSpo2: Value(recovery.spo2Component),
      primaryFactor: Value(recovery.primaryFactor),
    ));
  }

  @override
  Future<DerivedMetricSummary?> getLatestSummary() async {
    final metric = await _db.derivedMetricDao.getLatestMetric();
    final baseline = await _db.baselineDao.getLatestBaseline();
    final recordCount = await _db.healthRecordDao.getRecordCount();

    if (metric == null) return null;

    // Get the most recent sync timestamp
    DateTime? lastSync;
    final logs = await _db.syncDao.getRecentLogs(limit: 1);
    if (logs.isNotEmpty) lastSync = logs.first.timestamp;

    return DerivedMetricSummary(
      recoveryScore: metric.recoveryScore,
      recoveryComponentRhr: metric.recoveryComponentRhr,
      recoveryComponentSleep: metric.recoveryComponentSleep,
      recoveryComponentSpo2: metric.recoveryComponentSpo2,
      primaryFactor: metric.primaryFactor,
      estimatedVo2Max: metric.estimatedVo2Max,
      restingHr: baseline?.restingHrBaseline7d,
      sleepHours: baseline?.sleepDurationBaseline7d != null
          ? baseline!.sleepDurationBaseline7d! / 60.0
          : null,
      spo2: baseline?.spo2Baseline7d,
      totalRecords: recordCount,
      lastSyncedAt: lastSync,
    );
  }

  @override
  Stream<DerivedMetricSummary?> watchLatestSummary() {
    return _db.derivedMetricDao.watchLatestMetric().asyncMap((metric) async {
      if (metric == null) return null;
      return getLatestSummary();
    });
  }
}
