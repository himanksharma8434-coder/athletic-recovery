import 'package:drift/drift.dart';

import '../tables/derived_metrics.dart';
import '../app_database.dart';

part 'derived_metric_dao.g.dart';

@DriftAccessor(tables: [DerivedMetrics])
class DerivedMetricDao extends DatabaseAccessor<AppDatabase>
    with _$DerivedMetricDaoMixin {
  DerivedMetricDao(super.db);

  /// Upsert derived metrics for a given date.
  Future<void> upsertMetric(DerivedMetricsCompanion metric) async {
    await into(derivedMetrics).insertOnConflictUpdate(metric);
  }

  /// Get derived metric for a specific date.
  Future<DerivedMetric?> getMetric(DateTime date) async {
    return (select(derivedMetrics)..where((m) => m.date.equals(date)))
        .getSingleOrNull();
  }

  /// Get the most recent derived metric.
  Future<DerivedMetric?> getLatestMetric() async {
    return (select(derivedMetrics)
          ..orderBy([(m) => OrderingTerm.desc(m.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Stream of the latest metric for reactive UI updates.
  Stream<DerivedMetric?> watchLatestMetric() {
    return (select(derivedMetrics)
          ..orderBy([(m) => OrderingTerm.desc(m.date)])
          ..limit(1))
        .watchSingleOrNull();
  }
}
