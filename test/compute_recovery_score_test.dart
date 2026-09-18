import 'package:flutter_test/flutter_test.dart';
import 'package:whoop/domain/usecases/compute_recovery_score.dart';

void main() {
  const computeRecoveryScore = ComputeRecoveryScore();

  group('ComputeRecoveryScore', () {
    test('all metrics at baseline → score ~100', () {
      final result = computeRecoveryScore(
        todayRhr: 60,
        rhrBaseline7d: 60,
        lastNightSleepMinutes: 480, // 8 hours
        sleepBaseline7d: 480,
        todaySpo2: 97,
        spo2Baseline7d: 97,
      );
      expect(result.score, closeTo(100, 1));
      expect(result.rhrComponent, closeTo(100, 1));
      expect(result.sleepComponent, closeTo(100, 1));
      expect(result.spo2Component, closeTo(100, 1));
      expect(result.primaryFactor, contains('Great recovery'));
    });

    test('RHR 10% above baseline → score drops, RHR is primary factor', () {
      final result = computeRecoveryScore(
        todayRhr: 66, // 10% above 60
        rhrBaseline7d: 60,
        lastNightSleepMinutes: 480,
        sleepBaseline7d: 480,
        todaySpo2: 97,
        spo2Baseline7d: 97,
      );
      // RHR component: (1 - 0.10/0.20) * 100 = 50
      expect(result.rhrComponent, closeTo(50, 1));
      expect(result.sleepComponent, closeTo(100, 1));
      expect(result.spo2Component, closeTo(100, 1));
      // Weighted: 50*0.5 + 100*0.35 + 100*0.15 = 25 + 35 + 15 = 75
      expect(result.score, closeTo(75, 1));
    });

    test('RHR 20%+ above baseline → RHR component = 0', () {
      final result = computeRecoveryScore(
        todayRhr: 72, // 20% above 60
        rhrBaseline7d: 60,
        lastNightSleepMinutes: 480,
        sleepBaseline7d: 480,
        todaySpo2: 97,
        spo2Baseline7d: 97,
      );
      expect(result.rhrComponent, closeTo(0, 1));
      // Weighted: 0*0.5 + 100*0.35 + 100*0.15 = 50
      expect(result.score, closeTo(50, 1));
      expect(result.primaryFactor, contains('heart rate'));
    });

    test('poor sleep → sleep component drops', () {
      final result = computeRecoveryScore(
        todayRhr: 60,
        rhrBaseline7d: 60,
        lastNightSleepMinutes: 300, // 5 hours, baseline is 8
        sleepBaseline7d: 480,
        todaySpo2: 97,
        spo2Baseline7d: 97,
      );
      // Sleep ratio: 300/480 ≈ 0.625
      // Sleep score: (0.625 - 0.5) / 0.5 = 0.25 → 25
      expect(result.sleepComponent, closeTo(25, 1));
      expect(result.primaryFactor, contains('Sleep'));
    });

    test('SpO2 dip → minor penalty', () {
      final result = computeRecoveryScore(
        todayRhr: 60,
        rhrBaseline7d: 60,
        lastNightSleepMinutes: 480,
        sleepBaseline7d: 480,
        todaySpo2: 94, // 3% drop from 97
        spo2Baseline7d: 97,
      );
      // SpO2 score: (1 - 3/5) * 100 = 40
      expect(result.spo2Component, closeTo(40, 1));
      // Weighted: 100*0.5 + 100*0.35 + 40*0.15 = 50+35+6 = 91
      expect(result.score, closeTo(91, 1));
    });

    test('all metrics below baseline → low score', () {
      final result = computeRecoveryScore(
        todayRhr: 72, // 20% above
        rhrBaseline7d: 60,
        lastNightSleepMinutes: 240, // 4 hours, very poor
        sleepBaseline7d: 480,
        todaySpo2: 92, // 5% drop
        spo2Baseline7d: 97,
      );
      expect(result.rhrComponent, closeTo(0, 1));
      expect(result.sleepComponent, closeTo(0, 1));
      expect(result.spo2Component, closeTo(0, 1));
      expect(result.score, closeTo(0, 1));
    });

    test('handles missing RHR data gracefully', () {
      final result = computeRecoveryScore(
        todayRhr: null,
        rhrBaseline7d: null,
        lastNightSleepMinutes: 480,
        sleepBaseline7d: 480,
        todaySpo2: 97,
        spo2Baseline7d: 97,
      );
      // Only sleep and SpO2, re-weighted
      expect(result.score, closeTo(100, 1));
      expect(result.rhrComponent, closeTo(50, 1)); // default neutral
    });

    test('handles all data missing → neutral score', () {
      final result = computeRecoveryScore(
        todayRhr: null,
        rhrBaseline7d: null,
        lastNightSleepMinutes: null,
        sleepBaseline7d: null,
        todaySpo2: null,
        spo2Baseline7d: null,
      );
      expect(result.score, closeTo(50, 1));
      expect(result.primaryFactor, contains('Insufficient'));
    });

    test('RHR below baseline → score = 100 (clamped)', () {
      final result = computeRecoveryScore(
        todayRhr: 55, // below baseline of 60
        rhrBaseline7d: 60,
        lastNightSleepMinutes: 480,
        sleepBaseline7d: 480,
        todaySpo2: 97,
        spo2Baseline7d: 97,
      );
      expect(result.rhrComponent, closeTo(100, 1));
    });
  });
}
