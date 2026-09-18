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

  test('RawHealthRecords handles conflict on (recordType, sourceId, startTime)', () async {
    final now = DateTime.now();
    final companion1 = RawHealthRecordsCompanion.insert(
      recordType: 'HEART_RATE',
      value: 80.0,
      unit: 'BEATS_PER_MINUTE',
      startTime: now,
      endTime: now,
      sourceId: 'com.nothing.smartcenter',
      syncedAt: now,
    );
    final companion2 = RawHealthRecordsCompanion.insert(
      recordType: 'HEART_RATE',
      value: 83.0,
      unit: 'BEATS_PER_MINUTE',
      startTime: now,
      endTime: now,
      sourceId: 'com.nothing.smartcenter',
      syncedAt: now,
    );

    await db.healthRecordDao.upsertRecords([companion1]);
    await db.healthRecordDao.upsertRecords([companion2]);

    final records = await db.healthRecordDao.getRecordsByType(
      'HEART_RATE',
      start: now.subtract(const Duration(minutes: 1)),
      end: now.add(const Duration(minutes: 1)),
    );

    expect(records.length, 1);
    expect(records.first.value, 83.0);
  });

  test('DailyBaselines handles conflict on date', () async {
    final today = DateTime(2026, 9, 18);
    await db.baselineDao.upsertBaseline(DailyBaselinesCompanion.insert(
      date: today,
      restingHrBaseline7d: const Value(58.0),
    ));
    await db.baselineDao.upsertBaseline(DailyBaselinesCompanion.insert(
      date: today,
      restingHrBaseline7d: const Value(56.0),
    ));

    final baseline = await db.baselineDao.getBaseline(today);
    expect(baseline?.restingHrBaseline7d, 56.0);
  });

  test('DerivedMetrics handles conflict on date', () async {
    final today = DateTime(2026, 9, 18);
    await db.derivedMetricDao.upsertMetric(DerivedMetricsCompanion.insert(
      date: today,
      recoveryScore: const Value(85.0),
    ));
    await db.derivedMetricDao.upsertMetric(DerivedMetricsCompanion.insert(
      date: today,
      recoveryScore: const Value(92.0),
    ));

    final metric = await db.derivedMetricDao.getMetric(today);
    expect(metric?.recoveryScore, 92.0);
  });

  test('SyncMetadata handles conflict on recordType', () async {
    final now1 = DateTime(2026, 9, 18, 10, 0);
    final now2 = DateTime(2026, 9, 18, 12, 0);

    await db.syncDao.updateLastSyncedAt('HEART_RATE', now1);
    await db.syncDao.updateLastSyncedAt('HEART_RATE', now2);

    final lastSync = await db.syncDao.getLastSyncedAt('HEART_RATE');
    expect(lastSync, now2);
  });
}
