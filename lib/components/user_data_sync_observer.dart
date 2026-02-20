import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/providers/auth_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/user_service.dart';

/// A widget that observes auth state changes and automatically syncs user data.
/// 
/// This should be placed near the root of your widget tree (e.g., in MyApp)
/// to ensure user data is always fetched when auth state changes.
/// 
/// Usage:
/// ```dart
/// UserDataSyncObserver(
///   child: MaterialApp.router(...),
/// )
/// ```
class UserDataSyncObserver extends ConsumerStatefulWidget {
  final Widget child;

  const UserDataSyncObserver({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<UserDataSyncObserver> createState() =>
      _UserDataSyncObserverState();
}

class _UserDataSyncObserverState extends ConsumerState<UserDataSyncObserver> {
  String? _lastAuthUserId;

  @override
  void initState() {
    super.initState();
    // Defer sync to after first frame (Riverpod 3.x / Flutter 3.38: no async in initState)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncUserData();
    });
  }

  void _syncUserData() {
    final authUser = ref.read(authStateProvider).value;
    final currentUserId = authUser?.uid;

    // Only fetch if auth state has changed
    if (currentUserId != _lastAuthUserId) {
      _lastAuthUserId = currentUserId;

      if (authUser != null) {
        // User is logged in - fetch their data
        UserService().fetchUserByFirebaseID(userId: authUser.uid).then(
          (appUser) {
            if (mounted && appUser != null) {
              ref.read(currentUserProvider.notifier).setUser(appUser);
            }
          },
          onError: (_) {
            // Silently ignore errors
          },
        );
      } else {
        // User is logged out - clear user data
        ref.read(currentUserProvider.notifier).clearUser();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes and sync user data
    ref.listen(authStateProvider, (previous, next) {
      _syncUserData();
    });

    return widget.child;
  }
}
