import 'package:flutter_test/flutter_test.dart';
import 'package:whoop/core/utils/ppg_hrv_calculator.dart';
import 'package:whoop/data/database/app_database.dart';

void main() {
  group('PpgHrvCalculator', () {
    test('returns null when fewer than 3 records', () {
      final records = [
        RawHealthRecord(
          id: 1,
          recordType: 'HEART_RATE',
          value: 60.0,
          unit: 'BEATS_PER_MINUTE',
          startTime: DateTime(2026, 9, 21, 2, 0),
          endTime: DateTime(2026, 9, 21, 2, 1),
          sourceId: 'test_ppg',
          syncedAt: DateTime(2026, 9, 21, 2, 1),
        ),
      ];
      final result = PpgHrvCalculator.computeRmssdFromHeartRates(records);
      expect(result, isNull);
    });

    test('computes realistic rMSSD from physiological PPG pulse fluctuations', () {
      // Overnight heart rate samples with physiological fluctuations
      // HR: 60, 58, 62, 59, 61, 58 bpm
      // IBI: 1000, 1034.5, 967.7, 1016.9, 983.6, 1034.5 ms
      final base = DateTime(2026, 9, 21, 2, 0);
      final rates = [60.0, 58.0, 62.0, 59.0, 61.0, 58.0];
      final records = List.generate(rates.length, (i) {
        return RawHealthRecord(
          id: i,
          recordType: 'HEART_RATE',
          value: rates[i],
          unit: 'BEATS_PER_MINUTE',
          startTime: base.add(Duration(minutes: i * 2)),
          endTime: base.add(Duration(minutes: i * 2, seconds: 30)),
          sourceId: 'test_ppg',
          syncedAt: base.add(Duration(minutes: i * 2, seconds: 30)),
        );
      });

      final result = PpgHrvCalculator.computeRmssdFromHeartRates(records);
      expect(result, isNotNull);
      // Expected rMSSD should be in typical physiological range (40–70 ms)
      expect(result!, greaterThanOrEqualTo(30.0));
      expect(result, lessThanOrEqualTo(100.0));
    });

    test('filters out non-physiological values (e.g. 0 or 250 bpm)', () {
      final base = DateTime(2026, 9, 21, 3, 0);
      final rates = [60.0, 0.0, 58.0, 250.0, 62.0, 59.0];
      final records = List.generate(rates.length, (i) {
        return RawHealthRecord(
          id: i,
          recordType: 'HEART_RATE',
          value: rates[i],
          unit: 'BEATS_PER_MINUTE',
          startTime: base.add(Duration(minutes: i * 2)),
          endTime: base.add(Duration(minutes: i * 2, seconds: 30)),
          sourceId: 'test_ppg',
          syncedAt: base.add(Duration(minutes: i * 2, seconds: 30)),
        );
      });

      final result = PpgHrvCalculator.computeRmssdFromHeartRates(records);
      expect(result, isNotNull);
      expect(result!, inInclusiveRange(15.0, 180.0));
    });
  });
}
