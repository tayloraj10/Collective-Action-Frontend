import 'package:dio/dio.dart';
import '../app/constants.dart';

class ApiService {
  final Dio _dio = Dio();

  /// Example: GET /health endpoint
  Future<String> getHealth() async {
    final url = '${AppConstants.backendBaseUrl}/health';
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        // Assuming the health endpoint returns a simple string or JSON
        return response.data.toString();
      } else {
        throw Exception('Failed to get health: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: \\${e.message}');
    }
  }
}
