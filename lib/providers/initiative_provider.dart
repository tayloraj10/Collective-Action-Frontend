import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/services/initiatives_service.dart';

final initiativeProvider =
    AsyncNotifierProvider<InitiativeNotifier, List<InitiativeSchema>>(
      InitiativeNotifier.new,
    );

class InitiativeNotifier extends AsyncNotifier<List<InitiativeSchema>> {
  @override
  Future<List<InitiativeSchema>> build() async {
    return await InitiativesService().fetchInitiatives() ?? [];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await InitiativesService().fetchInitiatives() ?? [];
    });
  }
}
