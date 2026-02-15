import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';

class MapService {
  late final MapCampaignsApi _api;
  late final ApiClient _client;

  MapService({String? baseUrl}) {
    _client = ApiClient(basePath: baseUrl ?? AppConstants.backendBaseUrl);
    _api = MapCampaignsApi(_client);
  }

  Future<List<MapCampaignSchema>> listActiveMapCampaigns() async {
    try {
      final result = await _api.listActiveMapCampaignsMapCampaignsActiveGet();
      return result ?? [];
    } catch (e) {
      throw Exception('Failed to fetch active map campaigns: $e');
    }
  }

  Future<List<MapCampaignSchema>> listMapCampaignsByType(
    MapCampaignTypeEnum campaignType,
  ) async {
    try {
      final result = await _api
          .listMapCampaignsByTypeMapCampaignsByTypeCampaignTypeGet(campaignType);
      return result ?? [];
    } catch (e) {
      throw Exception('Failed to fetch map campaigns by type: $e');
    }
  }

  Future<List<MapCampaignSchema>> listMapCampaignsByCreator(
    String userId,
  ) async {
    try {
      final result = await _api
          .listMapCampaignsByCreatorMapCampaignsCreatorUserIdGet(userId);
      return result ?? [];
    } catch (e) {
      throw Exception('Failed to fetch map campaigns by creator: $e');
    }
  }

  Future<MapCampaignSchema?> getMapCampaign(String campaignId) async {
    try {
      return await _api.getMapCampaignMapCampaignsCampaignIdGet(campaignId);
    } catch (e) {
      throw Exception('Failed to fetch map campaign: $e');
    }
  }

  Future<MapCampaignSchema?> createMapCampaign(
    MapCampaignCreateSchema body,
  ) async {
    try {
      return await _api.createMapCampaignMapCampaignsPost(body);
    } catch (e) {
      throw Exception('Failed to create map campaign: $e');
    }
  }
}
