import 'package:drift/drift.dart';

import '../tables/raw_health_records.dart';
import '../app_database.dart';

part 'health_record_dao.g.dart';

@DriftAccessor(tables: [RawHealthRecords])
class HealthRecordDao extends DatabaseAccessor<AppDatabase>
    with _$HealthRecordDaoMixin {
  HealthRecordDao(super.db);

  /// Upsert a health record. Uses the composite unique key
  /// (recordType, sourceId, startTime) to handle re-reported values.
  Future<void> upsertRecord(RawHealthRecordsCompanion record) async {
    await into(rawHealthRecords).insertOnConflictUpdate(record);
  }

  /// Batch upsert multiple records.
  Future<void> upsertRecords(List<RawHealthRecordsCompanion> records) async {
    await batch((batch) {
      for (final record in records) {
        batch.insert(rawHealthRecords, record,
            onConflict: DoUpdate((_) => record));
      }
    });
  }

  /// Get records of a specific type within a date range.
  Future<List<RawHealthRecord>> getRecordsByType(
    String type, {
    required DateTime start,
    required DateTime end,
  }) async {
    return (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals(type) &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();
  }

  /// Get the daily minimum resting HR for a trailing window.
  /// Returns list of (date, minValue) pairs.
  Future<List<RawHealthRecord>> getRestingHrRecords({
    required DateTime start,
    required DateTime end,
  }) async {
    return (select(rawHealthRecords)
          ..where((r) =>
              (r.recordType.equals('RESTING_HEART_RATE') |
                  r.recordType.equals('HEART_RATE')) &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();
  }

  /// Get the max HR observed during exercise sessions in a trailing window.
  Future<double?> getMaxExerciseHr({
    required DateTime start,
    required DateTime end,
  }) async {
    final records = await (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('HEART_RATE') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.desc(r.value)])
          ..limit(1))
        .get();
    return records.isEmpty ? null : records.first.value;
  }

  /// Get sleep session records for baseline computation.
  Future<List<RawHealthRecord>> getSleepRecords({
    required DateTime start,
    required DateTime end,
  }) async {
    return (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('SLEEP_SESSION') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();
  }

  /// Get SpO2 records for baseline computation.
  Future<List<RawHealthRecord>> getSpo2Records({
    required DateTime start,
    required DateTime end,
  }) async {
    return (select(rawHealthRecords)
          ..where((r) =>
              r.recordType.equals('BLOOD_OXYGEN') &
              r.startTime.isBiggerOrEqualValue(start) &
              r.endTime.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();
  }

  /// Total record count (for UI stats).
  Future<int> getRecordCount() async {
    final count = rawHealthRecords.id.count();
    final query = selectOnly(rawHealthRecords)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count)!;
  }
}
