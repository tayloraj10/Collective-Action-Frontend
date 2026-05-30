import 'dart:async';
import 'dart:math';
import 'package:collective_action_frontend/app/success_sounds.g.dart';
import 'package:collective_action_frontend/app/version.g.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/providers/sound_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// App-wide constants

class AppConstants {
  /// Label shown before version (e.g. 'Beta', '' for production).
  static const String appReleaseLabel = 'Beta';

  /// App version shown in UI (from pubspec.yaml via version.g.dart).
  static String get appVersionFallback => appVersion;

  // Backend API base URL
  static String get backendBaseUrl {
    const bool inDebugMode = bool.fromEnvironment('dart.vm.product') == false;
    if (inDebugMode) {
      return 'http://localhost:8080';
    } else {
      return 'https://collective-action-backend-978597455378.us-central1.run.app';
    }
  }

  static const String discordLink = 'https://discord.gg/TupVgmuhCA';

  static const String supportEmail = 'collectiveactionsupport@gmail.com';

  // Breakpoints
  static const double mobileBreakpoint = 600;

  // Helper method to check if device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  // Opens a URL in an external application
  static Future<void> openUrl(String url) async {
    // You must import 'package:url_launcher/url_launcher.dart' in the file where you use this function.
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  /// Shows a full-screen celebration confetti overlay.
  ///
  /// Requires [context] from a widget under MaterialApp so the overlay can be
  /// inserted. Uses a full-screen overlay so confetti is visible on web (the
  /// package's default 2x2 container can clip on web). Safe to call from
  /// anywhere with a valid context; swallows errors.
  static void showCelebrationOverlay(BuildContext context) {
    try {
      final overlay = Overlay.of(context);
      final controller = ConfettiController();
      OverlayEntry? entry;

      final isMobile = AppConstants.isMobile(context);
      final options = ConfettiOptions(
        particleCount: isMobile ? 55 : 150,
        angle: 90,
        spread: isMobile ? 95 : 180,
        startVelocity: isMobile ? 28 : 40,
        decay: 0.92,
        gravity: isMobile ? 0.4 : 0.35,
        drift: 0,
        x: 0.5,
        y: isMobile ? 0.4 : 0.35,
        colors: [
          AppColors.successGreen,
          AppColors.primaryBlue,
          AppColors.lightBlue,
          AppColors.highlightYelllow,
          AppColors.warningOrange,
        ],
        scalar: isMobile ? 0.85 : 1.2,
        ticks: isMobile ? 180 : 280,
      );

      entry = OverlayEntry(
        opaque: false,
        builder: (BuildContext overlayContext) {
          return IgnorePointer(
            child: SizedBox.expand(
              child: Confetti(
                controller: controller,
                options: options,
                instant: false,
                onFinished: () {
                  entry?.remove();
                },
              ),
            ),
          );
        },
      );

      overlay.insert(entry);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.launch();
      });
    } catch (_) {
      // Intentionally ignore so UX is not impacted
    }
  }

  // Web: preloaded player used to unlock AudioContext on first user gesture (mobile browsers).
  static AudioPlayer? _webUnlockPlayer;
  static bool _webAudioUnlocked = false;

  /// Call from main() when kIsWeb so a player is ready to play on first tap.
  static void preloadAudioForWeb() {
    if (!kIsWeb || _webUnlockPlayer != null) return;
    _webUnlockPlayer = AudioPlayer();
    _webUnlockPlayer!.setAsset(successSoundPaths.first).catchError((_) => null);
  }

  /// Call from a user gesture handler on web so later sounds can play. Muted so user hears nothing.
  /// Attempts play on first tap even if preload is not ready yet (removes _webUnlockReady guard)
  /// so the gesture can unlock AudioContext on mobile; playing with volume 0 is inaudible.
  static void unlockAudioForWeb() {
    if (!kIsWeb || _webAudioUnlocked) return;
    if (_webUnlockPlayer == null) return;
    _webAudioUnlocked = true;
    try {
      _webUnlockPlayer!.setVolume(0);
      _webUnlockPlayer!.play();
      Future.delayed(const Duration(milliseconds: 150), () {
        _webUnlockPlayer?.stop();
      });
    } catch (_) {}
  }

  /// Picks a random success sound asset path and max duration.
  /// Success sounds list is generated from assets/sounds/*.mp3 — run:
  ///   dart run scripts/generate_success_sounds.dart
  /// after adding new sound files.
  static ({String path, Duration maxDuration}) randomSuccessSoundSource({
    Random? random,
    Duration maxDuration = const Duration(seconds: 13),
  }) {
    final rng = random ?? Random();
    final path = successSoundPaths[rng.nextInt(successSoundPaths.length)];
    return (path: path, maxDuration: maxDuration);
  }

  static AudioPlayer? _currentSuccessPlayer;
  static Timer? _successSoundStopTimer;
  static StreamSubscription<PlayerState>? _successPlayerStateSubscription;
  static final ValueNotifier<bool> successSoundPlaying = ValueNotifier<bool>(
    false,
  );

  /// Convenience helper to play a random success sound once.
  /// Stops any currently playing success sound first. Stops after [maxDuration] (default 13s).
  /// Uses await play() and setVolume(1.0) for mobile web (iOS Safari). Unlock via [unlockAudioForWeb] on first tap.
  static Future<void> playRandomSuccessSound() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(soundEnabledPrefsKey) == false) return;
      // Cancel any pending stop timer from a previous play
      _successSoundStopTimer?.cancel();
      _successSoundStopTimer = null;
      // Stop previous success sound if still playing
      if (_currentSuccessPlayer != null) {
        try {
          await _successPlayerStateSubscription?.cancel();
          _successPlayerStateSubscription = null;
          await _currentSuccessPlayer!.stop();
          await _currentSuccessPlayer!.dispose();
        } catch (_) {}
        _currentSuccessPlayer = null;
        successSoundPlaying.value = false;
      }
      final player = AudioPlayer();
      _currentSuccessPlayer = player;
      successSoundPlaying.value = true;
      _successPlayerStateSubscription = player.playerStateStream.listen((
        playerState,
      ) async {
        if (_currentSuccessPlayer != player) return;
        final isPlaying = playerState.playing;
        successSoundPlaying.value = isPlaying;
        if (playerState.processingState == ProcessingState.completed) {
          try {
            await _successPlayerStateSubscription?.cancel();
            _successPlayerStateSubscription = null;
            await player.stop();
            await player.dispose();
          } catch (_) {}
          if (_currentSuccessPlayer == player) _currentSuccessPlayer = null;
          _successSoundStopTimer?.cancel();
          _successSoundStopTimer = null;
          successSoundPlaying.value = false;
        }
      });
      final (:path, :maxDuration) = randomSuccessSoundSource();
      await player.setAsset(path);
      player.setVolume(1.0);
      await player.play();
      _successSoundStopTimer = Timer(maxDuration, () async {
        _successSoundStopTimer = null;
        if (_currentSuccessPlayer != player) return;
        try {
          await _successPlayerStateSubscription?.cancel();
          _successPlayerStateSubscription = null;
          await player.stop();
          await player.dispose();
        } catch (_) {}
        if (_currentSuccessPlayer == player) _currentSuccessPlayer = null;
        successSoundPlaying.value = false;
      });
    } catch (_) {
      try {
        await _successPlayerStateSubscription?.cancel();
      } catch (_) {}
      _successPlayerStateSubscription = null;
      _currentSuccessPlayer = null;
      _successSoundStopTimer = null;
      successSoundPlaying.value = false;
    }
  }

  /// Plays the success sound and shows the confetti overlay together.
  /// Call this for any success celebration so both always run at the same time.
  ///
  /// On mobile web, audio requires a user gesture to unlock. The app unlocks on first tap
  /// anywhere (see [unlockAudioForWeb]). If this is called after an async gap (e.g. after an
  /// API call), sound may still be blocked; having the user tap once in the session first helps.
  static void playSuccessCelebration(BuildContext context) {
    playRandomSuccessSound();
    showCelebrationOverlay(context);
  }
}
