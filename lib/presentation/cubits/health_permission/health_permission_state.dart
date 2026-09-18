import 'package:equatable/equatable.dart';

/// States for the health permission flow.
sealed class HealthPermissionState extends Equatable {
  const HealthPermissionState();

  @override
  List<Object?> get props => [];
}

class HealthPermissionInitial extends HealthPermissionState {
  const HealthPermissionInitial();
}

class HealthPermissionRequesting extends HealthPermissionState {
  const HealthPermissionRequesting();
}

class HealthPermissionGranted extends HealthPermissionState {
  final bool backgroundReadGranted;
  const HealthPermissionGranted({this.backgroundReadGranted = false});

  @override
  List<Object?> get props => [backgroundReadGranted];
}

class HealthPermissionDenied extends HealthPermissionState {
  final String message;
  const HealthPermissionDenied(
      {this.message = 'Health permissions were denied'});

  @override
  List<Object?> get props => [message];
}
