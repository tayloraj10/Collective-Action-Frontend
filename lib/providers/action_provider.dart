import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/actions_service.dart';

final activeActionProvider =
    AsyncNotifierProvider<ActiveActionNotifier, List<ActionSchema>>(
      ActiveActionNotifier.new,
    );

/// Fetches actions for a linked entity (e.g. initiative).
/// [params] is (linkedId, days?). Pass null for days to get all actions.
final actionsByLinkedProvider =
    FutureProvider.family<List<ActionSchema>, (String, int?)>(
      (ref, params) async {
        final (linkedId, days) = params;
        final user = ref.watch(currentUserProvider).value;
        return await ActionsService().fetchActionsByLinked(
          linkedId,
          days: days,
          forUserId: user?.id,
        ) ?? [];
      },
    );

class ActiveActionNotifier extends AsyncNotifier<List<ActionSchema>> {
  int? days;
  ActionTypeValuesEnum? actionType;

  @override
  Future<List<ActionSchema>> build() async {
    final user = ref.watch(currentUserProvider).value;
    return await ActionsService().fetchLatestActions(
          days: days,
          actionType: actionType,
          forUserId: user?.id,
        ) ??
        [];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(currentUserProvider).value;
      return await ActionsService().fetchLatestActions(
            days: days,
            actionType: actionType,
            forUserId: user?.id,
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
        final user = ref.read(currentUserProvider).value;
        return await ActionsService().fetchLatestActions(
              days: days,
              actionType: actionType,
              forUserId: user?.id,
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
        final user = ref.read(currentUserProvider).value;
        return await ActionsService().fetchLatestActions(
              days: days,
              actionType: actionType,
              forUserId: user?.id,
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
