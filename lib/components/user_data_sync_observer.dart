import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
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

  const UserDataSyncObserver({super.key, required this.child});

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
    // Picks up the result of a mobile-web Google redirect sign-in (see
    // AuthService.signInWithGoogle) after the app reloads. authStateProvider
    // will independently emit the signed-in user; this call just surfaces
    // errors that a redirect has no other way to report.
    if (kIsWeb) _completeGoogleRedirectSignIn();
  }

  Future<void> _completeGoogleRedirectSignIn() async {
    try {
      await ref.read(authServiceProvider).getGoogleRedirectResult();
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ref
            .read(authRedirectErrorProvider.notifier)
            .set('Google sign-in failed (${e.code}). Please try again.');
      }
    } catch (_) {
      // No pending redirect — nothing to do.
    }
  }

  Future<void> _fetchOrCreateAppUser(User authUser) async {
    try {
      var appUser = await UserService().fetchUserByFirebaseID(
        userId: authUser.uid,
      );
      appUser ??= await UserService().createUser(
        UserCreate(
          email: authUser.email ?? '',
          name: authUser.displayName ?? '',
          firebaseUserId: authUser.uid,
          photoUrl: authUser.photoURL,
        ),
      );
      if (mounted && appUser != null) {
        ref.read(currentUserProvider.notifier).setUser(appUser);
      }
    } catch (_) {
      // Silently ignore errors
    }
  }

  void _syncUserData() {
    if (!mounted) return;
    final authUser = ref.read(authStateProvider).value;
    final currentUserId = authUser?.uid;

    // Only fetch if auth state has changed
    if (currentUserId != _lastAuthUserId) {
      _lastAuthUserId = currentUserId;

      if (authUser != null) {
        // User is logged in - fetch (or create, e.g. first Google sign-in
        // completed via mobile-web redirect) their data.
        _fetchOrCreateAppUser(authUser);
      } else {
        // User is logged out - clear user data. On mobile web defer slightly so
        // we don't trigger a big rebuild cascade during initial load (e.g. incognito).
        if (mounted) {
          if (kIsWeb && AppConstants.isMobile(context)) {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) ref.read(currentUserProvider.notifier).clearUser();
            });
          } else {
            ref.read(currentUserProvider.notifier).clearUser();
          }
        }
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
