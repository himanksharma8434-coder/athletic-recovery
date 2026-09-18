// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baseline_dao.dart';

// ignore_for_file: type=lint
mixin _$BaselineDaoMixin on DatabaseAccessor<AppDatabase> {
  $DailyBaselinesTable get dailyBaselines => attachedDatabase.dailyBaselines;
  BaselineDaoManager get managers => BaselineDaoManager(this);
}

class BaselineDaoManager {
  final _$BaselineDaoMixin _db;
  BaselineDaoManager(this._db);
  $$DailyBaselinesTableTableManager get dailyBaselines =>
      $$DailyBaselinesTableTableManager(
        _db.attachedDatabase,
        _db.dailyBaselines,
      );
}
