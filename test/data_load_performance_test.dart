import 'dart:async';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whoop/data/database/app_database.dart';
import 'package:whoop/data/datasources/health_platform_datasource.dart';
import 'package:whoop/data/repositories/health_repository_impl.dart';
import 'package:whoop/domain/entities/health_record.dart';
import 'package:whoop/domain/repositories/health_source_repository.dart';
import 'package:whoop/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:whoop/presentation/cubits/dashboard/dashboard_state.dart';
import 'package:whoop/presentation/cubits/health_sync/health_sync_cubit.dart';
import 'package:whoop/presentation/cubits/health_sync/health_sync_state.dart';

class MockPlatform extends HealthPlatformDatasource {
  @override
  Future<void> configure() async {}

  @override
  Future<DateTime?> fetchDateOfBirth() async => null;

  @override
  Future<List<HealthRecord>> fetchRecordsForType({
    required dynamic type,
    required DateTime startTime,
    required DateTime endTime,
  }) async =>
      [];

  @override
  Future<int?> getTotalStepsInInterval({
    required DateTime startTime,
    required DateTime endTime,
  }) async =>
      null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late HealthRepositoryImpl repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = HealthRepositoryImpl(
      platform: MockPlatform(),
      db: db,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Data Load Performance & Instant Display Optimizations', () {
    test('DashboardCubit starts in DashboardLoaded with zero delay when cachedSummary is present', () async {
      const cached = DerivedMetricSummary(
        recoveryScore: 84.0,
        todaySteps: 6200,
        restingHr: 52.0,
      );

      // Create a repository with a populated in-memory cache
      final mockRepo = _CachedMockRepo(cached);

      final cubit = DashboardCubit(repository: mockRepo);

      // Verify that initial state is instantly DashboardLoaded without waiting for load()
      expect(cubit.state, isA<DashboardLoaded>());
      final loaded = cubit.state as DashboardLoaded;
      expect(loaded.summary.recoveryScore, 84.0);
      expect(loaded.summary.todaySteps, 6200);

      await cubit.close();
    });

    test('HealthRepositoryImpl caches summary in memory for instant subsequent reads', () async {
      final now = DateTime.now();

      // Seed a resting heart rate record
      await db.healthRecordDao.upsertRecords([
        RawHealthRecordsCompanion.insert(
          recordType: 'RESTING_HEART_RATE',
          value: 58.0,
          unit: 'BEATS_PER_MINUTE',
          startTime: now,
          endTime: now,
          sourceId: 'test_sensor',
          syncedAt: now,
        ),
      ]);

      // Before getLatestSummary, cachedSummary is null
      expect(repository.cachedSummary, isNull);

      final summary = await repository.getLatestSummary();
      expect(summary, isNotNull);

      // After getLatestSummary, cachedSummary is immediately available in memory
      expect(repository.cachedSummary, isNotNull);
      expect(repository.cachedSummary?.restingHr, 58.0);
      expect(identical(repository.cachedSummary, summary), isTrue);
    });

    test('getExerciseMaxHrsByWindows accurately partitions exercise peaks across 7D, 30D, 60D, and All-Time in one pass', () async {
      final now = DateTime.now();

      // Day 45: All-time peak workout (200 bpm)
      final day45 = now.subtract(const Duration(days: 45));
      await db.healthRecordDao.upsertRecords([
        RawHealthRecordsCompanion.insert(
          recordType: 'WORKOUT',
          value: 45.0,
          unit: 'RUNNING',
          startTime: day45,
          endTime: day45.add(const Duration(minutes: 45)),
          sourceId: 'gps_tracker',
          syncedAt: now,
        ),
        RawHealthRecordsCompanion.insert(
          recordType: 'HEART_RATE',
          value: 200.0,
          unit: 'BEATS_PER_MINUTE',
          startTime: day45.add(const Duration(minutes: 20)),
          endTime: day45.add(const Duration(minutes: 20)),
          sourceId: 'gps_tracker',
          syncedAt: now,
        ),
      ]);

      // Day 20: 30D workout peak (185 bpm)
      final day20 = now.subtract(const Duration(days: 20));
      await db.healthRecordDao.upsertRecords([
        RawHealthRecordsCompanion.insert(
          recordType: 'WORKOUT',
          value: 30.0,
          unit: 'CARDIO',
          startTime: day20,
          endTime: day20.add(const Duration(minutes: 30)),
          sourceId: 'gps_tracker',
          syncedAt: now,
        ),
        RawHealthRecordsCompanion.insert(
          recordType: 'HEART_RATE',
          value: 185.0,
          unit: 'BEATS_PER_MINUTE',
          startTime: day20.add(const Duration(minutes: 15)),
          endTime: day20.add(const Duration(minutes: 15)),
          sourceId: 'gps_tracker',
          syncedAt: now,
        ),
      ]);

      // Day 2: 7D workout peak (168 bpm)
      final day2 = now.subtract(const Duration(days: 2));
      await db.healthRecordDao.upsertRecords([
        RawHealthRecordsCompanion.insert(
          recordType: 'WORKOUT',
          value: 25.0,
          unit: 'CARDIO',
          startTime: day2,
          endTime: day2.add(const Duration(minutes: 25)),
          sourceId: 'gps_tracker',
          syncedAt: now,
        ),
        RawHealthRecordsCompanion.insert(
          recordType: 'HEART_RATE',
          value: 168.0,
          unit: 'BEATS_PER_MINUTE',
          startTime: day2.add(const Duration(minutes: 10)),
          endTime: day2.add(const Duration(minutes: 10)),
          sourceId: 'gps_tracker',
          syncedAt: now,
        ),
      ]);

      final expected7d = await db.healthRecordDao.getMaxExerciseHr(
        start: now.subtract(const Duration(days: 7)),
        end: now,
      );
      final expected30d = await db.healthRecordDao.getMaxExerciseHr(
        start: now.subtract(const Duration(days: 30)),
        end: now,
      );
      final expected60d = await db.healthRecordDao.getMaxExerciseHr(
        start: now.subtract(const Duration(days: 60)),
        end: now,
      );
      final expectedAllTime = await db.healthRecordDao.getMaxExerciseHr(
        start: DateTime(2000),
        end: now,
      );

      final windows = await db.healthRecordDao.getExerciseMaxHrsByWindows(now);

      expect(windows.max7d, equals(expected7d));
      expect(windows.max30d, equals(expected30d));
      expect(windows.max60d, equals(expected60d));
      expect(windows.maxAllTime, equals(expectedAllTime));
      expect(windows.max7d, isNotNull);
      expect(windows.max30d, isNotNull);
      expect(windows.max60d, isNotNull);
      expect(windows.maxAllTime, isNotNull);
    });

    test('watchLatestSummary does not trigger recursive write loops', () async {
      final now = DateTime.now();

      await db.healthRecordDao.upsertRecords([
        RawHealthRecordsCompanion.insert(
          recordType: 'RESTING_HEART_RATE',
          value: 62.0,
          unit: 'BEATS_PER_MINUTE',
          startTime: now,
          endTime: now,
          sourceId: 'sensor',
          syncedAt: now,
        ),
      ]);

      int emissionCount = 0;
      final sub = repository.watchLatestSummary().listen((summary) {
        if (summary != null) {
          emissionCount++;
        }
      });

      // Trigger initial summary calculation and persistence
      await repository.getLatestSummary(persistToday: true);

      // Wait a moment to ensure no cascading re-emissions occur
      await Future.delayed(const Duration(milliseconds: 100));

      expect(emissionCount, lessThanOrEqualTo(2));

      await sub.cancel();
    });

    test('HealthSyncCubit debounces rapid manual sync taps to exactly 1 in-flight sync', () async {
      int syncCalls = 0;
      final mockRepo = _CountingSyncRepo(() async {
        syncCalls++;
        await Future.delayed(const Duration(milliseconds: 50));
        return 10;
      });

      final cubit = HealthSyncCubit(repository: mockRepo);

      // Rapidly trigger syncNow 5 times in succession
      final f1 = cubit.syncNow();
      final f2 = cubit.syncNow();
      final f3 = cubit.syncNow();
      final f4 = cubit.syncNow();
      final f5 = cubit.syncNow();

      await Future.wait([f1, f2, f3, f4, f5]);

      expect(syncCalls, equals(1));
      expect(cubit.state, isA<HealthSyncSuccess>());
      expect((cubit.state as HealthSyncSuccess).recordCount, equals(10));

      await cubit.close();
    });

    test('HealthRepositoryImpl syncHealthData in-flight mutex shares identical future', () async {
      final sync1 = repository.syncHealthData(taskType: 'manual');
      final sync2 = repository.syncHealthData(taskType: 'background');

      // Both references must point to the exact same future
      expect(identical(sync1, sync2), isTrue);

      final results = await Future.wait([sync1, sync2]);
      expect(results[0], equals(results[1]));
    });

    test('DashboardCubit deduplicates identical consecutive summary emissions from stream', () async {
      const summaryA = DerivedMetricSummary(recoveryScore: 80.0, restingHr: 60.0);
      final streamController = StreamController<DerivedMetricSummary?>.broadcast();

      final mockRepo = _StreamMockRepo(streamController.stream, summaryA);
      final cubit = DashboardCubit(repository: mockRepo);

      await cubit.load();
      expect(cubit.state, isA<DashboardLoaded>());

      int loadedEmissions = 0;
      final sub = cubit.stream.listen((state) {
        if (state is DashboardLoaded) {
          loadedEmissions++;
        }
      });

      // Emit identical summary twice
      streamController.add(summaryA);
      streamController.add(summaryA);
      await Future.delayed(const Duration(milliseconds: 50));

      // Emit modified summary
      const summaryB = DerivedMetricSummary(recoveryScore: 85.0, restingHr: 58.0);
      streamController.add(summaryB);
      await Future.delayed(const Duration(milliseconds: 50));

      // Should only have emitted once for summaryB, not for the duplicate summaryA emissions
      expect(loadedEmissions, equals(1));

      await sub.cancel();
      await streamController.close();
      await cubit.close();
    });
  });
}

class _CountingSyncRepo implements HealthSourceRepository {
  final Future<int> Function() onSync;

  _CountingSyncRepo(this.onSync);

  @override
  Future<int> syncHealthData({required String taskType}) => onSync();

  @override
  DerivedMetricSummary? get cachedSummary => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StreamMockRepo implements HealthSourceRepository {
  final Stream<DerivedMetricSummary?> _stream;
  final DerivedMetricSummary _initial;

  _StreamMockRepo(this._stream, this._initial);

  @override
  DerivedMetricSummary? get cachedSummary => _initial;

  @override
  Future<DerivedMetricSummary?> getLatestSummary({bool persistToday = true}) async => _initial;

  @override
  Stream<DerivedMetricSummary?> watchLatestSummary() => _stream;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _CachedMockRepo implements HealthSourceRepository {
  final DerivedMetricSummary _cached;

  _CachedMockRepo(this._cached);

  @override
  DerivedMetricSummary? get cachedSummary => _cached;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
