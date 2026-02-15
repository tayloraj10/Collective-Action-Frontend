//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class SchemasApi {
  SchemasApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// CleanupEventData schema
  ///
  /// Schema for event_data when action_type is 'cleanup'. Exposed for OpenAPI/codegen.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getCleanupEventDataSchemaSchemasEventDataCleanupGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/schemas/event-data/cleanup';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// CleanupEventData schema
  ///
  /// Schema for event_data when action_type is 'cleanup'. Exposed for OpenAPI/codegen.
  Future<CleanupEventData?> getCleanupEventDataSchemaSchemasEventDataCleanupGet() async {
    final response = await getCleanupEventDataSchemaSchemasEventDataCleanupGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CleanupEventData',) as CleanupEventData;
    
    }
    return null;
  }

  /// CleanupRouteEventData schema
  ///
  /// Schema for event_data when action_type is 'cleanup_route'. Exposed for OpenAPI/codegen.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getCleanupRouteEventDataSchemaSchemasEventDataCleanupRouteGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/schemas/event-data/cleanup_route';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// CleanupRouteEventData schema
  ///
  /// Schema for event_data when action_type is 'cleanup_route'. Exposed for OpenAPI/codegen.
  Future<CleanupRouteEventData?> getCleanupRouteEventDataSchemaSchemasEventDataCleanupRouteGet() async {
    final response = await getCleanupRouteEventDataSchemaSchemasEventDataCleanupRouteGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CleanupRouteEventData',) as CleanupRouteEventData;
    
    }
    return null;
  }

  /// EventDataBase schema
  ///
  /// Shared base fields for all event_data types. Exposed for OpenAPI/codegen.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getEventDataBaseSchemaSchemasEventDataBaseGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/schemas/event-data/base';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// EventDataBase schema
  ///
  /// Shared base fields for all event_data types. Exposed for OpenAPI/codegen.
  Future<EventDataBase?> getEventDataBaseSchemaSchemasEventDataBaseGet() async {
    final response = await getEventDataBaseSchemaSchemasEventDataBaseGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EventDataBase',) as EventDataBase;
    
    }
    return null;
  }

  /// TrashReportEventData schema
  ///
  /// Schema for event_data when action_type is 'trash_report'. Exposed for OpenAPI/codegen.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getTrashReportEventDataSchemaSchemasEventDataTrashReportGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/schemas/event-data/trash_report';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// TrashReportEventData schema
  ///
  /// Schema for event_data when action_type is 'trash_report'. Exposed for OpenAPI/codegen.
  Future<TrashReportEventData?> getTrashReportEventDataSchemaSchemasEventDataTrashReportGet() async {
    final response = await getTrashReportEventDataSchemaSchemasEventDataTrashReportGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TrashReportEventData',) as TrashReportEventData;
    
    }
    return null;
  }

  /// ZipCodeSubmissionEventData schema
  ///
  /// Schema for event_data when action_type is 'zip_code_submission'. Exposed for OpenAPI/codegen.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getZipCodeSubmissionEventDataSchemaSchemasEventDataZipCodeSubmissionGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/schemas/event-data/zip_code_submission';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// ZipCodeSubmissionEventData schema
  ///
  /// Schema for event_data when action_type is 'zip_code_submission'. Exposed for OpenAPI/codegen.
  Future<ZipCodeSubmissionEventData?> getZipCodeSubmissionEventDataSchemaSchemasEventDataZipCodeSubmissionGet() async {
    final response = await getZipCodeSubmissionEventDataSchemaSchemasEventDataZipCodeSubmissionGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ZipCodeSubmissionEventData',) as ZipCodeSubmissionEventData;
    
    }
    return null;
  }
}
