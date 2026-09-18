// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_record_dao.dart';

// ignore_for_file: type=lint
mixin _$HealthRecordDaoMixin on DatabaseAccessor<AppDatabase> {
  $RawHealthRecordsTable get rawHealthRecords =>
      attachedDatabase.rawHealthRecords;
  HealthRecordDaoManager get managers => HealthRecordDaoManager(this);
}

class HealthRecordDaoManager {
  final _$HealthRecordDaoMixin _db;
  HealthRecordDaoManager(this._db);
  $$RawHealthRecordsTableTableManager get rawHealthRecords =>
      $$RawHealthRecordsTableTableManager(
        _db.attachedDatabase,
        _db.rawHealthRecords,
      );
}
