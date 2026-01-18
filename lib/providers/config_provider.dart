import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/services/config_service.dart';
import 'package:collective_action_frontend/api/lib/api.dart';

final statusesProvider =
    AsyncNotifierProvider<StatusesNotifier, List<StatusSchema>>(
      StatusesNotifier.new,
    );

class StatusesNotifier extends AsyncNotifier<List<StatusSchema>> {
  @override
  Future<List<StatusSchema>> build() async {
    return await StatusService().fetchStatusOptions() ?? [];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await StatusService().fetchStatusOptions() ?? [];
    });
  }
}
