import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
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

  /// Picks a random success sound and returns the correct `Source` for the
  /// current platform.
  /// - Web: uses `/assets/<path>` via `UrlSource`
  /// - Mobile/Desktop: uses `AssetSource(<path>)`
  static ({Source source, Duration maxDuration}) randomSuccessSoundSource({
    Random? random,
    Duration maxDuration = const Duration(seconds: 10),
  }) {
    final rng = random ?? Random();
    const List<String> successSounds = <String>[
      'sounds/crab_rave.mp3',
      'sounds/higher.mp3',
    ];
    if (successSounds.isEmpty) {
      return (
        source: AssetSource('sounds/crab_rave.mp3'),
        maxDuration: maxDuration,
      );
    }
    final path = successSounds[rng.nextInt(successSounds.length)];
    final resultSource = kIsWeb
        ? UrlSource('/assets/$path')
        : AssetSource(path);
    return (source: resultSource, maxDuration: maxDuration);
  }
}
