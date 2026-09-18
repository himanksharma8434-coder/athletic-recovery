import 'dart:math';

/// Computes rolling baselines from raw health records.
///
/// All functions are pure — they take lists of values and return
/// computed baselines without touching the database.
class ComputeBaselines {
  const ComputeBaselines();

  /// Compute the median of a list of values.
  /// More robust than mean against outlier readings.
  double? median(List<double> values) {
    if (values.isEmpty) return null;
    final sorted = List<double>.from(values)..sort();
    final mid = sorted.length ~/ 2;
    if (sorted.length.isOdd) return sorted[mid];
    return (sorted[mid - 1] + sorted[mid]) / 2;
  }

  /// Compute resting HR baseline from daily minimum RHR values.
  ///
  /// [dailyMinRhrs]: list of the minimum resting HR per day in the window.
  /// Returns the median of daily minimums (not a single instantaneous low).
  double? restingHrBaseline(List<double> dailyMinRhrs) {
    return median(dailyMinRhrs);
  }

  /// Compute sleep duration baseline from nightly durations (in minutes).
  double? sleepDurationBaseline(List<double> nightlyDurationsMinutes) {
    if (nightlyDurationsMinutes.isEmpty) return null;
    return nightlyDurationsMinutes.reduce((a, b) => a + b) /
        nightlyDurationsMinutes.length;
  }

  /// Compute SpO2 baseline from daily readings (percentage).
  double? spo2Baseline(List<double> dailySpo2Values) {
    if (dailySpo2Values.isEmpty) return null;
    return dailySpo2Values.reduce((a, b) => a + b) / dailySpo2Values.length;
  }

  /// Group records by date and extract daily minimum values.
  List<double> extractDailyMinimums(
      List<({DateTime date, double value})> records) {
    final byDay = <String, List<double>>{};
    for (final r in records) {
      final key =
          '${r.date.year}-${r.date.month.toString().padLeft(2, '0')}-${r.date.day.toString().padLeft(2, '0')}';
      byDay.putIfAbsent(key, () => []).add(r.value);
    }
    return byDay.values.map((vals) => vals.reduce(min)).toList();
  }
}
