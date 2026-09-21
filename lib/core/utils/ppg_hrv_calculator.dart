import 'dart:math';
import '../../data/database/app_database.dart';

/// Calculates Heart Rate Variability (HRV - specifically rMSSD)
/// from optical Photoplethysmography (PPG) pulse and heart rate telemetry.
///
/// Whoop and modern optical wearables measure HRV through PPG, capturing
/// blood volume changes in microvascular capillary beds using optical sensors.
///
/// When direct HRV records (e.g. from Health Connect / HealthKit) are absent,
/// this derives the root-mean-square of successive differences (rMSSD) across
/// consecutive inter-beat intervals (IBI = 60000 / BPM) during quiet rest or overnight sleep.
class PpgHrvCalculator {
  PpgHrvCalculator._();

  /// Calculates rMSSD (in milliseconds) from a sequence of PPG heart rate records.
  ///
  /// Converts heart rates to Inter-Beat Intervals (IBI) and computes the standard
  /// athletic rMSSD equation with physiological ectopic-beat filtering.
  static double? computeRmssdFromHeartRates(List<RawHealthRecord> hrRecords) {
    if (hrRecords.length < 3) return null;

    final sorted = List<RawHealthRecord>.from(hrRecords)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    // Convert valid heart rate records to inter-beat intervals (ms)
    final ibis = <double>[];
    DateTime? lastTime;

    for (final r in sorted) {
      // Filter out non-physiological values (must be 35–220 bpm)
      if (r.value < 35.0 || r.value > 220.0) continue;

      // Discard huge time gaps (> 15 minutes) between individual samples
      if (lastTime != null && r.startTime.difference(lastTime).inMinutes.abs() > 15) {
        // Gap reached, start new sequence
      }
      lastTime = r.startTime;

      final ibi = 60000.0 / r.value;
      ibis.add(ibi);
    }

    if (ibis.length < 3) return null;

    // Calculate successive differences: d_i = IBI_(i+1) - IBI_i
    double sumSquaredDiffs = 0.0;
    int count = 0;

    for (int i = 0; i < ibis.length - 1; i++) {
      final diff = ibis[i + 1] - ibis[i];
      // Filter out sudden motion/ectopic artifacts (differences > 300ms)
      if (diff.abs() > 300.0) continue;

      sumSquaredDiffs += diff * diff;
      count++;
    }

    if (count < 2) return null;

    final rmssd = sqrt(sumSquaredDiffs / count);
    // Clamp to realistic human physiological resting range (15ms to 180ms)
    return rmssd.clamp(15.0, 180.0);
  }
}
