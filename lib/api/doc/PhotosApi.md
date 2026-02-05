# collective_action_api.api.PhotosApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteAllSubmissionPhotosPhotosSubmissionSubmissionIdDelete**](PhotosApi.md#deleteallsubmissionphotosphotossubmissionsubmissioniddelete) | **DELETE** /photos/submission/{submission_id} | Delete All Submission Photos
[**deleteProfilePhotoPhotosProfileUserIdDelete**](PhotosApi.md#deleteprofilephotophotosprofileuseriddelete) | **DELETE** /photos/profile/{user_id} | Delete Profile Photo
[**deleteSubmissionPhotoPhotosSubmissionSubmissionIdPhotoFilenameDelete**](PhotosApi.md#deletesubmissionphotophotossubmissionsubmissionidphotofilenamedelete) | **DELETE** /photos/submission/{submission_id}/{photo_filename} | Delete Submission Photo
[**listSubmissionPhotosPhotosSubmissionSubmissionIdGet**](PhotosApi.md#listsubmissionphotosphotossubmissionsubmissionidget) | **GET** /photos/submission/{submission_id} | List Submission Photos
[**uploadProfilePhotoPhotosProfileUserIdPost**](PhotosApi.md#uploadprofilephotophotosprofileuseridpost) | **POST** /photos/profile/{user_id} | Upload Profile Photo
[**uploadSubmissionPhotosPhotosSubmissionSubmissionIdPost**](PhotosApi.md#uploadsubmissionphotosphotossubmissionsubmissionidpost) | **POST** /photos/submission/{submission_id} | Upload Submission Photos


# **deleteAllSubmissionPhotosPhotosSubmissionSubmissionIdDelete**
> deleteAllSubmissionPhotosPhotosSubmissionSubmissionIdDelete(submissionId)

Delete All Submission Photos

Delete all photos for a submission.  Args:     submission_id: The ID of the submission

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = PhotosApi();
final submissionId = submissionId_example; // String | 

try {
    api_instance.deleteAllSubmissionPhotosPhotosSubmissionSubmissionIdDelete(submissionId);
} catch (e) {
    print('Exception when calling PhotosApi->deleteAllSubmissionPhotosPhotosSubmissionSubmissionIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submissionId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteProfilePhotoPhotosProfileUserIdDelete**
> deleteProfilePhotoPhotosProfileUserIdDelete(userId)

Delete Profile Photo

Delete all profile photos for a user (any file extension).  Args:     user_id: The ID of the user

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = PhotosApi();
final userId = userId_example; // String | 

try {
    api_instance.deleteProfilePhotoPhotosProfileUserIdDelete(userId);
} catch (e) {
    print('Exception when calling PhotosApi->deleteProfilePhotoPhotosProfileUserIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteSubmissionPhotoPhotosSubmissionSubmissionIdPhotoFilenameDelete**
> deleteSubmissionPhotoPhotosSubmissionSubmissionIdPhotoFilenameDelete(submissionId, photoFilename)

Delete Submission Photo

Delete a specific photo from a submission.  Args:     submission_id: The ID of the submission     photo_filename: The filename of the photo (e.g., \"uuid.jpg\")

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = PhotosApi();
final submissionId = submissionId_example; // String | 
final photoFilename = photoFilename_example; // String | 

try {
    api_instance.deleteSubmissionPhotoPhotosSubmissionSubmissionIdPhotoFilenameDelete(submissionId, photoFilename);
} catch (e) {
    print('Exception when calling PhotosApi->deleteSubmissionPhotoPhotosSubmissionSubmissionIdPhotoFilenameDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submissionId** | **String**|  | 
 **photoFilename** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listSubmissionPhotosPhotosSubmissionSubmissionIdGet**
> List<String> listSubmissionPhotosPhotosSubmissionSubmissionIdGet(submissionId)

List Submission Photos

List all photos for a submission.  Args:     submission_id: The ID of the submission  Returns:     list[str]: List of photo URLs

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = PhotosApi();
final submissionId = submissionId_example; // String | 

try {
    final result = api_instance.listSubmissionPhotosPhotosSubmissionSubmissionIdGet(submissionId);
    print(result);
} catch (e) {
    print('Exception when calling PhotosApi->listSubmissionPhotosPhotosSubmissionSubmissionIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submissionId** | **String**|  | 

### Return type

**List<String>**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadProfilePhotoPhotosProfileUserIdPost**
> String uploadProfilePhotoPhotosProfileUserIdPost(userId, file)

Upload Profile Photo

Upload a user profile photo to cloud storage.  This endpoint uploads a profile photo for a specific user. The photo is stored with the user's ID as the filename, so uploading a new photo will replace the old one.  Path Structure: - collective-action-user-images/profiles/{user_id}.{ext}  Args:     user_id: The ID of the user (e.g., \"user_123\")     file: The image file to upload  Returns:     str: The public URL of the uploaded photo  Raises:     HTTPException: If upload fails or validation fails

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = PhotosApi();
final userId = userId_example; // String | 
final file = BINARY_DATA_HERE; // MultipartFile | 

try {
    final result = api_instance.uploadProfilePhotoPhotosProfileUserIdPost(userId, file);
    print(result);
} catch (e) {
    print('Exception when calling PhotosApi->uploadProfilePhotoPhotosProfileUserIdPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **file** | **MultipartFile**|  | 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadSubmissionPhotosPhotosSubmissionSubmissionIdPost**
> List<String> uploadSubmissionPhotosPhotosSubmissionSubmissionIdPost(submissionId, files)

Upload Submission Photos

Upload one or more submission photos to cloud storage.  This endpoint uploads photos for a specific submission. Each file gets a unique filename under that submission.  Path Structure: - collective-action-submissions/submissions/{submission_id}/{uuid}.{ext}  Args:     submission_id: The ID of the submission (e.g., \"submission_123\")     files: One or more image files to upload  Returns:     list[str]: Public URLs of the uploaded photos (same order as input)  Raises:     HTTPException: If no files provided, validation fails, or upload fails

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = PhotosApi();
final submissionId = submissionId_example; // String | 
final files = [/path/to/file.txt]; // List<MultipartFile> | One or more image files

try {
    final result = api_instance.uploadSubmissionPhotosPhotosSubmissionSubmissionIdPost(submissionId, files);
    print(result);
} catch (e) {
    print('Exception when calling PhotosApi->uploadSubmissionPhotosPhotosSubmissionSubmissionIdPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submissionId** | **String**|  | 
 **files** | [**List<MultipartFile>**](MultipartFile.md)| One or more image files | 

### Return type

**List<String>**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

