import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Set when a mobile-web Google redirect sign-in (see [AuthService.signInWithGoogle])
/// completes with an error after the app reloads. Cleared once shown.
class AuthRedirectErrorNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? value) => state = value;
}

final authRedirectErrorProvider =
    NotifierProvider<AuthRedirectErrorNotifier, String?>(
      AuthRedirectErrorNotifier.new,
    );
