import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/services/user_service.dart';

/// Global provider for the currently active backend user
final currentUserProvider =
    AsyncNotifierProvider<CurrentUserNotifier, UserSchema?>(
      CurrentUserNotifier.new,
    );

class CurrentUserNotifier extends AsyncNotifier<UserSchema?> {
  @override
  Future<UserSchema?> build() async {
    // Initially no user is loaded
    return null;
  }

  /// Set the current user (after login or user creation)
  Future<void> setUser(UserSchema user) async {
    state = AsyncValue.data(user);
  }

  /// Clear the current user (on logout)
  Future<void> clearUser() async {
    state = const AsyncValue.data(null);
  }

  /// Optionally, refresh user from backend
  Future<void> refreshUser(String userId) async {
    state = const AsyncLoading();
    final user = await UserService().fetchUser(userId: userId);
    state = AsyncValue.data(user);
  }
}

final userProvider =
    AsyncNotifierProvider.family<UserNotifier, UserSchema?, String>(
      (userId) => UserNotifier(userId),
    );

class UserNotifier extends AsyncNotifier<UserSchema?> {
  final String userId;

  UserNotifier(this.userId);

  @override
  Future<UserSchema?> build() async {
    return await UserService().fetchUser(userId: userId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await UserService().fetchUser(userId: userId);
    });
  }

  Future<UserSchema?> createUser(UserCreate userData) async {
    state = const AsyncLoading();
    try {
      final created = await UserService().createUser(userData);
      state = await AsyncValue.guard(() async {
        return await UserService().fetchUser(userId: userId);
      });
      return created;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<UserSchema?> updateUser(UserCreate userData) async {
    state = const AsyncLoading();
    try {
      final updated = await UserService().updateUser(userId, userData);
      state = await AsyncValue.guard(() async {
        return await UserService().fetchUser(userId: userId);
      });
      return updated;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
