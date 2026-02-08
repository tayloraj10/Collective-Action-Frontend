import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
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

  static const List<String> _successSounds = <String>[
    'assets/sounds/crab_rave.mp3',
    'assets/sounds/higher.mp3',
  ];

  /// Picks a random success sound asset path and max duration.
  static ({String path, Duration maxDuration}) randomSuccessSoundSource({
    Random? random,
    Duration maxDuration = const Duration(seconds: 10),
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
}
