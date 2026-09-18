import 'package:equatable/equatable.dart';

/// Domain entity representing a single health data record.
class HealthRecord extends Equatable {
  final String recordType;
  final double value;
  final double? valueSecondary;
  final String unit;
  final DateTime startTime;
  final DateTime endTime;
  final String sourceId;
  final DateTime syncedAt;

  const HealthRecord({
    required this.recordType,
    required this.value,
    this.valueSecondary,
    required this.unit,
    required this.startTime,
    required this.endTime,
    required this.sourceId,
    required this.syncedAt,
  });

  @override
  List<Object?> get props => [recordType, sourceId, startTime];
}
