import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/directory_of_good_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final directoryOfGoodServiceProvider = Provider<DirectoryOfGoodService>((ref) {
  return DirectoryOfGoodService();
});

final directoryOfGoodEntriesProvider =
    AsyncNotifierProvider<DirectoryOfGoodEntriesNotifier,
        List<DirectoryOfGoodSchema>>(
  DirectoryOfGoodEntriesNotifier.new,
);

final directoryOfGoodEntriesByUserProvider =
    AsyncNotifierProvider<DirectoryOfGoodEntriesByUserNotifier,
        List<DirectoryOfGoodSchema>>(
  DirectoryOfGoodEntriesByUserNotifier.new,
);

final directoryOfGoodEntryByIdProvider =
    FutureProvider.family<DirectoryOfGoodSchema?, String>(
  (ref, entryId) async {
    final service = ref.watch(directoryOfGoodServiceProvider);
    return service.getEntry(entryId);
  },
);

class DirectoryOfGoodEntriesNotifier
    extends AsyncNotifier<List<DirectoryOfGoodSchema>> {
  @override
  Future<List<DirectoryOfGoodSchema>> build() async {
    return ref.read(directoryOfGoodServiceProvider).listEntries();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(directoryOfGoodServiceProvider).listEntries();
    });
  }
}

class DirectoryOfGoodEntriesByUserNotifier
    extends AsyncNotifier<List<DirectoryOfGoodSchema>> {
  @override
  Future<List<DirectoryOfGoodSchema>> build() async {
    final currentUser = ref.watch(currentUserProvider).value;
    final userId = currentUser?.id;
    if (userId == null) {
      return [];
    }
    return ref
        .read(directoryOfGoodServiceProvider)
        .listEntriesByUser(userId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final currentUser = ref.read(currentUserProvider).value;
      final userId = currentUser?.id;
      if (userId == null) {
        return [];
      }
      return ref
          .read(directoryOfGoodServiceProvider)
          .listEntriesByUser(userId);
    });
  }
}
