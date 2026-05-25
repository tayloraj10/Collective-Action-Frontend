//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class MapHotspotsApi {
  MapHotspotsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Assign Area Captain
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AreaCaptainAssignSchema] areaCaptainAssignSchema (required):
  Future<Response> assignAreaCaptainMapHotspotsAreaCaptainsAssignPostWithHttpInfo(AreaCaptainAssignSchema areaCaptainAssignSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/map-hotspots/area-captains/assign';

    // ignore: prefer_final_locals
    Object? postBody = areaCaptainAssignSchema;

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

  /// Assign Area Captain
  ///
  /// Parameters:
  ///
  /// * [AreaCaptainAssignSchema] areaCaptainAssignSchema (required):
  Future<AreaCaptainSchema?> assignAreaCaptainMapHotspotsAreaCaptainsAssignPost(AreaCaptainAssignSchema areaCaptainAssignSchema,) async {
    final response = await assignAreaCaptainMapHotspotsAreaCaptainsAssignPostWithHttpInfo(areaCaptainAssignSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AreaCaptainSchema',) as AreaCaptainSchema;
    
    }
    return null;
  }

  /// Create Area
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [MapAreaCreateSchema] mapAreaCreateSchema (required):
  Future<Response> createAreaMapHotspotsAreasPostWithHttpInfo(MapAreaCreateSchema mapAreaCreateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/map-hotspots/areas';

    // ignore: prefer_final_locals
    Object? postBody = mapAreaCreateSchema;

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

  /// Create Area
  ///
  /// Parameters:
  ///
  /// * [MapAreaCreateSchema] mapAreaCreateSchema (required):
  Future<MapAreaSchema?> createAreaMapHotspotsAreasPost(MapAreaCreateSchema mapAreaCreateSchema,) async {
    final response = await createAreaMapHotspotsAreasPostWithHttpInfo(mapAreaCreateSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MapAreaSchema',) as MapAreaSchema;
    
    }
    return null;
  }

  /// Create Hotspot
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [MapHotspotCreateSchema] mapHotspotCreateSchema (required):
  Future<Response> createHotspotMapHotspotsPostWithHttpInfo(MapHotspotCreateSchema mapHotspotCreateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/map-hotspots/';

    // ignore: prefer_final_locals
    Object? postBody = mapHotspotCreateSchema;

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

  /// Create Hotspot
  ///
  /// Parameters:
  ///
  /// * [MapHotspotCreateSchema] mapHotspotCreateSchema (required):
  Future<MapHotspotSchema?> createHotspotMapHotspotsPost(MapHotspotCreateSchema mapHotspotCreateSchema,) async {
    final response = await createHotspotMapHotspotsPostWithHttpInfo(mapHotspotCreateSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MapHotspotSchema',) as MapHotspotSchema;
    
    }
    return null;
  }

  /// Delete Hotspot
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] hotspotId (required):
  ///
  /// * [String] actingUserId (required):
  Future<Response> deleteHotspotMapHotspotsHotspotIdDeleteWithHttpInfo(String hotspotId, String actingUserId,) async {
    // ignore: prefer_const_declarations
    final path = r'/map-hotspots/{hotspot_id}'
      .replaceAll('{hotspot_id}', hotspotId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'acting_user_id', actingUserId));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete Hotspot
  ///
  /// Parameters:
  ///
  /// * [String] hotspotId (required):
  ///
  /// * [String] actingUserId (required):
  Future<void> deleteHotspotMapHotspotsHotspotIdDelete(String hotspotId, String actingUserId,) async {
    final response = await deleteHotspotMapHotspotsHotspotIdDeleteWithHttpInfo(hotspotId, actingUserId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// List Area Captains
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] campaignId (required):
  Future<Response> listAreaCaptainsMapHotspotsCampaignCampaignIdAreaCaptainsGetWithHttpInfo(String campaignId,) async {
    // ignore: prefer_const_declarations
    final path = r'/map-hotspots/campaign/{campaign_id}/area-captains'
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

  /// List Area Captains
  ///
  /// Parameters:
  ///
  /// * [String] campaignId (required):
  Future<List<AreaCaptainSchema>?> listAreaCaptainsMapHotspotsCampaignCampaignIdAreaCaptainsGet(String campaignId,) async {
    final response = await listAreaCaptainsMapHotspotsCampaignCampaignIdAreaCaptainsGetWithHttpInfo(campaignId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AreaCaptainSchema>') as List)
        .cast<AreaCaptainSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// List Areas
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] campaignId (required):
  Future<Response> listAreasMapHotspotsCampaignCampaignIdAreasGetWithHttpInfo(String campaignId,) async {
    // ignore: prefer_const_declarations
    final path = r'/map-hotspots/campaign/{campaign_id}/areas'
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

  /// List Areas
  ///
  /// Parameters:
  ///
  /// * [String] campaignId (required):
  Future<List<MapAreaSchema>?> listAreasMapHotspotsCampaignCampaignIdAreasGet(String campaignId,) async {
    final response = await listAreasMapHotspotsCampaignCampaignIdAreasGetWithHttpInfo(campaignId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<MapAreaSchema>') as List)
        .cast<MapAreaSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// List Hotspots
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] campaignId (required):
  ///
  /// * [bool] includeInactive:
  Future<Response> listHotspotsMapHotspotsCampaignCampaignIdGetWithHttpInfo(String campaignId, { bool? includeInactive, }) async {
    // ignore: prefer_const_declarations
    final path = r'/map-hotspots/campaign/{campaign_id}'
      .replaceAll('{campaign_id}', campaignId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (includeInactive != null) {
      queryParams.addAll(_queryParams('', 'include_inactive', includeInactive));
    }

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

  /// List Hotspots
  ///
  /// Parameters:
  ///
  /// * [String] campaignId (required):
  ///
  /// * [bool] includeInactive:
  Future<List<MapHotspotSchema>?> listHotspotsMapHotspotsCampaignCampaignIdGet(String campaignId, { bool? includeInactive, }) async {
    final response = await listHotspotsMapHotspotsCampaignCampaignIdGetWithHttpInfo(campaignId,  includeInactive: includeInactive, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<MapHotspotSchema>') as List)
        .cast<MapHotspotSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// Remove Area Captain
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] assignmentId (required):
  ///
  /// * [String] actingUserId (required):
  Future<Response> removeAreaCaptainMapHotspotsAreaCaptainsAssignmentIdDeleteWithHttpInfo(String assignmentId, String actingUserId,) async {
    // ignore: prefer_const_declarations
    final path = r'/map-hotspots/area-captains/{assignment_id}'
      .replaceAll('{assignment_id}', assignmentId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'acting_user_id', actingUserId));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Remove Area Captain
  ///
  /// Parameters:
  ///
  /// * [String] assignmentId (required):
  ///
  /// * [String] actingUserId (required):
  Future<void> removeAreaCaptainMapHotspotsAreaCaptainsAssignmentIdDelete(String assignmentId, String actingUserId,) async {
    final response = await removeAreaCaptainMapHotspotsAreaCaptainsAssignmentIdDeleteWithHttpInfo(assignmentId, actingUserId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Update Hotspot
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] hotspotId (required):
  ///
  /// * [MapHotspotUpdateSchema] mapHotspotUpdateSchema (required):
  Future<Response> updateHotspotMapHotspotsHotspotIdPatchWithHttpInfo(String hotspotId, MapHotspotUpdateSchema mapHotspotUpdateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/map-hotspots/{hotspot_id}'
      .replaceAll('{hotspot_id}', hotspotId);

    // ignore: prefer_final_locals
    Object? postBody = mapHotspotUpdateSchema;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update Hotspot
  ///
  /// Parameters:
  ///
  /// * [String] hotspotId (required):
  ///
  /// * [MapHotspotUpdateSchema] mapHotspotUpdateSchema (required):
  Future<MapHotspotSchema?> updateHotspotMapHotspotsHotspotIdPatch(String hotspotId, MapHotspotUpdateSchema mapHotspotUpdateSchema,) async {
    final response = await updateHotspotMapHotspotsHotspotIdPatchWithHttpInfo(hotspotId, mapHotspotUpdateSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MapHotspotSchema',) as MapHotspotSchema;
    
    }
    return null;
  }
}
