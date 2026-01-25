import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';

class InitiativesService {
  late final InitiativesApi _api;

  InitiativesService({String? baseUrl}) {
    final client = ApiClient(basePath: baseUrl ?? AppConstants.backendBaseUrl);
    _api = InitiativesApi(client);
  }

  Future<List<InitiativeSchema>?> fetchInitiatives() async {
    try {
      return await _api.listInitiativesInitiativesGet();
    } catch (e) {
      throw Exception('Failed to fetch initiatives: $e');
    }
  }

  Future<List<InitiativeSchema>?> fetchActiveInitiatives() async {
    try {
      return await _api.listActiveInitiativesInitiativesActiveGet();
    } catch (e) {
      throw Exception('Failed to fetch initiatives: $e');
    }
  }

  Future<List<InitiativeSchema>?> fetchFeaturedInitiatives() async {
    try {
      return await _api.getFeaturedInitiativesInitiativesFeaturedGet();
    } catch (e) {
      throw Exception('Failed to fetch initiatives: $e');
    }
  }

  Future<List<InitiativeSchema>> fetchInitiativesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    try {
      // Check the correct parameter name and usage for the generated API method
      final result = await _api.getInitiativesByIdsInitiativesByIdsGet(ids);
      return result ?? [];
    } catch (e) {
      throw Exception('Failed to batch fetch initiatives: $e');
    }
  }
}
