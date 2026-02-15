import 'package:flutter/material.dart';

import 'google_maps_loader_stub.dart'
    if (dart.library.html) 'google_maps_loader_web.dart' as impl;

/// Wraps the full-page map content so that on web we wait for the Google Maps
/// JS API to be ready (async loading + callback) before building the child.
/// On non-web platforms this builds the child immediately.
Widget buildWhenGoogleMapsReady(Widget child) {
  return impl.buildWhenGoogleMapsReady(child);
}
