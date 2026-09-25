import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/raw_health_records.dart';
import 'tables/daily_baselines.dart';
import 'tables/derived_metrics.dart';
import 'tables/sync_metadata.dart';
import 'tables/sync_logs.dart';

import 'daos/health_record_dao.dart';
import 'daos/baseline_dao.dart';
import 'daos/derived_metric_dao.dart';
import 'daos/sync_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    RawHealthRecords,
    DailyBaselines,
    DerivedMetrics,
    SyncMetadata,
    SyncLogs,
  ],
  daos: [
    HealthRecordDao,
    BaselineDao,
    DerivedMetricDao,
    SyncDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(driftDatabase(name: 'recova_health'));

  /// Test constructor for in-memory testing.
  AppDatabase.forTesting(super.e);

  static AppDatabase? _instance;

  /// Singleton accessor. Use this everywhere.
  static AppDatabase get instance => _instance ??= AppDatabase._();

  /// For testing: replace the singleton with a custom instance.
  static set instance(AppDatabase db) => _instance = db;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        beforeOpen: (details) async {
          try {
            await customStatement('PRAGMA journal_mode = WAL;');
            await customStatement('PRAGMA synchronous = NORMAL;');
          } catch (_) {}
          try {
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_raw_records_type_start ON raw_health_records (record_type, start_time);');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_raw_records_type_end ON raw_health_records (record_type, end_time);');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_derived_metrics_date ON derived_metrics (date);');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_daily_baselines_date ON daily_baselines (date);');
          } catch (_) {}
        },
      );
}
