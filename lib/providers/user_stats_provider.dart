import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/services/user_stats_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _userStatsServiceProvider = Provider((_) => UserStatsService());

final userStatsProvider =
    FutureProvider.family<UserStatsSchema, String>((ref, userId) {
  return ref.read(_userStatsServiceProvider).getStats(userId);
});

final userRecentActionsProvider =
    FutureProvider.family<List<ActionSchema>, String>((ref, userId) {
  return ref.read(_userStatsServiceProvider).getUserActions(userId, limit: 30);
});
