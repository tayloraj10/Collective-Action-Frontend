import 'dart:math';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/providers/sound_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// App-wide constants

class AppConstants {
  // Backend API base URL
  static String get backendBaseUrl {
    const bool inDebugMode = bool.fromEnvironment('dart.vm.product') == false;
    if (inDebugMode) {
      return 'http://localhost:8080';
    } else {
      return 'https://collective-action-backend-978597455378.us-central1.run.app';
    }
  }

  static const String discordLink = 'https://discord.gg/NqGXmvqCNx';

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

  static const List<String> _successSounds = <String>[
    'assets/sounds/around-the-world.mp3',
    'assets/sounds/billie-jean.mp3',
    'assets/sounds/cowboy-bebop.mp3',
    'assets/sounds/crab_rave.mp3',
    'assets/sounds/earth song.mp3',
    'assets/sounds/hero-nickleback.mp3',
    'assets/sounds/higher.mp3',
    'assets/sounds/pirates.mp3',
    'assets/sounds/sweet_victory.mp3',
    'assets/sounds/what_is_love.mp3',
  ];

  /// Picks a random success sound asset path and max duration.
  static ({String path, Duration maxDuration}) randomSuccessSoundSource({
    Random? random,
    Duration maxDuration = const Duration(seconds: 8),
  }) {
    final rng = random ?? Random();
    final path = _successSounds[rng.nextInt(_successSounds.length)];
    return (path: path, maxDuration: maxDuration);
  }

  /// Convenience helper to play a random success sound once.
  ///
  /// Swallows any audio errors so it is safe to call from
  /// anywhere without impacting UX if audio fails.
  static Future<void> playRandomSuccessSound() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(soundEnabledPrefsKey) == false) return;
      final player = AudioPlayer();
      final (:path, :maxDuration) = randomSuccessSoundSource();
      await player.setAsset(path);
      await player.play();
      Future.delayed(maxDuration, () async {
        await player.stop();
        await player.dispose();
      });
    } catch (_) {
      // Intentionally ignore audio errors
    }
  }

  /// Plays the success sound and shows the confetti overlay together.
  /// Call this for any success celebration so both always run at the same time.
  static void playSuccessCelebration(BuildContext context) {
    playRandomSuccessSound();
    showCelebrationOverlay(context);
  }
}
