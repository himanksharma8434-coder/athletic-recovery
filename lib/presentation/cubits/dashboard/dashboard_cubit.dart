import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/health_source_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final HealthSourceRepository repository;
  StreamSubscription? _subscription;

  DashboardCubit({required this.repository})
      : super(const DashboardLoading());

  /// Load the latest dashboard data and subscribe to changes.
  Future<void> load() async {
    try {
      final summary = await repository.getLatestSummary();
      if (summary != null) {
        emit(DashboardLoaded(summary: summary));
      } else {
        emit(const DashboardEmpty());
      }

      // Subscribe to reactive updates
      _subscription?.cancel();
      _subscription = repository.watchLatestSummary().listen(
        (summary) {
          if (summary != null) {
            emit(DashboardLoaded(summary: summary));
          }
        },
        onError: (_) {}, // Silently ignore stream errors
      );
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  /// Force a refresh of the dashboard data.
  Future<void> refresh() async {
    try {
      final summary = await repository.getLatestSummary();
      if (summary != null) {
        emit(DashboardLoaded(summary: summary));
      } else {
        emit(const DashboardEmpty());
      }
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
