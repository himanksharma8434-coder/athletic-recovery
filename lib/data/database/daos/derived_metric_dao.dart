import 'package:drift/drift.dart';

import '../tables/derived_metrics.dart';
import '../app_database.dart';
import '../../../domain/entities/daily_metric_point.dart';

part 'derived_metric_dao.g.dart';

@DriftAccessor(tables: [DerivedMetrics])
class DerivedMetricDao extends DatabaseAccessor<AppDatabase>
    with _$DerivedMetricDaoMixin {
  DerivedMetricDao(super.db);

  /// Upsert derived metrics for a given date.
  Future<void> upsertMetric(DerivedMetricsCompanion metric) async {
    await into(derivedMetrics).insert(
      metric,
      onConflict: DoUpdate(
        (_) => metric,
        target: [derivedMetrics.date],
      ),
    );
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

  /// Get historical derived metrics for the last [days] days in chronological order.
  Future<List<DerivedMetric>> getHistory(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (select(derivedMetrics)
          ..where((m) => m.date.isBiggerOrEqualValue(cutoff))
          ..orderBy([(m) => OrderingTerm.asc(m.date)]))
        .get();
  }

  /// Get the average estimated VO2 max over the last [days] days.
  /// Returns null if no records with a non-null VO2 max exist in the window.
  Future<double?> getAverageVo2Max(int days) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final rows = await (select(derivedMetrics)
          ..where((m) => m.date.isBiggerOrEqualValue(cutoff))
          ..where((m) => m.estimatedVo2Max.isNotNull()))
        .get();
    if (rows.isEmpty) return null;
    final sum = rows.fold<double>(0.0, (s, r) => s + (r.estimatedVo2Max ?? 0));
    return sum / rows.length;
  }

  /// Get the all-time average estimated VO2 max.
  /// Returns null if no records with a non-null VO2 max exist.
  Future<double?> getAllTimeAverageVo2Max() async {
    final rows = await (select(derivedMetrics)
          ..where((m) => m.estimatedVo2Max.isNotNull()))
        .get();
    if (rows.isEmpty) return null;
    final sum = rows.fold<double>(0.0, (s, r) => s + (r.estimatedVo2Max ?? 0));
    return sum / rows.length;
  }

  /// Get historical VO2 max data points for the given [days] (or all-time if days == null or 0).
  Future<List<DailyMetricPoint>> getDailyVo2MaxHistory([int? days]) async {
    final query = select(derivedMetrics)
      ..where((m) => m.estimatedVo2Max.isNotNull());
    if (days != null && days > 0) {
      final cutoff = DateTime.now().subtract(Duration(days: days));
      query.where((m) => m.date.isBiggerOrEqualValue(cutoff));
    }
    query.orderBy([(m) => OrderingTerm.asc(m.date)]);
    final rows = await query.get();
    return rows
        .map((r) => DailyMetricPoint(
              date: r.date,
              value: r.estimatedVo2Max!,
            ))
        .toList();
  }
}

