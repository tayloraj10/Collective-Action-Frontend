//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class ProjectsApi {
  ProjectsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create Project
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ProjectCreateSchema] projectCreateSchema (required):
  Future<Response> createProjectProjectsPostWithHttpInfo(ProjectCreateSchema projectCreateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/projects/';

    // ignore: prefer_final_locals
    Object? postBody = projectCreateSchema;

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

  /// Create Project
  ///
  /// Parameters:
  ///
  /// * [ProjectCreateSchema] projectCreateSchema (required):
  Future<ProjectSchema?> createProjectProjectsPost(ProjectCreateSchema projectCreateSchema,) async {
    final response = await createProjectProjectsPostWithHttpInfo(projectCreateSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ProjectSchema',) as ProjectSchema;
    
    }
    return null;
  }

  /// Delete Project
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] projectId (required):
  Future<Response> deleteProjectProjectsProjectIdDeleteWithHttpInfo(String projectId,) async {
    // ignore: prefer_const_declarations
    final path = r'/projects/{project_id}'
      .replaceAll('{project_id}', projectId);

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

  /// Delete Project
  ///
  /// Parameters:
  ///
  /// * [String] projectId (required):
  Future<ProjectSchema?> deleteProjectProjectsProjectIdDelete(String projectId,) async {
    final response = await deleteProjectProjectsProjectIdDeleteWithHttpInfo(projectId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ProjectSchema',) as ProjectSchema;
    
    }
    return null;
  }

  /// Get Project
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] projectId (required):
  Future<Response> getProjectProjectsProjectIdGetWithHttpInfo(String projectId,) async {
    // ignore: prefer_const_declarations
    final path = r'/projects/{project_id}'
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

  /// Get Project
  ///
  /// Parameters:
  ///
  /// * [String] projectId (required):
  Future<ProjectSchema?> getProjectProjectsProjectIdGet(String projectId,) async {
    final response = await getProjectProjectsProjectIdGetWithHttpInfo(projectId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ProjectSchema',) as ProjectSchema;
    
    }
    return null;
  }

  /// List Active Projects
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listActiveProjectsProjectsActiveGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/projects/active';

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

  /// List Active Projects
  Future<List<ProjectSchema>?> listActiveProjectsProjectsActiveGet() async {
    final response = await listActiveProjectsProjectsActiveGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ProjectSchema>') as List)
        .cast<ProjectSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// List Projects
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listProjectsProjectsGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/projects/';

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

  /// List Projects
  Future<List<ProjectSchema>?> listProjectsProjectsGet() async {
    final response = await listProjectsProjectsGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ProjectSchema>') as List)
        .cast<ProjectSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// Update Project
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] projectId (required):
  ///
  /// * [ProjectUpdateSchema] projectUpdateSchema (required):
  Future<Response> updateProjectProjectsProjectIdPatchWithHttpInfo(String projectId, ProjectUpdateSchema projectUpdateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/projects/{project_id}'
      .replaceAll('{project_id}', projectId);

    // ignore: prefer_final_locals
    Object? postBody = projectUpdateSchema;

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

  /// Update Project
  ///
  /// Parameters:
  ///
  /// * [String] projectId (required):
  ///
  /// * [ProjectUpdateSchema] projectUpdateSchema (required):
  Future<ProjectSchema?> updateProjectProjectsProjectIdPatch(String projectId, ProjectUpdateSchema projectUpdateSchema,) async {
    final response = await updateProjectProjectsProjectIdPatchWithHttpInfo(projectId, projectUpdateSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ProjectSchema',) as ProjectSchema;
    
    }
    return null;
  }
}
