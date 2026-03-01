import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/services/user_service.dart';

/// Global provider for the currently active backend user
final currentUserProvider =
    AsyncNotifierProvider<CurrentUserNotifier, UserSchema?>(
      CurrentUserNotifier.new,
    );

/// True when the current user is loaded and is an admin. Easy to use with
/// `ref.watch(isCurrentUserAdminProvider)` or `ref.read(isCurrentUserAdminProvider)`.
final isCurrentUserAdminProvider = Provider<bool>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.value;
  return UserService.isAdmin(user);
});

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

  /// Refresh current user from backend by database user id (users table id).
  Future<void> refreshUser(String dbUserId) async {
    state = const AsyncLoading();
    final user = await UserService().fetchUserByUserID(userId: dbUserId);
    state = AsyncValue.data(user);
  }
}

/// Fetches and holds a user by their database user id (users table primary key).
/// Use this for refresh/update after you have the user; for initial load when you
/// only have Firebase UID, use [UserService.fetchUserByFirebaseID] then set [currentUserProvider].
/// autoDispose limits cache growth when navigating away from profiles.
final userProvider =
    AsyncNotifierProvider.autoDispose.family<UserNotifier, UserSchema?, String>(
      (dbUserId) => UserNotifier(dbUserId),
    );

class UserNotifier extends AsyncNotifier<UserSchema?> {
  final String dbUserId;
  UserNotifier(this.dbUserId);

  @override
  Future<UserSchema?> build() async {
    return await UserService().fetchUserByUserID(userId: dbUserId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await UserService().fetchUserByUserID(userId: dbUserId);
    });
  }

  Future<UserSchema?> updateUser(UserUpdate userData) async {
    state = const AsyncLoading();
    try {
      final updated = await UserService().updateUser(dbUserId, userData);
      state = await AsyncValue.guard(() async {
        return await UserService().fetchUserByUserID(userId: dbUserId);
      });
      return updated;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

/// Provider for fetching a user by database user ID (not Firebase ID)
// final databaseUserProvider =
//     AsyncNotifierProvider.family<UserByUserIdNotifier, UserSchema?, String>(
//       (userId) => UserByUserIdNotifier(userId),
//     );

class UserByUserIdNotifier extends AsyncNotifier<UserSchema?> {
  final String userId;

  UserByUserIdNotifier(this.userId);

  @override
  Future<UserSchema?> build() async {
    return await UserService().fetchUserByUserID(userId: userId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await UserService().fetchUserByUserID(userId: userId);
    });
  }
}
