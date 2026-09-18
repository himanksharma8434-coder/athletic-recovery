import 'package:flutter_test/flutter_test.dart';
import 'package:whoop/domain/usecases/compute_baselines.dart';

void main() {
  const computeBaselines = ComputeBaselines();

  group('ComputeBaselines', () {
    test('median returns null for empty list', () {
      expect(computeBaselines.median([]), isNull);
    });

    test('median computes odd-length correctly', () {
      expect(computeBaselines.median([50, 45, 60]), 50.0);
    });

    test('median computes even-length correctly', () {
      expect(computeBaselines.median([50, 40, 60, 70]), 55.0);
    });

    test('restingHrBaseline uses median of daily minimums', () {
      final rhrs = [48.0, 52.0, 49.0, 47.0, 50.0, 51.0, 48.0];
      final baseline = computeBaselines.restingHrBaseline(rhrs);
      expect(baseline, 49.0);
    });

    test('sleepDurationBaseline computes average in minutes', () {
      final sleepMinutes = [480.0, 420.0, 450.0]; // 8h, 7h, 7.5h
      final baseline = computeBaselines.sleepDurationBaseline(sleepMinutes);
      expect(baseline, 450.0);
    });

    test('spo2Baseline computes average percentage', () {
      final spo2 = [98.0, 97.0, 99.0];
      final baseline = computeBaselines.spo2Baseline(spo2);
      expect(baseline, 98.0);
    });

    test('extractDailyMinimums groups by calendar date and finds min', () {
      final day1 = DateTime(2026, 10, 24, 8, 30);
      final day1Later = DateTime(2026, 10, 24, 14, 0);
      final day2 = DateTime(2026, 10, 25, 9, 0);

      final records = [
        (date: day1, value: 55.0),
        (date: day1Later, value: 48.0),
        (date: day2, value: 51.0),
      ];

      final dailyMins = computeBaselines.extractDailyMinimums(records);
      expect(dailyMins, [48.0, 51.0]);
    });
  });
}
