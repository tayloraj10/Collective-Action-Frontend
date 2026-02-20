import 'package:collective_action_frontend/app/constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Delay used on mobile web so the browser finishes the tap/gesture before we
/// navigate or pop. Reduces crashes and jank on mobile Chrome (Flutter 3.38 +
/// Riverpod 3.x). Slightly longer delay helps avoid ref-after-dispose during
/// route transition.
const Duration _kMobileWebNavDelay = Duration(milliseconds: 220);

/// True when running on web and the viewport is mobile-sized. Navigation and
/// dialog open/close are more fragile on mobile Chrome; we defer with a short
/// delay in that case.
bool _isMobileWeb(BuildContext context) {
  return kIsWeb && AppConstants.isMobile(context);
}

/// Schedules [context.go(route)] so it does not run during the tap that
/// triggered it. On mobile web uses a short delay to reduce crashes and jank.
void safeGo(BuildContext context, String route) {
  if (_isMobileWeb(context)) {
    Future.delayed(_kMobileWebNavDelay, () {
      if (context.mounted) context.go(route);
    });
  } else {
    Future.microtask(() {
      if (context.mounted) context.go(route);
    });
  }
}

/// Schedules [Navigator.of(context).pop()] so it does not run during the tap.
/// On mobile web uses a short delay. Pass [rootNavigator: true] if needed.
void safePop(BuildContext context, {bool rootNavigator = false}) {
  if (_isMobileWeb(context)) {
    Future.delayed(_kMobileWebNavDelay, () {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: rootNavigator).pop();
      }
    });
  } else {
    Future.microtask(() {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: rootNavigator).pop();
      }
    });
  }
}

/// Schedules [action] to run after the current tap. On mobile web uses a short
/// delay so the browser can finish the gesture; use for navigation, pop, or
/// opening dialogs from tap handlers to reduce crashes and jank.
void scheduleAfterTap(BuildContext context, void Function() action) {
  if (_isMobileWeb(context)) {
    Future.delayed(_kMobileWebNavDelay, () {
      if (context.mounted) action();
    });
  } else {
    Future.microtask(() {
      if (context.mounted) action();
    });
  }
}
