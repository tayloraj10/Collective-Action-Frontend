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
  Future<void> refreshUser(String firebaseID) async {
    state = const AsyncLoading();
    final user = await UserService().fetchUserByFirebaseID(userId: firebaseID);
    state = AsyncValue.data(user);
  }
}

final userProvider =
    AsyncNotifierProvider.family<UserNotifier, UserSchema?, String>(
      (firebaseID) => UserNotifier(firebaseID),
    );

class UserNotifier extends AsyncNotifier<UserSchema?> {
  final String firebaseID;
  UserNotifier(this.firebaseID);

  @override
  Future<UserSchema?> build() async {
    return await UserService().fetchUserByFirebaseID(userId: firebaseID);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await UserService().fetchUserByFirebaseID(userId: firebaseID);
    });
  }

  Future<UserSchema?> createUser(UserCreate userData) async {
    state = const AsyncLoading();
    try {
      final created = await UserService().createUser(userData);
      state = await AsyncValue.guard(() async {
        return await UserService().fetchUserByFirebaseID(userId: firebaseID);
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
      final updated = await UserService().updateUser(firebaseID, userData);
      state = await AsyncValue.guard(() async {
        return await UserService().fetchUserByFirebaseID(userId: firebaseID);
      });
      return updated;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

/// Provider for fetching a user by database user ID (not Firebase ID)
final databaseUserProvider =
    AsyncNotifierProvider.family<UserByUserIdNotifier, UserSchema?, String>(
      (userId) => UserByUserIdNotifier(userId),
    );

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
