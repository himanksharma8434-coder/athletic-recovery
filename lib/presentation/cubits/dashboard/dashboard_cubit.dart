import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/health_source_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final HealthSourceRepository repository;
  StreamSubscription? _subscription;

  static DerivedMetricSummary? _tryGetCached(HealthSourceRepository repo) {
    try {
      return repo.cachedSummary;
    } catch (_) {
      return null;
    }
  }

  DashboardCubit({required this.repository})
      : super(_tryGetCached(repository) != null
            ? DashboardLoaded(summary: _tryGetCached(repository)!)
            : const DashboardLoading());

  /// Load the latest dashboard data and subscribe to changes.
  Future<void> load() async {
    // Show cached summary immediately if available
    final cached = _tryGetCached(repository);
    if (cached != null && state is! DashboardLoaded) {
      emit(DashboardLoaded(summary: cached));
    }

    try {
      final summary = await repository.getLatestSummary();
      if (summary != null) {
        emit(DashboardLoaded(summary: summary));
      } else if (state is! DashboardLoaded) {
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
      if (state is! DashboardLoaded) {
        emit(DashboardError(message: e.toString()));
      }
    }
  }

  /// Force a refresh of the dashboard data.
  Future<void> refresh() async {
    try {
      final summary = await repository.getLatestSummary();
      if (summary != null) {
        emit(DashboardLoaded(summary: summary));
      } else if (state is! DashboardLoaded) {
        emit(const DashboardEmpty());
      }
    } catch (e) {
      if (state is! DashboardLoaded) {
        emit(DashboardError(message: e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
