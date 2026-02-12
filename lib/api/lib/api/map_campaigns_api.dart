//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class MapCampaignsApi {
  MapCampaignsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create Map Campaign
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [MapCampaignCreateSchema] mapCampaignCreateSchema (required):
  Future<Response> createMapCampaignMapCampaignsPostWithHttpInfo(MapCampaignCreateSchema mapCampaignCreateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/map-campaigns/';

    // ignore: prefer_final_locals
    Object? postBody = mapCampaignCreateSchema;

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

  /// Create Map Campaign
  ///
  /// Parameters:
  ///
  /// * [MapCampaignCreateSchema] mapCampaignCreateSchema (required):
  Future<MapCampaignSchema?> createMapCampaignMapCampaignsPost(MapCampaignCreateSchema mapCampaignCreateSchema,) async {
    final response = await createMapCampaignMapCampaignsPostWithHttpInfo(mapCampaignCreateSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MapCampaignSchema',) as MapCampaignSchema;
    
    }
    return null;
  }

  /// Get Map Campaign
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] campaignId (required):
  Future<Response> getMapCampaignMapCampaignsCampaignIdGetWithHttpInfo(String campaignId,) async {
    // ignore: prefer_const_declarations
    final path = r'/map-campaigns/{campaign_id}'
      .replaceAll('{campaign_id}', campaignId);

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

  /// Get Map Campaign
  ///
  /// Parameters:
  ///
  /// * [String] campaignId (required):
  Future<MapCampaignSchema?> getMapCampaignMapCampaignsCampaignIdGet(String campaignId,) async {
    final response = await getMapCampaignMapCampaignsCampaignIdGetWithHttpInfo(campaignId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MapCampaignSchema',) as MapCampaignSchema;
    
    }
    return null;
  }

  /// List Active Map Campaigns
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listActiveMapCampaignsMapCampaignsActiveGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/map-campaigns/active';

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

  /// List Active Map Campaigns
  Future<List<MapCampaignSchema>?> listActiveMapCampaignsMapCampaignsActiveGet() async {
    final response = await listActiveMapCampaignsMapCampaignsActiveGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<MapCampaignSchema>') as List)
        .cast<MapCampaignSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// List Map Campaigns By Creator
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  Future<Response> listMapCampaignsByCreatorMapCampaignsCreatorUserIdGetWithHttpInfo(String userId,) async {
    // ignore: prefer_const_declarations
    final path = r'/map-campaigns/creator/{user_id}'
      .replaceAll('{user_id}', userId);

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

  /// List Map Campaigns By Creator
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  Future<List<MapCampaignSchema>?> listMapCampaignsByCreatorMapCampaignsCreatorUserIdGet(String userId,) async {
    final response = await listMapCampaignsByCreatorMapCampaignsCreatorUserIdGetWithHttpInfo(userId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<MapCampaignSchema>') as List)
        .cast<MapCampaignSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// List Map Campaigns By Type
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [MapCampaignTypeEnum] campaignType (required):
  Future<Response> listMapCampaignsByTypeMapCampaignsByTypeCampaignTypeGetWithHttpInfo(MapCampaignTypeEnum campaignType,) async {
    // ignore: prefer_const_declarations
    final path = r'/map-campaigns/by-type/{campaign_type}'
      .replaceAll('{campaign_type}', campaignType.toString());

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

  /// List Map Campaigns By Type
  ///
  /// Parameters:
  ///
  /// * [MapCampaignTypeEnum] campaignType (required):
  Future<List<MapCampaignSchema>?> listMapCampaignsByTypeMapCampaignsByTypeCampaignTypeGet(MapCampaignTypeEnum campaignType,) async {
    final response = await listMapCampaignsByTypeMapCampaignsByTypeCampaignTypeGetWithHttpInfo(campaignType,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<MapCampaignSchema>') as List)
        .cast<MapCampaignSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// List Map Campaigns
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listMapCampaignsMapCampaignsGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/map-campaigns/';

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

  /// List Map Campaigns
  Future<List<MapCampaignSchema>?> listMapCampaignsMapCampaignsGet() async {
    final response = await listMapCampaignsMapCampaignsGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<MapCampaignSchema>') as List)
        .cast<MapCampaignSchema>()
        .toList(growable: false);

    }
    return null;
  }
}
