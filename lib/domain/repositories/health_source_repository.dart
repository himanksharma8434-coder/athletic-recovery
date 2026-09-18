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

/// Summary object for the dashboard.
class DerivedMetricSummary {
  final double? recoveryScore;
  final double? recoveryComponentRhr;
  final double? recoveryComponentSleep;
  final double? recoveryComponentSpo2;
  final String? primaryFactor;
  final double? estimatedVo2Max;
  final double? restingHr;
  final double? sleepHours;
  final double? spo2;
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
    this.sleepHours,
    this.spo2,
    this.totalRecords = 0,
    this.lastSyncedAt,
  });
}
