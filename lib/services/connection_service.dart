import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:dio/dio.dart';

class ConnectionService {
  ConnectionService({String? baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl ?? AppConstants.backendBaseUrl,
          contentType: 'application/json',
        ));

  final Dio _dio;

  Future<ConnectionWithUserSchema> createConnection({
    required String createdBy,
    required String fromType,
    required String fromId,
    required String toType,
    required String toId,
  }) async {
    final response = await _dio.post('/connections/', data: {
      'created_by': createdBy,
      'from_type': fromType,
      'from_id': fromId,
      'to_type': toType,
      'to_id': toId,
    });
    return ConnectionWithUserSchema.fromJson(
      response.data as Map<String, dynamic>,
    )!;
  }

  Future<void> deleteConnection(String connectionId, String userId) async {
    await _dio.delete(
      '/connections/$connectionId',
      queryParameters: {'user_id': userId},
    );
  }

  Future<List<ConnectionWithUserSchema>> getConnectionsForUser(
    String userId,
  ) async {
    final response = await _dio.get('/connections/user/$userId');
    return (response.data as List)
        .map(
          (j) => ConnectionWithUserSchema.fromJson(j as Map<String, dynamic>)!,
        )
        .toList();
  }

  Future<List<ConnectionWithUserSchema>> getConnectionsForEntity({
    required String toType,
    required String toId,
    String? connectionType,
  }) async {
    final response = await _dio.get(
      '/connections/entity/$toType/$toId',
      queryParameters: {
        if (connectionType != null && connectionType.isNotEmpty)
          'connection_type': connectionType,
      },
    );
    return (response.data as List)
        .map(
          (j) => ConnectionWithUserSchema.fromJson(j as Map<String, dynamic>)!,
        )
        .toList();
  }

  /// One request to get aggregated counts + avatar previews for all entities
  /// of [toType] ('initiative' or 'directory_of_good').
  Future<Map<String, ConnectionSummarySchema>> getSummaries(String toType) async {
    final response = await _dio.get('/connections/summary/$toType');
    final list = (response.data as List)
        .map((j) => ConnectionSummarySchema.fromJson(j as Map<String, dynamic>)!)
        .toList();
    return {for (final s in list) s.toId: s};
  }
}
