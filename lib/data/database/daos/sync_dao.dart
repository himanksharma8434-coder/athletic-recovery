import 'package:drift/drift.dart';

import '../tables/sync_metadata.dart';
import '../tables/sync_logs.dart';
import '../app_database.dart';

part 'sync_dao.g.dart';

@DriftAccessor(tables: [SyncMetadata, SyncLogs])
class SyncDao extends DatabaseAccessor<AppDatabase> with _$SyncDaoMixin {
  SyncDao(super.db);

  // ── Sync Metadata ──

  /// Get the last synced timestamp for a specific record type.
  Future<DateTime?> getLastSyncedAt(String recordType) async {
    final result = (select(syncMetadata)
          ..where((s) => s.recordType.equals(recordType)))
        .getSingleOrNull();
    return (await result)?.lastSyncedAt;
  }

  /// Update the last synced timestamp for a specific record type.
  /// Only call this AFTER a successful write.
  Future<void> updateLastSyncedAt(String recordType, DateTime timestamp) async {
    final companion = SyncMetadataCompanion(
      recordType: Value(recordType),
      lastSyncedAt: Value(timestamp),
    );
    await into(syncMetadata).insert(
      companion,
      onConflict: DoUpdate(
        (_) => companion,
        target: [syncMetadata.recordType],
      ),
    );
  }

  // ── Sync Logs ──

  /// Log a sync outcome for debugging.
  Future<void> logSync({
    required String taskType,
    required int recordsRead,
    required int recordsWritten,
    required bool success,
    String? errorMessage,
  }) async {
    await into(syncLogs).insert(
      SyncLogsCompanion(
        timestamp: Value(DateTime.now()),
        taskType: Value(taskType),
        recordsRead: Value(recordsRead),
        recordsWritten: Value(recordsWritten),
        success: Value(success),
        errorMessage: Value(errorMessage),
      ),
    );
  }

  /// Get recent sync logs for debugging UI.
  Future<List<SyncLog>> getRecentLogs({int limit = 20}) async {
    return (select(syncLogs)
          ..orderBy([(l) => OrderingTerm.desc(l.timestamp)])
          ..limit(limit))
        .get();
  }
}
