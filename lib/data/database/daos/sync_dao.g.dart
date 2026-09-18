// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_dao.dart';

// ignore_for_file: type=lint
mixin _$SyncDaoMixin on DatabaseAccessor<AppDatabase> {
  $SyncMetadataTable get syncMetadata => attachedDatabase.syncMetadata;
  $SyncLogsTable get syncLogs => attachedDatabase.syncLogs;
  SyncDaoManager get managers => SyncDaoManager(this);
}

class SyncDaoManager {
  final _$SyncDaoMixin _db;
  SyncDaoManager(this._db);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db.attachedDatabase, _db.syncMetadata);
  $$SyncLogsTableTableManager get syncLogs =>
      $$SyncLogsTableTableManager(_db.attachedDatabase, _db.syncLogs);
}
