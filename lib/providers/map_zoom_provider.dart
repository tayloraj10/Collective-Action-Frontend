import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Request the map to zoom to a location. Set to non-null to zoom; map clears after animating.
class MapZoomToNotifier extends Notifier<LatLng?> {
  @override
  LatLng? build() => null;

  void setLocation(LatLng? value) {
    state = value;
  }
}

final mapZoomToLocationProvider =
    NotifierProvider<MapZoomToNotifier, LatLng?>(MapZoomToNotifier.new);

/// True while the campaign info bottom drawer is open; map disables gestures (like info dialog).
class CampaignDrawerOpenNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setOpen(bool value) {
    state = value;
  }
}

final campaignDrawerOpenProvider =
    NotifierProvider<CampaignDrawerOpenNotifier, bool>(
        CampaignDrawerOpenNotifier.new);

/// True while the area captains bottom sheet is open; map disables gestures.
class AreaCaptainsSheetOpenNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setOpen(bool value) {
    state = value;
  }
}

final areaCaptainsSheetOpenProvider =
    NotifierProvider<AreaCaptainsSheetOpenNotifier, bool>(
        AreaCaptainsSheetOpenNotifier.new);

/// Set when a full-screen overlay (e.g. PhotoViewerDialog) was just closed.
/// The map ignores "tap to close drawer" for a short window so the same tap
/// doesn't close the campaign info sheet.
class PhotoViewerClosedAtNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;

  void setClosed() {
    state = DateTime.now();
  }
}

final photoViewerClosedAtProvider =
    NotifierProvider<PhotoViewerClosedAtNotifier, DateTime?>(
        PhotoViewerClosedAtNotifier.new);
