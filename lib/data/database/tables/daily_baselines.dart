import 'package:drift/drift.dart';

/// Rolling baseline metrics recomputed after each sync.
/// One row per calendar date. Used to detect deviations for the recovery score.
class DailyBaselines extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()(); // start of day, unique
  RealColumn get restingHrBaseline7d => real().nullable()(); // median of daily min RHR
  RealColumn get restingHrBaseline30d => real().nullable()();
  RealColumn get sleepDurationBaseline7d => real().nullable()(); // minutes
  RealColumn get spo2Baseline7d => real().nullable()(); // percentage

  @override
  List<Set<Column>> get uniqueKeys => [
        {date}
      ];
}
