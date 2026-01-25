//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class InitiativesApi {
  InitiativesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create Initiative
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [InitiativeCreateSchema] initiativeCreateSchema (required):
  Future<Response> createInitiativeInitiativesPostWithHttpInfo(InitiativeCreateSchema initiativeCreateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/initiatives/';

    // ignore: prefer_final_locals
    Object? postBody = initiativeCreateSchema;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create Initiative
  ///
  /// Parameters:
  ///
  /// * [InitiativeCreateSchema] initiativeCreateSchema (required):
  Future<InitiativeSchema?> createInitiativeInitiativesPost(InitiativeCreateSchema initiativeCreateSchema,) async {
    final response = await createInitiativeInitiativesPostWithHttpInfo(initiativeCreateSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'InitiativeSchema',) as InitiativeSchema;
    
    }
    return null;
  }

  /// Get Featured Initiatives
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getFeaturedInitiativesInitiativesFeaturedGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/initiatives/featured';

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

  /// Get Featured Initiatives
  Future<List<InitiativeSchema>?> getFeaturedInitiativesInitiativesFeaturedGet() async {
    final response = await getFeaturedInitiativesInitiativesFeaturedGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<InitiativeSchema>') as List)
        .cast<InitiativeSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get Initiatives By Ids
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [List<String>] initiativeIds (required):
  ///   List of initiative IDs
  Future<Response> getInitiativesByIdsInitiativesByIdsGetWithHttpInfo(List<String> initiativeIds,) async {
    // ignore: prefer_const_declarations
    final path = r'/initiatives/by-ids';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('multi', 'initiative_ids', initiativeIds));

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

  /// Get Initiatives By Ids
  ///
  /// Parameters:
  ///
  /// * [List<String>] initiativeIds (required):
  ///   List of initiative IDs
  Future<List<InitiativeSchema>?> getInitiativesByIdsInitiativesByIdsGet(List<String> initiativeIds,) async {
    final response = await getInitiativesByIdsInitiativesByIdsGetWithHttpInfo(initiativeIds,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<InitiativeSchema>') as List)
        .cast<InitiativeSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// List Active Initiatives
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listActiveInitiativesInitiativesActiveGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/initiatives/active';

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

  /// List Active Initiatives
  Future<List<InitiativeSchema>?> listActiveInitiativesInitiativesActiveGet() async {
    final response = await listActiveInitiativesInitiativesActiveGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<InitiativeSchema>') as List)
        .cast<InitiativeSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// List Initiatives
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listInitiativesInitiativesGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/initiatives/';

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

  /// List Initiatives
  Future<List<InitiativeSchema>?> listInitiativesInitiativesGet() async {
    final response = await listInitiativesInitiativesGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<InitiativeSchema>') as List)
        .cast<InitiativeSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// List Initiatives Summary
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listInitiativesSummaryInitiativesSummaryGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/initiatives/summary';

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

  /// List Initiatives Summary
  Future<List<InitiativeSchema>?> listInitiativesSummaryInitiativesSummaryGet() async {
    final response = await listInitiativesSummaryInitiativesSummaryGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<InitiativeSchema>') as List)
        .cast<InitiativeSchema>()
        .toList(growable: false);

    }
    return null;
  }
}
