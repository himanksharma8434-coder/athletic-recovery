import '../entities/health_record.dart';

/// Abstract interface for the health data source.
/// Wraps Health Connect (Android) and HealthKit (iOS) behind a
/// testable seam so the Cubit layer never talks to the platform directly.
abstract class HealthSourceRepository {
  /// Request read authorization for all configured health data types.
  Future<bool> requestPermissions();

  /// Check whether all required permissions are currently granted.
  Future<bool> hasPermissions();

  /// Check whether background-read permission is granted (Android 14+ only).
  /// Always returns false on iOS or older Android.
  Future<bool> hasBackgroundReadPermission();

  /// Fetch health records from the platform store.
  /// [startTime] and [endTime] define the query window.
  Future<List<HealthRecord>> fetchRecords({
    required DateTime startTime,
    required DateTime endTime,
  });

  /// Perform a delta sync: read new data since last sync, upsert to local DB,
  /// recompute baselines and derived metrics.
  /// Returns the number of new records written.
  Future<int> syncHealthData({required String taskType});

  /// Get the latest derived metrics for the dashboard.
  Future<DerivedMetricSummary?> getLatestSummary();

  /// Stream of the latest derived metrics for reactive UI.
  Stream<DerivedMetricSummary?> watchLatestSummary();
}

/// Breakdown of sleep architecture stages from wearable sensors.
class SleepStageBreakdown {
  final int deepMinutes;
  final int remMinutes;
  final int lightMinutes;
  final int awakeMinutes;

  const SleepStageBreakdown({
    this.deepMinutes = 0,
    this.remMinutes = 0,
    this.lightMinutes = 0,
    this.awakeMinutes = 0,
  });

  int get totalTrackedMinutes =>
      deepMinutes + remMinutes + lightMinutes + awakeMinutes;

  double get deepPercentage =>
      totalTrackedMinutes > 0 ? (deepMinutes / totalTrackedMinutes) * 100 : 0;

  double get remPercentage =>
      totalTrackedMinutes > 0 ? (remMinutes / totalTrackedMinutes) * 100 : 0;

  double get lightPercentage =>
      totalTrackedMinutes > 0 ? (lightMinutes / totalTrackedMinutes) * 100 : 0;

  double get awakePercentage =>
      totalTrackedMinutes > 0 ? (awakeMinutes / totalTrackedMinutes) * 100 : 0;

  bool get hasStageData => (deepMinutes + remMinutes + lightMinutes) > 0;
}

/// Real workout session logged by wearable / Health Connect.
class WorkoutSessionSummary {
  final String title;
  final int durationMinutes;
  final double? calories;
  final DateTime startTime;

  const WorkoutSessionSummary({
    required this.title,
    required this.durationMinutes,
    this.calories,
    required this.startTime,
  });
}

/// Single point in historical trend.
class HistoricalScorePoint {
  final DateTime date;
  final double score;

  const HistoricalScorePoint({required this.date, required this.score});
}

/// Summary object for the dashboard and all tabs. 100% computed from real data.
class DerivedMetricSummary {
  final double? recoveryScore;
  final double? recoveryComponentRhr;
  final double? recoveryComponentSleep;
  final double? recoveryComponentSpo2;
  final String? primaryFactor;
  final double? estimatedVo2Max;
  final double? restingHr;
  final double? baselineRestingHr;
  final double? sleepHours;
  final double? baselineSleepHours;
  final double? spo2;
  final double? baselineSpo2;
  final double? hrvMs;
  final double? dayStrain;
  final double? targetStrain;
  final double? activeCalories;
  final double? totalCalories;
  final int? todaySteps;
  final SleepStageBreakdown? sleepStages;
  final List<WorkoutSessionSummary> workouts;
  final List<HistoricalScorePoint> recoveryHistory14d;
  final int totalRecords;
  final DateTime? lastSyncedAt;

  const DerivedMetricSummary({
    this.recoveryScore,
    this.recoveryComponentRhr,
    this.recoveryComponentSleep,
    this.recoveryComponentSpo2,
    this.primaryFactor,
    this.estimatedVo2Max,
    this.restingHr,
    this.baselineRestingHr,
    this.sleepHours,
    this.baselineSleepHours,
    this.spo2,
    this.baselineSpo2,
    this.hrvMs,
    this.dayStrain,
    this.targetStrain,
    this.activeCalories,
    this.totalCalories,
    this.todaySteps,
    this.sleepStages,
    this.workouts = const [],
    this.recoveryHistory14d = const [],
    this.totalRecords = 0,
    this.lastSyncedAt,
  });
}
