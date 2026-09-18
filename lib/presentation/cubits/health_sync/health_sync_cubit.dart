import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/health_source_repository.dart';
import 'health_sync_state.dart';

class HealthSyncCubit extends Cubit<HealthSyncState> {
  final HealthSourceRepository repository;

  HealthSyncCubit({required this.repository})
      : super(const HealthSyncIdle());

  /// Manual "sync now" triggered from the UI.
  Future<void> syncNow() async {
    emit(const HealthSyncing());
    try {
      final count = await repository.syncHealthData(taskType: 'manual');
      emit(HealthSyncSuccess(recordCount: count));
    } catch (e) {
      emit(HealthSyncFailure(message: e.toString()));
    }
  }
}
