import 'package:equatable/equatable.dart';

/// States for the health data sync process.
sealed class HealthSyncState extends Equatable {
  const HealthSyncState();

  @override
  List<Object?> get props => [];
}

class HealthSyncIdle extends HealthSyncState {
  const HealthSyncIdle();
}

class HealthSyncing extends HealthSyncState {
  const HealthSyncing();
}

class HealthSyncSuccess extends HealthSyncState {
  final int recordCount;
  const HealthSyncSuccess({required this.recordCount});

  @override
  List<Object?> get props => [recordCount];
}

class HealthSyncFailure extends HealthSyncState {
  final String message;
  const HealthSyncFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
