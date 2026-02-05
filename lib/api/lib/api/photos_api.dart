//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class PhotosApi {
  PhotosApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Delete All Submission Photos
  ///
  /// Delete all photos for a submission.  Args:     submission_id: The ID of the submission
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] submissionId (required):
  Future<Response> deleteAllSubmissionPhotosPhotosSubmissionSubmissionIdDeleteWithHttpInfo(String submissionId,) async {
    // ignore: prefer_const_declarations
    final path = r'/photos/submission/{submission_id}'
      .replaceAll('{submission_id}', submissionId);

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

  /// Delete All Submission Photos
  ///
  /// Delete all photos for a submission.  Args:     submission_id: The ID of the submission
  ///
  /// Parameters:
  ///
  /// * [String] submissionId (required):
  Future<void> deleteAllSubmissionPhotosPhotosSubmissionSubmissionIdDelete(String submissionId,) async {
    final response = await deleteAllSubmissionPhotosPhotosSubmissionSubmissionIdDeleteWithHttpInfo(submissionId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Delete Profile Photo
  ///
  /// Delete all profile photos for a user (any file extension).  Args:     user_id: The ID of the user
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  Future<Response> deleteProfilePhotoPhotosProfileUserIdDeleteWithHttpInfo(String userId,) async {
    // ignore: prefer_const_declarations
    final path = r'/photos/profile/{user_id}'
      .replaceAll('{user_id}', userId);

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

  /// Delete Profile Photo
  ///
  /// Delete all profile photos for a user (any file extension).  Args:     user_id: The ID of the user
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  Future<void> deleteProfilePhotoPhotosProfileUserIdDelete(String userId,) async {
    final response = await deleteProfilePhotoPhotosProfileUserIdDeleteWithHttpInfo(userId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Delete Submission Photo
  ///
  /// Delete a specific photo from a submission.  Args:     submission_id: The ID of the submission     photo_filename: The filename of the photo (e.g., \"uuid.jpg\")
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] submissionId (required):
  ///
  /// * [String] photoFilename (required):
  Future<Response> deleteSubmissionPhotoPhotosSubmissionSubmissionIdPhotoFilenameDeleteWithHttpInfo(String submissionId, String photoFilename,) async {
    // ignore: prefer_const_declarations
    final path = r'/photos/submission/{submission_id}/{photo_filename}'
      .replaceAll('{submission_id}', submissionId)
      .replaceAll('{photo_filename}', photoFilename);

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

  /// Delete Submission Photo
  ///
  /// Delete a specific photo from a submission.  Args:     submission_id: The ID of the submission     photo_filename: The filename of the photo (e.g., \"uuid.jpg\")
  ///
  /// Parameters:
  ///
  /// * [String] submissionId (required):
  ///
  /// * [String] photoFilename (required):
  Future<void> deleteSubmissionPhotoPhotosSubmissionSubmissionIdPhotoFilenameDelete(String submissionId, String photoFilename,) async {
    final response = await deleteSubmissionPhotoPhotosSubmissionSubmissionIdPhotoFilenameDeleteWithHttpInfo(submissionId, photoFilename,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// List Submission Photos
  ///
  /// List all photos for a submission.  Args:     submission_id: The ID of the submission  Returns:     list[str]: List of photo URLs
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] submissionId (required):
  Future<Response> listSubmissionPhotosPhotosSubmissionSubmissionIdGetWithHttpInfo(String submissionId,) async {
    // ignore: prefer_const_declarations
    final path = r'/photos/submission/{submission_id}'
      .replaceAll('{submission_id}', submissionId);

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

  /// List Submission Photos
  ///
  /// List all photos for a submission.  Args:     submission_id: The ID of the submission  Returns:     list[str]: List of photo URLs
  ///
  /// Parameters:
  ///
  /// * [String] submissionId (required):
  Future<List<String>?> listSubmissionPhotosPhotosSubmissionSubmissionIdGet(String submissionId,) async {
    final response = await listSubmissionPhotosPhotosSubmissionSubmissionIdGetWithHttpInfo(submissionId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<String>') as List)
        .cast<String>()
        .toList(growable: false);

    }
    return null;
  }

  /// Upload Profile Photo
  ///
  /// Upload a user profile photo to cloud storage.  This endpoint uploads a profile photo for a specific user. The photo is stored with the user's ID as the filename, so uploading a new photo will replace the old one.  Path Structure: - collective-action-user-images/profiles/{user_id}.{ext}  Args:     user_id: The ID of the user (e.g., \"user_123\")     file: The image file to upload  Returns:     str: The public URL of the uploaded photo  Raises:     HTTPException: If upload fails or validation fails
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [MultipartFile] file (required):
  Future<Response> uploadProfilePhotoPhotosProfileUserIdPostWithHttpInfo(String userId, MultipartFile file,) async {
    // ignore: prefer_const_declarations
    final path = r'/photos/profile/{user_id}'
      .replaceAll('{user_id}', userId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['multipart/form-data'];

    bool hasFields = false;
    final mp = MultipartRequest('POST', Uri.parse(path));
    if (file != null) {
      hasFields = true;
      mp.fields[r'file'] = file.field;
      mp.files.add(file);
    }
    if (hasFields) {
      postBody = mp;
    }

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

  /// Upload Profile Photo
  ///
  /// Upload a user profile photo to cloud storage.  This endpoint uploads a profile photo for a specific user. The photo is stored with the user's ID as the filename, so uploading a new photo will replace the old one.  Path Structure: - collective-action-user-images/profiles/{user_id}.{ext}  Args:     user_id: The ID of the user (e.g., \"user_123\")     file: The image file to upload  Returns:     str: The public URL of the uploaded photo  Raises:     HTTPException: If upload fails or validation fails
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [MultipartFile] file (required):
  Future<String?> uploadProfilePhotoPhotosProfileUserIdPost(String userId, MultipartFile file,) async {
    final response = await uploadProfilePhotoPhotosProfileUserIdPostWithHttpInfo(userId, file,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// Upload Submission Photos
  ///
  /// Upload one or more submission photos to cloud storage.  This endpoint uploads photos for a specific submission. Each file gets a unique filename under that submission.  Path Structure: - collective-action-submissions/submissions/{submission_id}/{uuid}.{ext}  Args:     submission_id: The ID of the submission (e.g., \"submission_123\")     files: One or more image files to upload  Returns:     list[str]: Public URLs of the uploaded photos (same order as input)  Raises:     HTTPException: If no files provided, validation fails, or upload fails
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] submissionId (required):
  ///
  /// * [List<MultipartFile>] files (required):
  ///   One or more image files
  Future<Response> uploadSubmissionPhotosPhotosSubmissionSubmissionIdPostWithHttpInfo(String submissionId, List<MultipartFile> files,) async {
    // ignore: prefer_const_declarations
    final path = r'/photos/submission/{submission_id}'
      .replaceAll('{submission_id}', submissionId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['multipart/form-data'];

    bool hasFields = false;
    final mp = MultipartRequest('POST', Uri.parse(path));
    if (files != null) {
      hasFields = true;
      mp.fields[r'files'] = files.field;
      mp.files.add(files);
    }
    if (hasFields) {
      postBody = mp;
    }

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

  /// Upload Submission Photos
  ///
  /// Upload one or more submission photos to cloud storage.  This endpoint uploads photos for a specific submission. Each file gets a unique filename under that submission.  Path Structure: - collective-action-submissions/submissions/{submission_id}/{uuid}.{ext}  Args:     submission_id: The ID of the submission (e.g., \"submission_123\")     files: One or more image files to upload  Returns:     list[str]: Public URLs of the uploaded photos (same order as input)  Raises:     HTTPException: If no files provided, validation fails, or upload fails
  ///
  /// Parameters:
  ///
  /// * [String] submissionId (required):
  ///
  /// * [List<MultipartFile>] files (required):
  ///   One or more image files
  Future<List<String>?> uploadSubmissionPhotosPhotosSubmissionSubmissionIdPost(String submissionId, List<MultipartFile> files,) async {
    final response = await uploadSubmissionPhotosPhotosSubmissionSubmissionIdPostWithHttpInfo(submissionId, files,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<String>') as List)
        .cast<String>()
        .toList(growable: false);

    }
    return null;
  }
}
