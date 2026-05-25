import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/hotspot_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hotspotServiceProvider = Provider<HotspotService>((ref) {
  return HotspotService();
});

final mapAreasForCampaignProvider =
    FutureProvider.family<List<MapAreaSchema>, String>((ref, campaignId) async {
  return ref.read(hotspotServiceProvider).fetchAreas(campaignId);
});

final mapHotspotsForCampaignProvider =
    FutureProvider.family<List<MapHotspotSchema>, String>((ref, campaignId) async {
  return ref.read(hotspotServiceProvider).fetchHotspots(campaignId);
});

final areaCaptainsForCampaignProvider =
    FutureProvider.family<List<AreaCaptainSchema>, String>((ref, campaignId) async {
  return ref.read(hotspotServiceProvider).fetchAreaCaptains(campaignId);
});

/// Case-insensitive match for backend user UUID strings.
bool userIdsMatch(String? a, String? b) {
  if (a == null || b == null) return false;
  final left = a.trim();
  final right = b.trim();
  if (left.isEmpty || right.isEmpty) return false;
  return left.toLowerCase() == right.toLowerCase();
}

bool isUserAreaCaptain({
  required String? userId,
  required List<AreaCaptainSchema> captains,
}) {
  if (userId == null || userId.isEmpty) return false;
  return captains.any((c) => userIdsMatch(c.captainUserId, userId));
}

/// True when [userId] may add hotspots (must be assigned captain; not admin-only).
bool canUserManageHotspots({
  required String? userId,
  required AsyncValue<List<AreaCaptainSchema>> captainsAsync,
}) {
  if (userId == null || userId.isEmpty) return false;
  return captainsAsync.when(
    data: (captains) => isUserAreaCaptain(userId: userId, captains: captains),
    loading: () => false,
    error: (_, _) => false,
  );
}

List<MapAreaSchema> captainAreasForUser({
  required String? userId,
  required List<AreaCaptainSchema> captains,
  required List<MapAreaSchema> areas,
}) {
  if (userId == null || userId.isEmpty) return [];
  final captainAreaIds = captains
      .where((c) => userIdsMatch(c.captainUserId, userId))
      .map((c) => c.mapAreaId)
      .toSet();
  if (captainAreaIds.isEmpty) return [];

  final byId = <String, MapAreaSchema>{};
  for (final captain in captains) {
    if (userIdsMatch(captain.captainUserId, userId) && captain.area != null) {
      byId[captain.area!.id] = captain.area!;
    }
  }
  for (final area in areas) {
    if (captainAreaIds.contains(area.id)) {
      byId[area.id] = area;
    }
  }
  return byId.values.toList()..sort((a, b) => a.name.compareTo(b.name));
}

/// Areas where the current user is captain for the given campaign.
final userCaptainAreasProvider =
    Provider.family<List<MapAreaSchema>, String>((ref, campaignId) {
  final userId = ref.watch(currentUserProvider.select((u) => u.value?.id));
  if (userId == null) return [];

  final captainsAsync = ref.watch(areaCaptainsForCampaignProvider(campaignId));
  final areas = ref.watch(
    mapAreasForCampaignProvider(campaignId).select((a) => a.value ?? const []),
  );

  return captainsAsync.when(
    data: (rows) => captainAreasForUser(
      userId: userId,
      captains: rows,
      areas: areas,
    ),
    loading: () => [],
    error: (_, _) => [],
  );
});

/// True when the current user can add hotspots (assigned captain of any area).
final canManageHotspotsProvider = Provider.family<bool, String>((ref, campaignId) {
  final userId = ref.watch(currentUserProvider.select((u) => u.value?.id));
  if (userId == null) return false;

  final captainsAsync = ref.watch(areaCaptainsForCampaignProvider(campaignId));
  return canUserManageHotspots(userId: userId, captainsAsync: captainsAsync);
});

bool isCaptainOfArea(
  List<AreaCaptainSchema> captains,
  String? userId,
  String mapAreaId,
) {
  if (userId == null) return false;
  return captains.any(
    (c) =>
        userIdsMatch(c.mapAreaId, mapAreaId) &&
        userIdsMatch(c.captainUserId, userId),
  );
}

bool canManageAreaHotspots({
  required bool isAdmin,
  required List<AreaCaptainSchema> captains,
  required String? userId,
  required String mapAreaId,
}) {
  return isAdmin || isCaptainOfArea(captains, userId, mapAreaId);
}

List<AreaCaptainSchema> captainsForArea(
  List<AreaCaptainSchema> captains,
  String mapAreaId,
) {
  return captains.where((c) => c.mapAreaId == mapAreaId).toList();
}

Map<String, List<AreaCaptainSchema>> groupCaptainsByAreaId(
  List<AreaCaptainSchema> captains,
) {
  final grouped = <String, List<AreaCaptainSchema>>{};
  for (final c in captains) {
    grouped.putIfAbsent(c.mapAreaId, () => []).add(c);
  }
  return grouped;
}

/// Active hotspot for a borough, if any (at most one should be active per area).
MapHotspotSchema? activeHotspotForArea(
  List<MapHotspotSchema> hotspots,
  String mapAreaId,
) {
  for (final hotspot in hotspots) {
    if (hotspot.active && hotspot.mapAreaId == mapAreaId) {
      return hotspot;
    }
  }
  return null;
}
