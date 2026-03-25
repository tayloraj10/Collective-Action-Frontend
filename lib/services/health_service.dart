import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';

class HealthService {
  static Future<String?>? _startupHealthCheckFuture;
  late final DefaultApi _api;

  HealthService({String? baseUrl}) {
    final client = ApiClient(basePath: baseUrl ?? AppConstants.backendBaseUrl);
    _api = DefaultApi(client);
  }

  Future<String?> fetchHealth() async {
    try {
      final response = await _api.healthHealthGetWithHttpInfo();
      return response.body;
    } catch (e) {
      throw Exception('Failed to fetch health: $e');
    }
  }

  /// Starts (or reuses) the single app-start health check request.
  static Future<String?> ensureStartupHealthCheck() {
    _startupHealthCheckFuture ??= HealthService().fetchHealth();
    return _startupHealthCheckFuture!;
  }
}
