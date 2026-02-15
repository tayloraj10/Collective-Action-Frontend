import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_interop';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';

/// Future that completes when the Google Maps JS API has loaded (callback ran).
Future<void> _waitForGoogleMapsReady() async {
  while (true) {
    try {
      final value = globalContext.getProperty('__googleMapsReady'.toJS);
      if (value != null && value.dartify() == true) return;
    } catch (_) {}
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
