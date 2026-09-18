import 'package:equatable/equatable.dart';

/// Domain entity for computed derived metrics (VO2max, recovery score).
class DerivedMetricEntity extends Equatable {
  final DateTime date;
  final double? estimatedVo2Max;
  final double? recoveryScore;
  final double? recoveryComponentRhr;
  final double? recoveryComponentSleep;
  final double? recoveryComponentSpo2;
  final String? primaryFactor;

  const DerivedMetricEntity({
    required this.date,
    this.estimatedVo2Max,
    this.recoveryScore,
    this.recoveryComponentRhr,
    this.recoveryComponentSleep,
    this.recoveryComponentSpo2,
    this.primaryFactor,
  });

  @override
  List<Object?> get props => [date];
}
