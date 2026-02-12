//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class ProjectRolesApi {
  ProjectRolesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create Project Role
  ///
  /// Create a new project role.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ProjectRoleCreateSchema] projectRoleCreateSchema (required):
  Future<Response> createProjectRoleProjectRolesPostWithHttpInfo(ProjectRoleCreateSchema projectRoleCreateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/project-roles/';

    // ignore: prefer_final_locals
    Object? postBody = projectRoleCreateSchema;

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

  /// Create Project Role
  ///
  /// Create a new project role.
  ///
  /// Parameters:
  ///
  /// * [ProjectRoleCreateSchema] projectRoleCreateSchema (required):
  Future<ProjectRoleSchema?> createProjectRoleProjectRolesPost(ProjectRoleCreateSchema projectRoleCreateSchema,) async {
    final response = await createProjectRoleProjectRolesPostWithHttpInfo(projectRoleCreateSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ProjectRoleSchema',) as ProjectRoleSchema;
    
    }
    return null;
  }

  /// Delete Project Role
  ///
  /// Delete a project role.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] roleId (required):
  Future<Response> deleteProjectRoleProjectRolesRoleIdDeleteWithHttpInfo(String roleId,) async {
    // ignore: prefer_const_declarations
    final path = r'/project-roles/{role_id}'
      .replaceAll('{role_id}', roleId);

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

  /// Delete Project Role
  ///
  /// Delete a project role.
  ///
  /// Parameters:
  ///
  /// * [String] roleId (required):
  Future<ProjectRoleSchema?> deleteProjectRoleProjectRolesRoleIdDelete(String roleId,) async {
    final response = await deleteProjectRoleProjectRolesRoleIdDeleteWithHttpInfo(roleId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ProjectRoleSchema',) as ProjectRoleSchema;
    
    }
    return null;
  }

  /// Get Project Role
  ///
  /// Get a specific project role.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] roleId (required):
  Future<Response> getProjectRoleProjectRolesRoleIdGetWithHttpInfo(String roleId,) async {
    // ignore: prefer_const_declarations
    final path = r'/project-roles/{role_id}'
      .replaceAll('{role_id}', roleId);

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

  /// Get Project Role
  ///
  /// Get a specific project role.
  ///
  /// Parameters:
  ///
  /// * [String] roleId (required):
  Future<ProjectRoleSchema?> getProjectRoleProjectRolesRoleIdGet(String roleId,) async {
    final response = await getProjectRoleProjectRolesRoleIdGetWithHttpInfo(roleId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ProjectRoleSchema',) as ProjectRoleSchema;
    
    }
    return null;
  }

  /// List Project Roles
  ///
  /// List all project roles.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listProjectRolesProjectRolesGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/project-roles/';

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

  /// List Project Roles
  ///
  /// List all project roles.
  Future<List<ProjectRoleSchema>?> listProjectRolesProjectRolesGet() async {
    final response = await listProjectRolesProjectRolesGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ProjectRoleSchema>') as List)
        .cast<ProjectRoleSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// Update Project Role
  ///
  /// Update a project role.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] roleId (required):
  ///
  /// * [ProjectRoleUpdateSchema] projectRoleUpdateSchema (required):
  Future<Response> updateProjectRoleProjectRolesRoleIdPatchWithHttpInfo(String roleId, ProjectRoleUpdateSchema projectRoleUpdateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/project-roles/{role_id}'
      .replaceAll('{role_id}', roleId);

    // ignore: prefer_final_locals
    Object? postBody = projectRoleUpdateSchema;

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

  /// Update Project Role
  ///
  /// Update a project role.
  ///
  /// Parameters:
  ///
  /// * [String] roleId (required):
  ///
  /// * [ProjectRoleUpdateSchema] projectRoleUpdateSchema (required):
  Future<ProjectRoleSchema?> updateProjectRoleProjectRolesRoleIdPatch(String roleId, ProjectRoleUpdateSchema projectRoleUpdateSchema,) async {
    final response = await updateProjectRoleProjectRolesRoleIdPatchWithHttpInfo(roleId, projectRoleUpdateSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ProjectRoleSchema',) as ProjectRoleSchema;
    
    }
    return null;
  }
}
