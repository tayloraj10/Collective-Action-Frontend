//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

import 'package:collective_action_api/api.dart';
import 'package:test/test.dart';


/// tests for PhotosApi
void main() {
  // final instance = PhotosApi();

  group('tests for PhotosApi', () {
    // Delete All Submission Photos
    //
    // Delete all photos for a submission.  Args:     submission_id: The ID of the submission
    //
    //Future deleteAllSubmissionPhotosPhotosSubmissionSubmissionIdDelete(String submissionId) async
    test('test deleteAllSubmissionPhotosPhotosSubmissionSubmissionIdDelete', () async {
      // TODO
    });

    // Delete Profile Photo
    //
    // Delete all profile photos for a user (any file extension).  Args:     user_id: The ID of the user
    //
    //Future deleteProfilePhotoPhotosProfileUserIdDelete(String userId) async
    test('test deleteProfilePhotoPhotosProfileUserIdDelete', () async {
      // TODO
    });

    // Delete Submission Photo
    //
    // Delete a specific photo from a submission.  Args:     submission_id: The ID of the submission     photo_filename: The filename of the photo (e.g., \"uuid.jpg\")
    //
    //Future deleteSubmissionPhotoPhotosSubmissionSubmissionIdPhotoFilenameDelete(String submissionId, String photoFilename) async
    test('test deleteSubmissionPhotoPhotosSubmissionSubmissionIdPhotoFilenameDelete', () async {
      // TODO
    });

    // List Submission Photos
    //
    // List all photos for a submission.  Args:     submission_id: The ID of the submission  Returns:     list[str]: List of photo URLs
    //
    //Future<List<String>> listSubmissionPhotosPhotosSubmissionSubmissionIdGet(String submissionId) async
    test('test listSubmissionPhotosPhotosSubmissionSubmissionIdGet', () async {
      // TODO
    });

    // Upload Profile Photo
    //
    // Upload a user profile photo to cloud storage.  This endpoint uploads a profile photo for a specific user. The photo is stored with the user's ID as the filename, so uploading a new photo will replace the old one.  Path Structure: - collective-action-user-images/profiles/{user_id}.{ext}  Args:     user_id: The ID of the user (e.g., \"user_123\")     file: The image file to upload  Returns:     str: The public URL of the uploaded photo  Raises:     HTTPException: If upload fails or validation fails
    //
    //Future<String> uploadProfilePhotoPhotosProfileUserIdPost(String userId, MultipartFile file) async
    test('test uploadProfilePhotoPhotosProfileUserIdPost', () async {
      // TODO
    });

    // Upload Submission Photo
    //
    // Upload a submission photo to cloud storage.  This endpoint uploads a photo for a specific submission. Multiple photos can be uploaded for the same submission - each will get a unique filename.  Path Structure: - collective-action-submissions/submissions/{submission_id}/{uuid}.{ext}  Args:     submission_id: The ID of the submission (e.g., \"submission_123\")     file: The image file to upload  Returns:     str: The public URL of the uploaded photo  Raises:     HTTPException: If upload fails or validation fails
    //
    //Future<String> uploadSubmissionPhotoPhotosSubmissionSubmissionIdPost(String submissionId, MultipartFile file) async
    test('test uploadSubmissionPhotoPhotosSubmissionSubmissionIdPost', () async {
      // TODO
    });

  });
}
