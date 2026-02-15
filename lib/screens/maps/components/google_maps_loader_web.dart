import 'dart:async';
import 'dart:developer' as developer;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_interop';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';

const Duration _debugLogInterval = Duration(seconds: 2);
const Duration _timeout = Duration(seconds: 15);

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

/// Log current state to browser console (F12 → Console) for debugging.
void _debugLogState(int elapsedSec) {
  try {
    final ready = globalContext.getProperty('__googleMapsReady'.toJS);
    final readyDart = ready?.dartify();
    final google = globalContext.getProperty('google'.toJS);
    bool hasMaps = false;
    if (google != null) {
      final maps = (google as JSObject).getProperty('maps'.toJS);
      hasMaps = maps != null;
    }
    developer.log(
      '[MapsLoader] ${elapsedSec}s: __googleMapsReady=$readyDart, google.maps=$hasMaps',
      name: 'MapsLoader',
    );
  } catch (e) {
    developer.log('[MapsLoader] error reading state: $e', name: 'MapsLoader');
  }
}

/// Future that completes when the Google Maps JS API is available (callback ran
/// or google.maps namespace exists), or after [_timeout] so we don't hang.
Future<void> _waitForGoogleMapsReady() async {
  final stopwatch = Stopwatch()..start();
  int lastLogSec = -1;

  while (!_isGoogleMapsReady()) {
    final elapsedSec = stopwatch.elapsed.inSeconds;
    if (elapsedSec >= _timeout.inSeconds) {
      developer.log(
        '[MapsLoader] TIMEOUT after ${_timeout.inSeconds}s – showing map anyway. '
        'Check __googleMapsReady and google.maps in console above.',
        name: 'MapsLoader',
      );
      return;
    }
    if (elapsedSec != lastLogSec && elapsedSec % _debugLogInterval.inSeconds == 0) {
      lastLogSec = elapsedSec;
      _debugLogState(elapsedSec);
    }
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
  developer.log('[MapsLoader] Ready after ${stopwatch.elapsedMilliseconds}ms', name: 'MapsLoader');
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
            SizedBox(height: 8),
            Text(
              'If this hangs, open DevTools (F12) → Console and look for [MapsLoader] logs.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    },
  );
}
