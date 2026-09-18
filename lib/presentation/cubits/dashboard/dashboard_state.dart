import 'package:equatable/equatable.dart';
import '../../../domain/repositories/health_source_repository.dart';

/// States for the recovery dashboard.
sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final DerivedMetricSummary summary;
  const DashboardLoaded({required this.summary});

  @override
  List<Object?> get props => [summary];
}

class DashboardEmpty extends DashboardState {
  const DashboardEmpty();
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
