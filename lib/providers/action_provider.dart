import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/services/actions_service.dart';

final activeActionProvider =
    AsyncNotifierProvider<ActiveActionNotifier, List<ActionSchema>>(
      ActiveActionNotifier.new,
    );

class ActiveActionNotifier extends AsyncNotifier<List<ActionSchema>> {
  int? days;
  ActionTypeValuesEnum? actionType;

  @override
  Future<List<ActionSchema>> build() async {
    return await ActionsService().fetchLatestActions(
          days: days,
          actionType: actionType,
        ) ??
        [];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await ActionsService().fetchLatestActions(
            days: days,
            actionType: actionType,
          ) ??
          [];
    });
  }

  Future<ActionSchema?> createAction(ActionCreateSchema action) async {
    state = const AsyncLoading();
    try {
      final created = await ActionsService().createAction(action);
      // Optionally refresh the list after creation
      state = await AsyncValue.guard(() async {
        return await ActionsService().fetchLatestActions(
              days: days,
              actionType: actionType,
            ) ??
            [];
      });
      return created;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<ActionSchema?> deleteAction(ActionSchema action) async {
    state = const AsyncLoading();
    try {
      final deleted = await ActionsService().deleteAction(action);
      // Refresh the list after deletion
      state = await AsyncValue.guard(() async {
        return await ActionsService().fetchLatestActions(
              days: days,
              actionType: actionType,
            ) ??
            [];
      });
      return deleted;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
