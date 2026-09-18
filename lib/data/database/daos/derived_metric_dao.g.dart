// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'derived_metric_dao.dart';

// ignore_for_file: type=lint
mixin _$DerivedMetricDaoMixin on DatabaseAccessor<AppDatabase> {
  $DerivedMetricsTable get derivedMetrics => attachedDatabase.derivedMetrics;
  DerivedMetricDaoManager get managers => DerivedMetricDaoManager(this);
}

class DerivedMetricDaoManager {
  final _$DerivedMetricDaoMixin _db;
  DerivedMetricDaoManager(this._db);
  $$DerivedMetricsTableTableManager get derivedMetrics =>
      $$DerivedMetricsTableTableManager(
        _db.attachedDatabase,
        _db.derivedMetrics,
      );
}
