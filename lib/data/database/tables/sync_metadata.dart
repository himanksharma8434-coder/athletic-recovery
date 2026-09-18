import 'package:drift/drift.dart';

/// Tracks the last successful sync timestamp per health data type.
/// Ensures delta-only queries on subsequent syncs.
class SyncMetadata extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get recordType => text()(); // e.g. "HEART_RATE"
  DateTimeColumn get lastSyncedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {recordType}
      ];
}
