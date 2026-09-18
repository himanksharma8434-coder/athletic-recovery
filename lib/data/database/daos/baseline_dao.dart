import 'package:drift/drift.dart';

import '../tables/daily_baselines.dart';
import '../app_database.dart';

part 'baseline_dao.g.dart';

@DriftAccessor(tables: [DailyBaselines])
class BaselineDao extends DatabaseAccessor<AppDatabase>
    with _$BaselineDaoMixin {
  BaselineDao(super.db);

  /// Upsert a baseline for a given date.
  Future<void> upsertBaseline(DailyBaselinesCompanion baseline) async {
    await into(dailyBaselines).insert(
      baseline,
      onConflict: DoUpdate(
        (_) => baseline,
        target: [dailyBaselines.date],
      ),
    );
  }

  /// Get baseline for a specific date.
  Future<DailyBaseline?> getBaseline(DateTime date) async {
    return (select(dailyBaselines)..where((b) => b.date.equals(date)))
        .getSingleOrNull();
  }

  /// Get the most recent baseline.
  Future<DailyBaseline?> getLatestBaseline() async {
    return (select(dailyBaselines)
          ..orderBy([(b) => OrderingTerm.desc(b.date)])
          ..limit(1))
        .getSingleOrNull();
  }
}
