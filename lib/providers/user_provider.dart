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
final userProvider =
    AsyncNotifierProvider.family<UserNotifier, UserSchema?, String>(
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
    final previousUser = state.value;
    try {
      final updated = await UserService().updateUser(dbUserId, userData);
      if (updated == null) {
        throw Exception('Update returned no user');
      }

      // Profile photo is saved via a separate endpoint; keep it if the PATCH
      // response doesn't include one.
      final photoUrl =
          (updated.photoUrl == null || updated.photoUrl!.isEmpty)
          ? previousUser?.photoUrl
          : updated.photoUrl;
      final merged = photoUrl == updated.photoUrl
          ? updated
          : UserSchema(
              id: updated.id,
              email: updated.email,
              name: updated.name,
              photoUrl: photoUrl,
              userType: updated.userType,
              isActive: updated.isActive,
              admin: updated.admin,
              location: updated.location,
              socialLinks: updated.socialLinks,
              firebaseUserId: updated.firebaseUserId,
              createdAt: updated.createdAt,
              updatedAt: updated.updatedAt,
            );

      state = AsyncValue.data(merged);
      return merged;
    } catch (e, st) {
      if (previousUser != null) {
        state = AsyncValue.data(previousUser);
      } else {
        state = AsyncError(e, st);
      }
      rethrow;
    }
  }
}
