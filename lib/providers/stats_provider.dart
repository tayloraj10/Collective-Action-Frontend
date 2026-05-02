import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/providers/map_events_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';

/// Aggregated counts for cleanups and trash reports (overall or for a user).
class MapSubmissionStats {
  const MapSubmissionStats({
    required this.cleanupCount,
    required this.trashReportCount,
    required this.totalSmallBags,
    required this.totalLargeBags,
    required this.totalBags,
    required this.totalPounds,
  });

  final int cleanupCount;
  final int trashReportCount;
  final int totalSmallBags;
  final int totalLargeBags;
  final int totalBags;
  final int totalPounds;

  static const MapSubmissionStats empty = MapSubmissionStats(
    cleanupCount: 0,
    trashReportCount: 0,
    totalSmallBags: 0,
    totalLargeBags: 0,
    totalBags: 0,
    totalPounds: 0,
  );
}

/// Computes map-submission stats from a list of actions, optionally filtered by [userId].
MapSubmissionStats computeMapSubmissionStats(
  List<ActionSchema> actions, {
  String? userId,
}) {
  int cleanupCount = 0;
  int trashReportCount = 0;
  int totalSmallBags = 0;
  int totalLargeBags = 0;
  int totalPounds = 0;

  for (final a in actions) {
    if (a.actionType != ActionTypeValuesEnum.mapSubmission.value) continue;
    final eventData = a.eventData;
    if (eventData == null || eventData.isEmpty) continue;

    final type = eventData['type'];
    if (type == null) continue;

    if (userId != null && a.userId != userId) continue;

    if (type == EventDataType.cleanup.value) {
      cleanupCount++;
      final small = eventData['small_bags'];
      final large = eventData['large_bags'];
      final s = small is int
          ? small
          : (small != null ? num.tryParse('$small')?.toInt() ?? 0 : 0);
      final l = large is int
          ? large
          : (large != null ? num.tryParse('$large')?.toInt() ?? 0 : 0);
      totalSmallBags += s;
      totalLargeBags += l;
      final p = eventData['pounds'];
      if (p != null) totalPounds += num.tryParse('$p')?.round() ?? 0;
    } else if (type == EventDataType.trashReport.value) {
      trashReportCount++;
    }
  }

  return MapSubmissionStats(
    cleanupCount: cleanupCount,
    trashReportCount: trashReportCount,
    totalSmallBags: totalSmallBags,
    totalLargeBags: totalLargeBags,
    totalBags: totalSmallBags + totalLargeBags,
    totalPounds: totalPounds,
  );
}

/// Overall stats (all map submissions for a campaign).
final overallMapStatsProvider =
    Provider.family<MapSubmissionStats, String>((ref, campaignId) {
  final eventsAsync = ref.watch(mapEventsForCampaignProvider(campaignId));
  return eventsAsync.when(
    data: (actions) => computeMapSubmissionStats(actions),
    loading: () => MapSubmissionStats.empty,
    error: (_, _) => MapSubmissionStats.empty,
  );
});

/// Your stats (map submissions by the current user for a campaign). Empty when not logged in.
final yourMapStatsProvider =
    Provider.family<MapSubmissionStats, String>((ref, campaignId) {
  final eventsAsync = ref.watch(mapEventsForCampaignProvider(campaignId));
  final userAsync = ref.watch(currentUserProvider);
  final userId = userAsync.value?.id;
  if (userId == null) return MapSubmissionStats.empty;
  return eventsAsync.when(
    data: (actions) => computeMapSubmissionStats(actions, userId: userId),
    loading: () => MapSubmissionStats.empty,
    error: (_, _) => MapSubmissionStats.empty,
  );
});

/// One entry in a leaderboard (cleanups, bags, or pounds).
class LeaderboardEntry {
  const LeaderboardEntry({required this.userId, required this.value});
  final String userId;
  final int value;
}

const int kLeaderboardTopCount = 10;

List<LeaderboardEntry> _top10(List<LeaderboardEntry> entries) =>
    entries.take(kLeaderboardTopCount).toList();

/// Leaderboard by number of cleanups per user (top 10).
final leaderboardCleanupsProvider =
    Provider.family<List<LeaderboardEntry>, String>((ref, campaignId) {
  final eventsAsync = ref.watch(mapEventsForCampaignProvider(campaignId));
  return eventsAsync.when(
    data: (actions) {
      final countByUser = <String, int>{};
      for (final a in actions) {
        if (a.actionType != ActionTypeValuesEnum.mapSubmission.value) continue;
        final eventData = a.eventData;
        if (eventData == null || eventData.isEmpty) continue;
        if (eventData['type'] != EventDataType.cleanup.value) continue;
        final userId = a.userId ?? '';
        if (userId.isEmpty) continue;
        countByUser[userId] = (countByUser[userId] ?? 0) + 1;
      }
      final list =
          countByUser.entries
              .map((e) => LeaderboardEntry(userId: e.key, value: e.value))
              .where((e) => e.value > 0)
              .toList()
            ..sort((a, b) => b.value.compareTo(a.value));
      return _top10(list);
    },
    loading: () => [],
    error: (_, _) => [],
  );
});

/// Leaderboard by total bags (small + large) per user (top 10).
final leaderboardBagsProvider =
    Provider.family<List<LeaderboardEntry>, String>((ref, campaignId) {
  final eventsAsync = ref.watch(mapEventsForCampaignProvider(campaignId));
  return eventsAsync.when(
    data: (actions) {
      final bagsByUser = <String, int>{};
      for (final a in actions) {
        if (a.actionType != ActionTypeValuesEnum.mapSubmission.value) continue;
        final eventData = a.eventData;
        if (eventData == null || eventData.isEmpty) continue;
        if (eventData['type'] != EventDataType.cleanup.value) continue;
        final userId = a.userId ?? '';
        if (userId.isEmpty) continue;
        final small = eventData['small_bags'];
        final large = eventData['large_bags'];
        final s = small is int
            ? small
            : (small != null ? num.tryParse('$small')?.toInt() ?? 0 : 0);
        final l = large is int
            ? large
            : (large != null ? num.tryParse('$large')?.toInt() ?? 0 : 0);
        bagsByUser[userId] = (bagsByUser[userId] ?? 0) + s + l;
      }
      final list =
          bagsByUser.entries
              .map((e) => LeaderboardEntry(userId: e.key, value: e.value))
              .where((e) => e.value > 0)
              .toList()
            ..sort((a, b) => b.value.compareTo(a.value));
      return _top10(list);
    },
    loading: () => [],
    error: (_, _) => [],
  );
});

/// Leaderboard by pounds cleaned per user (top 10).
final leaderboardPoundsProvider =
    Provider.family<List<LeaderboardEntry>, String>((ref, campaignId) {
  final eventsAsync = ref.watch(mapEventsForCampaignProvider(campaignId));
  return eventsAsync.when(
    data: (actions) {
      final poundsByUser = <String, int>{};
      for (final a in actions) {
        if (a.actionType != ActionTypeValuesEnum.mapSubmission.value) continue;
        final eventData = a.eventData;
        if (eventData == null || eventData.isEmpty) continue;
        if (eventData['type'] != EventDataType.cleanup.value) continue;
        final userId = a.userId ?? '';
        if (userId.isEmpty) continue;
        final p = eventData['pounds'];
        if (p == null) continue;
        final pounds = num.tryParse('$p')?.round() ?? 0;
        if (pounds <= 0) continue;
        poundsByUser[userId] = (poundsByUser[userId] ?? 0) + pounds;
      }
      final list =
          poundsByUser.entries
              .map((e) => LeaderboardEntry(userId: e.key, value: e.value))
              .toList()
            ..sort((a, b) => b.value.compareTo(a.value));
      return _top10(list);
    },
    loading: () => [],
    error: (_, _) => [],
  );
});
