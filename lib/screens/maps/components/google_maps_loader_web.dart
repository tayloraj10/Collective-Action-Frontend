import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_interop';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';

/// Returns true if the Maps API callback ran (__googleMapsReady) or if
/// google.maps is already on the window (script loaded but callback may not run
/// if e.g. gen_204 is blocked).
bool _isGoogleMapsReady() {
  try {
    final ready = globalContext.getProperty('__googleMapsReady'.toJS);
    if (ready != null && ready.dartify() == true) return true;
    final google = globalContext.getProperty('google'.toJS);
    if (google != null) {
      final maps = (google as JSObject).getProperty('maps'.toJS);
      if (maps != null) return true;
    }
  } catch (_) {}
  return false;
}

/// Future that completes when the Google Maps JS API is available (callback ran
/// or google.maps namespace exists, so we don't hang if the callback never runs).
Future<void> _waitForGoogleMapsReady() async {
  while (!_isGoogleMapsReady()) {
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
}

/// On web, waits for the Maps API to be ready before building [child].
Widget buildWhenGoogleMapsReady(Widget child) {
  return FutureBuilder<void>(
    future: _waitForGoogleMapsReady(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return child;
      }
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading map…'),
          ],
        ),
      );
    },
  );
}
