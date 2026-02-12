//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class LinksApi {
  LinksApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create Link
  ///
  /// Create a link between a project and an initiative.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [LinkCreateSchema] linkCreateSchema (required):
  Future<Response> createLinkLinksPostWithHttpInfo(LinkCreateSchema linkCreateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/links/';

    // ignore: prefer_final_locals
    Object? postBody = linkCreateSchema;

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

  /// Create Link
  ///
  /// Create a link between a project and an initiative.
  ///
  /// Parameters:
  ///
  /// * [LinkCreateSchema] linkCreateSchema (required):
  Future<LinkSchema?> createLinkLinksPost(LinkCreateSchema linkCreateSchema,) async {
    final response = await createLinkLinksPostWithHttpInfo(linkCreateSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LinkSchema',) as LinkSchema;
    
    }
    return null;
  }

  /// Delete Link
  ///
  /// Delete a link.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] linkId (required):
  Future<Response> deleteLinkLinksLinkIdDeleteWithHttpInfo(String linkId,) async {
    // ignore: prefer_const_declarations
    final path = r'/links/{link_id}'
      .replaceAll('{link_id}', linkId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

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

  /// Delete Link
  ///
  /// Delete a link.
  ///
  /// Parameters:
  ///
  /// * [String] linkId (required):
  Future<LinkSchema?> deleteLinkLinksLinkIdDelete(String linkId,) async {
    final response = await deleteLinkLinksLinkIdDeleteWithHttpInfo(linkId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LinkSchema',) as LinkSchema;
    
    }
    return null;
  }

  /// Get Link
  ///
  /// Get a specific link by ID.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] linkId (required):
  Future<Response> getLinkLinksLinkIdGetWithHttpInfo(String linkId,) async {
    // ignore: prefer_const_declarations
    final path = r'/links/{link_id}'
      .replaceAll('{link_id}', linkId);

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

  /// Get Link
  ///
  /// Get a specific link by ID.
  ///
  /// Parameters:
  ///
  /// * [String] linkId (required):
  Future<LinkSchema?> getLinkLinksLinkIdGet(String linkId,) async {
    final response = await getLinkLinksLinkIdGetWithHttpInfo(linkId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LinkSchema',) as LinkSchema;
    
    }
    return null;
  }

  /// Get Links By Initiative
  ///
  /// Get all links for a specific initiative.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] initiativeId (required):
  Future<Response> getLinksByInitiativeLinksInitiativeInitiativeIdGetWithHttpInfo(String initiativeId,) async {
    // ignore: prefer_const_declarations
    final path = r'/links/initiative/{initiative_id}'
      .replaceAll('{initiative_id}', initiativeId);

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

  /// Get Links By Initiative
  ///
  /// Get all links for a specific initiative.
  ///
  /// Parameters:
  ///
  /// * [String] initiativeId (required):
  Future<List<LinkSchema>?> getLinksByInitiativeLinksInitiativeInitiativeIdGet(String initiativeId,) async {
    final response = await getLinksByInitiativeLinksInitiativeInitiativeIdGetWithHttpInfo(initiativeId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<LinkSchema>') as List)
        .cast<LinkSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get Links By Project
  ///
  /// Get all links for a specific project.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] projectId (required):
  Future<Response> getLinksByProjectLinksProjectProjectIdGetWithHttpInfo(String projectId,) async {
    // ignore: prefer_const_declarations
    final path = r'/links/project/{project_id}'
      .replaceAll('{project_id}', projectId);

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

  /// Get Links By Project
  ///
  /// Get all links for a specific project.
  ///
  /// Parameters:
  ///
  /// * [String] projectId (required):
  Future<List<LinkSchema>?> getLinksByProjectLinksProjectProjectIdGet(String projectId,) async {
    final response = await getLinksByProjectLinksProjectProjectIdGetWithHttpInfo(projectId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<LinkSchema>') as List)
        .cast<LinkSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// List Links
  ///
  /// Get all links.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listLinksLinksGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/links/';

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

  /// List Links
  ///
  /// Get all links.
  Future<List<LinkSchema>?> listLinksLinksGet() async {
    final response = await listLinksLinksGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<LinkSchema>') as List)
        .cast<LinkSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// Update Link
  ///
  /// Update a link (change project or initiative).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] linkId (required):
  ///
  /// * [LinkUpdateSchema] linkUpdateSchema (required):
  Future<Response> updateLinkLinksLinkIdPatchWithHttpInfo(String linkId, LinkUpdateSchema linkUpdateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/links/{link_id}'
      .replaceAll('{link_id}', linkId);

    // ignore: prefer_final_locals
    Object? postBody = linkUpdateSchema;

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

  /// Update Link
  ///
  /// Update a link (change project or initiative).
  ///
  /// Parameters:
  ///
  /// * [String] linkId (required):
  ///
  /// * [LinkUpdateSchema] linkUpdateSchema (required):
  Future<LinkSchema?> updateLinkLinksLinkIdPatch(String linkId, LinkUpdateSchema linkUpdateSchema,) async {
    final response = await updateLinkLinksLinkIdPatchWithHttpInfo(linkId, linkUpdateSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LinkSchema',) as LinkSchema;
    
    }
    return null;
  }
}
