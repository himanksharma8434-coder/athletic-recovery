import 'package:flutter_test/flutter_test.dart';
import 'package:whoop/core/utils/sleep_data_sanitizer.dart';
import 'package:whoop/data/database/app_database.dart';

void main() {
  group('SleepDataSanitizer', () {
    test('calculateMergedMinutes merges overlapping stage intervals', () {
      final t0 = DateTime(2026, 9, 20, 1, 0);
      final t1 = DateTime(2026, 9, 20, 1, 45); // 45 min
      final t2 = DateTime(2026, 9, 20, 1, 30);
      final t3 = DateTime(2026, 9, 20, 2, 0); // overlaps, extends to 2:00 (60 min total)

      final records = [
        RawHealthRecord(
          id: 1,
          recordType: 'SLEEP_DEEP',
          value: 45.0,
          unit: 'MINUTES',
          startTime: t0,
          endTime: t1,
          sourceId: 'com.nothing.healt',
          syncedAt: DateTime.now(),
        ),
        RawHealthRecord(
          id: 2,
          recordType: 'SLEEP_DEEP',
          value: 30.0,
          unit: 'MINUTES',
          startTime: t2,
          endTime: t3,
          sourceId: 'com.nothing.healt',
          syncedAt: DateTime.now(),
        ),
      ];

      final merged = SleepDataSanitizer.calculateMergedMinutes(records);
      expect(merged, 60); // 1:00 to 2:00 = 60 minutes, not 75 minutes
    });

    test('sanitizeOvernightStages eliminates multi-source duplicate doubling (prevents 13h bug)', () {
      final nightStart = DateTime(2026, 9, 19, 23, 30);
      final wakeTime = DateTime(2026, 9, 20, 6, 0); // 6.5 hours (390 min total)

      // Nothing X Watch records
      final nothingStages = [
        RawHealthRecord(
          id: 1,
          recordType: 'SLEEP_DEEP',
          value: 80.0,
          unit: 'MINUTES',
          startTime: nightStart.add(const Duration(minutes: 15)),
          endTime: nightStart.add(const Duration(minutes: 95)),
          sourceId: 'com.nothing.healt',
          syncedAt: DateTime.now(),
        ),
        RawHealthRecord(
          id: 2,
          recordType: 'SLEEP_LIGHT',
          value: 195.0,
          unit: 'MINUTES',
          startTime: nightStart.add(const Duration(minutes: 95)),
          endTime: nightStart.add(const Duration(minutes: 290)),
          sourceId: 'com.nothing.healt',
          syncedAt: DateTime.now(),
        ),
        RawHealthRecord(
          id: 3,
          recordType: 'SLEEP_REM',
          value: 85.0,
          unit: 'MINUTES',
          startTime: nightStart.add(const Duration(minutes: 290)),
          endTime: nightStart.add(const Duration(minutes: 375)),
          sourceId: 'com.nothing.healt',
          syncedAt: DateTime.now(),
        ),
        RawHealthRecord(
          id: 4,
          recordType: 'SLEEP_AWAKE',
          value: 15.0,
          unit: 'MINUTES',
          startTime: nightStart,
          endTime: nightStart.add(const Duration(minutes: 15)),
          sourceId: 'com.nothing.healt',
          syncedAt: DateTime.now(),
        ),
      ];

      // Duplicate Google Fit / Health Connect records reporting the exact same stages
      final googleFitStages = [
        RawHealthRecord(
          id: 5,
          recordType: 'SLEEP_DEEP',
          value: 80.0,
          unit: 'MINUTES',
          startTime: nightStart.add(const Duration(minutes: 15)),
          endTime: nightStart.add(const Duration(minutes: 95)),
          sourceId: 'com.google.android.apps.fitness',
          syncedAt: DateTime.now(),
        ),
        RawHealthRecord(
          id: 6,
          recordType: 'SLEEP_LIGHT',
          value: 195.0,
          unit: 'MINUTES',
          startTime: nightStart.add(const Duration(minutes: 95)),
          endTime: nightStart.add(const Duration(minutes: 290)),
          sourceId: 'com.google.android.apps.fitness',
          syncedAt: DateTime.now(),
        ),
        RawHealthRecord(
          id: 7,
          recordType: 'SLEEP_REM',
          value: 85.0,
          unit: 'MINUTES',
          startTime: nightStart.add(const Duration(minutes: 290)),
          endTime: nightStart.add(const Duration(minutes: 375)),
          sourceId: 'com.google.android.apps.fitness',
          syncedAt: DateTime.now(),
        ),
        RawHealthRecord(
          id: 8,
          recordType: 'SLEEP_AWAKE',
          value: 15.0,
          unit: 'MINUTES',
          startTime: nightStart,
          endTime: nightStart.add(const Duration(minutes: 15)),
          sourceId: 'com.google.android.apps.fitness',
          syncedAt: DateTime.now(),
        ),
      ];

      final allDuplicatedRecords = [...nothingStages, ...googleFitStages];

      final session = RawHealthRecord(
        id: 9,
        recordType: 'SLEEP_SESSION',
        value: 390.0,
        unit: 'MINUTES',
        startTime: nightStart,
        endTime: wakeTime,
        sourceId: 'com.nothing.healt',
        syncedAt: DateTime.now(),
      );

      final clean = SleepDataSanitizer.sanitizeOvernightStages(
        stageRecords: allDuplicatedRecords,
        sessionRecord: session,
      );

      // Verify that sleep is ~6 hours, NOT 12-13 hours!
      expect(clean.deepMinutes, 80);
      expect(clean.coreMinutes, 195);
      expect(clean.remMinutes, 85);
      expect(clean.awakeMinutes, 15);
      expect(clean.totalAsleepMinutes, 360); // 6h 0m asleep
      expect(clean.totalHours, 6.0); // Exactly 6.0 hours, NOT 12.0 or 13.0 hours!
    });

    test('sanitizeOvernightStages caps stage totals to physical night elapsed time', () {
      final nightStart = DateTime(2026, 9, 19, 23, 0);
      final wakeTime = DateTime(2026, 9, 20, 5, 0); // 6 hours physical elapsed

      // Inflated records without source metadata
      final inflatedRecords = [
        RawHealthRecord(
          id: 1,
          recordType: 'SLEEP_DEEP',
          value: 160.0,
          unit: 'MINUTES',
          startTime: nightStart,
          endTime: wakeTime,
          sourceId: 'generic',
          syncedAt: DateTime.now(),
        ),
        RawHealthRecord(
          id: 2,
          recordType: 'SLEEP_LIGHT',
          value: 390.0,
          unit: 'MINUTES',
          startTime: nightStart,
          endTime: wakeTime,
          sourceId: 'generic',
          syncedAt: DateTime.now(),
        ),
        RawHealthRecord(
          id: 3,
          recordType: 'SLEEP_REM',
          value: 170.0,
          unit: 'MINUTES',
          startTime: nightStart,
          endTime: wakeTime,
          sourceId: 'generic',
          syncedAt: DateTime.now(),
        ),
      ];

      final clean = SleepDataSanitizer.sanitizeOvernightStages(
        stageRecords: inflatedRecords,
      );

      // Must be capped by the 6h (360m) elapsed window!
      expect(clean.totalAsleepMinutes, lessThanOrEqualTo(360));
      expect(clean.totalHours, lessThanOrEqualTo(6.0));
    });

    test('extractDistributedSessions identifies Night Sleep and Evening Nap and sums Total Sleep', () {
      // 1. Night Sleep: 11:30 PM to 6:00 AM (390 min = 6.5h)
      final nightStart = DateTime(2026, 9, 19, 23, 30);
      final nightEnd = DateTime(2026, 9, 20, 6, 0);

      // 2. Evening Nap: 6:00 PM to 6:45 PM (45 min = 0.75h)
      final napStart = DateTime(2026, 9, 20, 18, 0);
      final napEnd = DateTime(2026, 9, 20, 18, 45);

      final sessionRecords = [
        RawHealthRecord(
          id: 1,
          recordType: 'SLEEP_SESSION',
          value: 390.0,
          unit: 'MINUTES',
          startTime: nightStart,
          endTime: nightEnd,
          sourceId: 'com.nothing.healt',
          syncedAt: DateTime.now(),
        ),
        RawHealthRecord(
          id: 2,
          recordType: 'SLEEP_SESSION',
          value: 45.0,
          unit: 'MINUTES',
          startTime: napStart,
          endTime: napEnd,
          sourceId: 'com.nothing.healt',
          syncedAt: DateTime.now(),
        ),
      ];

      final distributed = SleepDataSanitizer.extractDistributedSessions(
        stageRecords: [],
        sessionRecords: sessionRecords,
      );

      // Total sleep must be 6.5h + 0.75h = 7.25h (435 min)
      expect(distributed.totalMinutes, 435);
      expect(distributed.totalHours, 7.25);
      expect(distributed.nightHours, 6.5);
      expect(distributed.napHours, 0.75);

      // Verify sessions are correctly classified
      expect(distributed.sessions.length, 2);

      final nightSession = distributed.sessions.firstWhere((s) => s.isMainSleep);
      expect(nightSession.title, 'Night Sleep');
      expect(nightSession.sessionType, 'NIGHT_SLEEP');
      expect(nightSession.durationMinutes, 390);

      final napSession = distributed.sessions.firstWhere((s) => !s.isMainSleep);
      expect(napSession.title, 'Evening Nap');
      expect(napSession.sessionType, 'EVENING_NAP');
      expect(napSession.durationMinutes, 45);
    });

    test('extractDistributedSessions classifies Afternoon Nap correctly', () {
      final napStart = DateTime(2026, 9, 20, 14, 0);
      final napEnd = DateTime(2026, 9, 20, 15, 0); // 60 min

      final sessionRecords = [
        RawHealthRecord(
          id: 1,
          recordType: 'SLEEP_SESSION',
          value: 420.0,
          unit: 'MINUTES',
          startTime: DateTime(2026, 9, 20, 0, 0),
          endTime: DateTime(2026, 9, 20, 7, 0),
          sourceId: 'com.nothing.healt',
          syncedAt: DateTime.now(),
        ),
        RawHealthRecord(
          id: 2,
          recordType: 'SLEEP_SESSION',
          value: 60.0,
          unit: 'MINUTES',
          startTime: napStart,
          endTime: napEnd,
          sourceId: 'com.nothing.healt',
          syncedAt: DateTime.now(),
        ),
      ];

      final distributed = SleepDataSanitizer.extractDistributedSessions(
        stageRecords: [],
        sessionRecords: sessionRecords,
      );

      expect(distributed.sessions.length, 2);
      final afternoonNap = distributed.sessions.firstWhere((s) => !s.isMainSleep);
      expect(afternoonNap.title, 'Afternoon Nap');
      expect(afternoonNap.sessionType, 'AFTERNOON_NAP');
      expect(afternoonNap.durationHours, 1.0);
    });
  });
}
