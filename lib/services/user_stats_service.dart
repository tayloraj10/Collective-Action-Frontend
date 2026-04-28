import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:dio/dio.dart';

class UserStatsService {
  UserStatsService({String? baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl ?? AppConstants.backendBaseUrl,
          contentType: 'application/json',
        ));

  final Dio _dio;

  Future<UserStatsSchema> getStats(String userId) async {
    final r = await _dio.get('/users/db/$userId/stats');
    return UserStatsSchema.fromJson(r.data as Map<String, dynamic>)!;
  }

  Future<List<ActionSchema>> getUserActions(String userId,
      {int limit = 20}) async {
    final r = await _dio.get<List<dynamic>>(
      '/actions/user/$userId',
      queryParameters: {'limit': limit},
    );
    return (r.data ?? [])
        .map((j) => ActionSchema.fromJson(j as Map<String, dynamic>)!)
        .toList();
  }
}
