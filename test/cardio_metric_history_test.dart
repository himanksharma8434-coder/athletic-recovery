import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whoop/data/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Cardio Metric History Queries', () {
    test('getDailyVo2MaxHistory retrieves sorted points with period filters', () async {
      final now = DateTime.now();
      // Insert derived metrics for today, 3 days ago, and 40 days ago
      await db.derivedMetricDao.upsertMetric(
        DerivedMetricsCompanion.insert(
          date: now.subtract(const Duration(days: 40)),
          estimatedVo2Max: const Value(48.5),
        ),
      );
      await db.derivedMetricDao.upsertMetric(
        DerivedMetricsCompanion.insert(
          date: now.subtract(const Duration(days: 3)),
          estimatedVo2Max: const Value(52.0),
        ),
      );
      await db.derivedMetricDao.upsertMetric(
        DerivedMetricsCompanion.insert(
          date: now,
          estimatedVo2Max: const Value(55.5),
        ),
      );

      // 7D should return 2 points
      final points7d = await db.derivedMetricDao.getDailyVo2MaxHistory(7);
      expect(points7d.length, 2);
      expect(points7d.first.value, 52.0);
      expect(points7d.last.value, 55.5);

      // 30D should return 2 points
      final points30d = await db.derivedMetricDao.getDailyVo2MaxHistory(30);
      expect(points30d.length, 2);

      // ALL should return 3 points
      final pointsAll = await db.derivedMetricDao.getDailyVo2MaxHistory(null);
      expect(pointsAll.length, 3);
      expect(pointsAll.first.value, 48.5);
      expect(pointsAll.last.value, 55.5);
    });

    test('getDailyMaxHeartRates retrieves daily peak workout/exercise HR', () async {
      final now = DateTime.now();
      await db.healthRecordDao.upsertRecords([
        RawHealthRecordsCompanion.insert(
          recordType: 'HEART_RATE',
          value: 140.0,
          unit: 'BEATS_PER_MINUTE',
          startTime: now.subtract(const Duration(days: 2, hours: 2)),
          endTime: now.subtract(const Duration(days: 2, hours: 2)),
          sourceId: 'test',
          syncedAt: now,
        ),
        RawHealthRecordsCompanion.insert(
          recordType: 'HEART_RATE',
          value: 185.0,
          unit: 'BEATS_PER_MINUTE',
          startTime: now.subtract(const Duration(days: 2, hours: 1)),
          endTime: now.subtract(const Duration(days: 2, hours: 1)),
          sourceId: 'test',
          syncedAt: now,
        ),
        RawHealthRecordsCompanion.insert(
          recordType: 'HEART_RATE',
          value: 172.0,
          unit: 'BEATS_PER_MINUTE',
          startTime: now,
          endTime: now,
          sourceId: 'test',
          syncedAt: now,
        ),
      ]);

      final points = await db.healthRecordDao.getDailyMaxHeartRates(7);
      expect(points.length, 2);
      // Day -2 max is 185, today is 172
      expect(points.first.value, 185.0);
      expect(points.last.value, 172.0);
    });

    test('getDailyRestingHeartRates retrieves daily resting HR with fallback', () async {
      final now = DateTime.now();
      await db.healthRecordDao.upsertRecords([
        RawHealthRecordsCompanion.insert(
          recordType: 'RESTING_HEART_RATE',
          value: 52.0,
          unit: 'BEATS_PER_MINUTE',
          startTime: now.subtract(const Duration(days: 1)),
          endTime: now.subtract(const Duration(days: 1)),
          sourceId: 'test',
          syncedAt: now,
        ),
        RawHealthRecordsCompanion.insert(
          recordType: 'RESTING_HEART_RATE',
          value: 54.0,
          unit: 'BEATS_PER_MINUTE',
          startTime: now,
          endTime: now,
          sourceId: 'test',
          syncedAt: now,
        ),
      ]);

      final points = await db.healthRecordDao.getDailyRestingHeartRates(7);
      expect(points.length, 2);
      expect(points.first.value, 52.0);
      expect(points.last.value, 54.0);
    });
  });
}
