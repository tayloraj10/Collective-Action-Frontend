import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_interop';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_interop_unsafe';

import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';

const Duration _debugLogInterval = Duration(seconds: 2);
const Duration _timeout = Duration(seconds: 10);
const Duration _releaseFixedDelay = Duration(seconds: 4);

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
    print('[MapsLoader] ${elapsedSec}s: __googleMapsReady=$readyDart, google.maps=$hasMaps');
  } catch (e) {
    print('[MapsLoader] error reading state: $e');
  }
}

/// Future that completes when the Google Maps JS API is available.
/// In release/production we use a fixed short delay (avoids minified js_interop
/// and stripped callback issues). In debug we poll for ready or timeout.
Future<void> _waitForGoogleMapsReady() async {
  if (kReleaseMode) {
    await Future<void>.delayed(_releaseFixedDelay);
    return;
  }

  print('[MapsLoader] waiting for Google Maps API...');
  final stopwatch = Stopwatch()..start();
  int lastLogSec = -1;

  while (!_isGoogleMapsReady()) {
    final elapsedSec = stopwatch.elapsed.inSeconds;
    if (elapsedSec >= _timeout.inSeconds) {
      print('[MapsLoader] TIMEOUT after ${_timeout.inSeconds}s – showing map anyway.');
      return;
    }
    if (elapsedSec != lastLogSec && elapsedSec % _debugLogInterval.inSeconds == 0) {
      lastLogSec = elapsedSec;
      _debugLogState(elapsedSec);
    }
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
  print('[MapsLoader] Ready after ${stopwatch.elapsedMilliseconds}ms');
}

/// On web, waits for the Maps API to be ready before building [child].
/// Uses a StatefulWidget so the future is created once and not reset on parent rebuilds.
Widget buildWhenGoogleMapsReady(Widget child) {
  return _GoogleMapsLoaderWidget(child: child);
}

class _GoogleMapsLoaderWidget extends StatefulWidget {
  const _GoogleMapsLoaderWidget({required this.child});

  final Widget child;

  @override
  State<_GoogleMapsLoaderWidget> createState() => _GoogleMapsLoaderWidgetState();
}

class _GoogleMapsLoaderWidgetState extends State<_GoogleMapsLoaderWidget> {
  late final Future<void> _mapsReadyFuture = _waitForGoogleMapsReady();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _mapsReadyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.child;
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
                'Map may take a few seconds to appear.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
