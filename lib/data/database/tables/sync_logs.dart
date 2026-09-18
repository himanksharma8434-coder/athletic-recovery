import 'package:drift/drift.dart';

/// Debug log for sync outcomes. Inspectable for troubleshooting.
class SyncLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get taskType => text()(); // "background" or "manual"
  IntColumn get recordsRead => integer().withDefault(const Constant(0))();
  IntColumn get recordsWritten => integer().withDefault(const Constant(0))();
  BoolColumn get success => boolean().withDefault(const Constant(true))();
  TextColumn get errorMessage => text().nullable()();
}
