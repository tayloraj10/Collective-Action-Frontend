import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/services/actions_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Map events for a map campaign: actions with latitude, longitude, and optional event_data.
final mapEventsForCampaignProvider =
    FutureProvider.family<List<ActionSchema>, String>((ref, campaignId) async {
  return await ActionsService().fetchMapEvents(campaignId);
});
