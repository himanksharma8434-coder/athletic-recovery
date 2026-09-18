import 'package:equatable/equatable.dart';

/// Domain entity for daily baseline metrics.
class DailyBaselineEntity extends Equatable {
  final DateTime date;
  final double? restingHrBaseline7d;
  final double? restingHrBaseline30d;
  final double? sleepDurationBaseline7d;
  final double? spo2Baseline7d;

  const DailyBaselineEntity({
    required this.date,
    this.restingHrBaseline7d,
    this.restingHrBaseline30d,
    this.sleepDurationBaseline7d,
    this.spo2Baseline7d,
  });

  @override
  List<Object?> get props => [date];
}
