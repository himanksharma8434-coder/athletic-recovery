import 'package:health/health.dart';

/// Central definition of all health data types this app reads.
///
/// The Nothing X / CMF Watch surfaces these via Health Connect:
/// HeartRate, RestingHeartRate, SleepSession, OxygenSaturation,
/// Steps, ExerciseSession, TotalCaloriesBurned.
///
/// HRV, VO2max, stress, and recovery are NOT available from the
/// wearable and must be computed locally.
class HealthTypes {
  HealthTypes._();

  /// Types we request read permission for.
  static const List<HealthDataType> requestedTypes = [
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.STEPS,
    HealthDataType.WORKOUT,
    HealthDataType.TOTAL_CALORIES_BURNED,
  ];

  /// All requested as READ-only.
  static List<HealthDataAccess> get permissions =>
      requestedTypes.map((_) => HealthDataAccess.READ).toList();

  /// Types that are recorded as simple numeric values.
  static const List<HealthDataType> numericTypes = [
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.STEPS,
    HealthDataType.TOTAL_CALORIES_BURNED,
  ];

  /// Maximum historical lookback on first sync (Health Connect allows ~30 days).
  static const Duration initialLookback = Duration(days: 30);
}
