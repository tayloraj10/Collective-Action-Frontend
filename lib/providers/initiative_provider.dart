import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/services/initiatives_service.dart';

final activeInitiativeProvider =
    AsyncNotifierProvider<ActiveInitiativeNotifier, List<InitiativeSchema>>(
      ActiveInitiativeNotifier.new,
    );

class ActiveInitiativeNotifier extends AsyncNotifier<List<InitiativeSchema>> {
  @override
  Future<List<InitiativeSchema>> build() async {
    return await InitiativesService().fetchActiveInitiatives() ?? [];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await InitiativesService().fetchActiveInitiatives() ?? [];
    });
  }
}
