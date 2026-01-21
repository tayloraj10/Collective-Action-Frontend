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
}
