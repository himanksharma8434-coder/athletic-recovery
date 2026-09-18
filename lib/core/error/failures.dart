import 'package:equatable/equatable.dart';

/// Base failure class for the domain layer.
sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Health Connect / HealthKit permission was denied.
class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure([super.message = 'Health permissions denied']);
}

/// Health Connect is not installed or not available on this device.
class HealthConnectUnavailableFailure extends Failure {
  const HealthConnectUnavailableFailure(
      [super.message = 'Health Connect is not available on this device']);
}

/// Generic data fetch failure from the health platform.
class DataFetchFailure extends Failure {
  const DataFetchFailure([super.message = 'Failed to fetch health data']);
}

/// Local database operation failed.
class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'Database operation failed']);
}

/// Not enough data to compute a derived metric.
class InsufficientDataFailure extends Failure {
  const InsufficientDataFailure(
      [super.message = 'Not enough data for computation']);
}
