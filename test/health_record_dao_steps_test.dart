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

  group('HealthRecordDao.getTotalSteps (Day-Only & Sanitization)', () {
    final todayStart = DateTime(2026, 9, 21, 0, 0, 0);
    final now = DateTime(2026, 9, 21, 18, 0, 0);

    test('Single source delta records are summed correctly', () async {
      await db.healthRecordDao.upsertRecords([
        RawHealthRecordsCompanion.insert(
          recordType: 'STEPS',
          value: 1200.0,
          unit: 'COUNT',
          startTime: DateTime(2026, 9, 21, 8, 0),
          endTime: DateTime(2026, 9, 21, 9, 0),
          sourceId: 'com.nothing.hearth',
          syncedAt: now,
        ),
        RawHealthRecordsCompanion.insert(
          recordType: 'STEPS',
          value: 2300.0,
          unit: 'COUNT',
          startTime: DateTime(2026, 9, 21, 12, 0),
          endTime: DateTime(2026, 9, 21, 13, 0),
          sourceId: 'com.nothing.hearth',
          syncedAt: now,
        ),
      ]);

      final total = await db.healthRecordDao.getTotalSteps(
        start: todayStart,
        end: now,
      );

      expect(total, 3500);
    });

    test('Multi-source de-duplication: phone + watch does NOT double count', () async {
      // Phone steps: 4,000
      await db.healthRecordDao.upsertRecords([
        RawHealthRecordsCompanion.insert(
          recordType: 'STEPS',
          value: 4000.0,
          unit: 'COUNT',
          startTime: DateTime(2026, 9, 21, 8, 0),
          endTime: DateTime(2026, 9, 21, 16, 0),
          sourceId: 'com.google.android.apps.fitness',
          syncedAt: now,
        ),
      ]);

      // Nothing watch steps: 5,420
      await db.healthRecordDao.upsertRecords([
        RawHealthRecordsCompanion.insert(
          recordType: 'STEPS',
          value: 5420.0,
          unit: 'COUNT',
          startTime: DateTime(2026, 9, 21, 8, 0),
          endTime: DateTime(2026, 9, 21, 16, 0),
          sourceId: 'com.nothing.hearth',
          syncedAt: now,
        ),
      ]);

      final total = await db.healthRecordDao.getTotalSteps(
        start: todayStart,
        end: now,
      );

      // Should prefer Nothing/wearable source (5,420), NOT sum them (9,420)
      expect(total, 5420);
    });

    test('Cumulative updates detection takes max and does not sum iteratively', () async {
      // An app writes cumulative updates all starting at midnight
      await db.healthRecordDao.upsertRecords([
        RawHealthRecordsCompanion.insert(
          recordType: 'STEPS',
          value: 2000.0,
          unit: 'COUNT',
          startTime: todayStart,
          endTime: DateTime(2026, 9, 21, 10, 0),
          sourceId: 'com.generic.pedometer',
          syncedAt: now,
        ),
        RawHealthRecordsCompanion.insert(
          recordType: 'STEPS',
          value: 4500.0,
          unit: 'COUNT',
          startTime: todayStart,
          endTime: DateTime(2026, 9, 21, 14, 0),
          sourceId: 'com.generic.pedometer',
          syncedAt: now,
        ),
        RawHealthRecordsCompanion.insert(
          recordType: 'STEPS',
          value: 7100.0,
          unit: 'COUNT',
          startTime: todayStart,
          endTime: DateTime(2026, 9, 21, 18, 0),
          sourceId: 'com.generic.pedometer',
          syncedAt: now,
        ),
      ]);

      final total = await db.healthRecordDao.getTotalSteps(
        start: todayStart,
        end: now,
      );

      // Max is 7,100, NOT sum (13,600)
      expect(total, 7100);
    });

    test('Multi-day and weekly rollups (> 24 hours) are rejected', () async {
      // 7-day rollup record spanning 168 hours
      await db.healthRecordDao.upsertRecords([
        RawHealthRecordsCompanion.insert(
          recordType: 'STEPS',
          value: 42000.0,
          unit: 'COUNT',
          startTime: todayStart.subtract(const Duration(days: 7)),
          endTime: now,
          sourceId: 'com.weekly.tracker',
          syncedAt: now,
        ),
      ]);

      // Valid day record: 3,200
      await db.healthRecordDao.upsertRecords([
        RawHealthRecordsCompanion.insert(
          recordType: 'STEPS',
          value: 3200.0,
          unit: 'COUNT',
          startTime: DateTime(2026, 9, 21, 9, 0),
          endTime: DateTime(2026, 9, 21, 12, 0),
          sourceId: 'com.nothing.hearth',
          syncedAt: now,
        ),
      ]);

      final total = await db.healthRecordDao.getTotalSteps(
        start: todayStart,
        end: now,
      );

      // The 42,000 weekly rollup must be ignored, returning only today's 3,200 steps
      expect(total, 3200);
    });

    test('Records strictly from yesterday are not counted today', () async {
      final yesterday = todayStart.subtract(const Duration(days: 1));
      await db.healthRecordDao.upsertRecords([
        RawHealthRecordsCompanion.insert(
          recordType: 'STEPS',
          value: 8000.0,
          unit: 'COUNT',
          startTime: yesterday.add(const Duration(hours: 10)),
          endTime: yesterday.add(const Duration(hours: 18)),
          sourceId: 'com.nothing.hearth',
          syncedAt: now,
        ),
      ]);

      final total = await db.healthRecordDao.getTotalSteps(
        start: todayStart,
        end: now,
      );

      expect(total, 0);
    });
  });
}
