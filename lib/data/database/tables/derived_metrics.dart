import 'package:drift/drift.dart';

/// Stores computed VO2max estimates and composite recovery scores per day.
/// Includes per-component breakdown so the UI can explain the score.
class DerivedMetrics extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()(); // start of day, unique
  RealColumn get estimatedVo2Max => real().nullable()();
  RealColumn get recoveryScore => real().nullable()(); // 0–100
  // Per-component breakdown (each 0–100)
  RealColumn get recoveryComponentRhr => real().nullable()();
  RealColumn get recoveryComponentSleep => real().nullable()();
  RealColumn get recoveryComponentSpo2 => real().nullable()();
  TextColumn get primaryFactor => text().nullable()(); // human-readable explanation

  @override
  List<Set<Column>> get uniqueKeys => [
        {date}
      ];
}
