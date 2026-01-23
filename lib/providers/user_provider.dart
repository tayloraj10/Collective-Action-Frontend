import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/services/user_service.dart';

final activeUserProvider =
    AsyncNotifierProvider<ActiveUserNotifier, List<UserSchema>>(
      ActiveUserNotifier.new,
    );

class ActiveUserNotifier extends AsyncNotifier<List<UserSchema>> {
  String? userId;

  @override
  Future<List<UserSchema>> build({String? userId}) async {
    this.userId = userId;
    if (userId == null) {
      return [];
    }
    final user = await UserService().fetchUser(userId: userId);
    if (user != null) {
      return [user];
    } else {
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (userId == null) return <UserSchema>[];
      final user = await UserService().fetchUser(userId: userId!);
      if (user != null) {
        return [user];
      } else {
        return <UserSchema>[];
      }
    });
  }

  Future<UserSchema?> createUser(UserCreate action) async {
    state = const AsyncLoading();
    try {
      final created = await UserService().createUser(action);
      // Optionally refresh the list after creation
      state = await AsyncValue.guard(() async {
        if (userId == null) return <UserSchema>[];
        try {
          final user = await UserService().fetchUser(userId: userId!);
          if (user != null) {
            return [user];
          } else {
            return <UserSchema>[];
          }
        } catch (e) {
          // If 404, just return empty list, don't throw
          return <UserSchema>[];
        }
      });
      return created;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
