import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  Future<User?> registerWithEmail(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  /// Google rejects the popup-based OAuth flow from mobile web browsers
  /// (Safari/Chrome on iOS and Android), surfacing as "Access blocked: this
  /// app's request is invalid" — so mobile web must use the redirect flow
  /// instead. `defaultTargetPlatform` reflects the underlying OS on Flutter
  /// web (iOS/Android for mobile browsers), so no user-agent sniffing needed.
  bool get _isMobileWeb =>
      kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  /// Sign in with Google across platforms (Web uses popup on desktop /
  /// redirect on mobile web; native mobile uses GoogleSignIn).
  Future<User?> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      provider.addScope('email');
      if (_isMobileWeb) {
        // Navigates away; the result is picked up on the next app load via
        // getGoogleRedirectResult().
        await _auth.signInWithRedirect(provider);
        return null;
      }
      final userCred = await _auth.signInWithPopup(provider);
      return userCred.user;
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? gUser = await googleSignIn.signIn();
      if (gUser == null) {
        throw FirebaseAuthException(
          code: 'canceled',
          message: 'Sign-in canceled by user',
        );
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      final userCred = await _auth.signInWithCredential(credential);
      return userCred.user;
    }
  }

  /// Completes a Google sign-in started by the redirect branch of
  /// [signInWithGoogle]. Call once on app startup; resolves to null if there
  /// is no pending redirect result.
  Future<User?> getGoogleRedirectResult() async {
    final cred = await _auth.getRedirectResult();
    return cred.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
