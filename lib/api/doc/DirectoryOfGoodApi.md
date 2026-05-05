# collective_action_api.api.DirectoryOfGoodApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createEntryDirectoryOfGoodPost**](DirectoryOfGoodApi.md#createentrydirectoryofgoodpost) | **POST** /directory-of-good/ | Create Entry
[**deleteEntryDirectoryOfGoodEntryIdDelete**](DirectoryOfGoodApi.md#deleteentrydirectoryofgoodentryiddelete) | **DELETE** /directory-of-good/{entry_id} | Delete Entry
[**getEntriesBulkDirectoryOfGoodBulkGet**](DirectoryOfGoodApi.md#getentriesbulkdirectoryofgoodbulkget) | **GET** /directory-of-good/bulk | Get Entries Bulk
[**getEntryDirectoryOfGoodEntryIdGet**](DirectoryOfGoodApi.md#getentrydirectoryofgoodentryidget) | **GET** /directory-of-good/{entry_id} | Get Entry
[**listEntriesByUserDirectoryOfGoodByUserUserIdGet**](DirectoryOfGoodApi.md#listentriesbyuserdirectoryofgoodbyuseruseridget) | **GET** /directory-of-good/by-user/{user_id} | List Entries By User
[**listEntriesDirectoryOfGoodGet**](DirectoryOfGoodApi.md#listentriesdirectoryofgoodget) | **GET** /directory-of-good/ | List Entries
[**setFeaturedDirectoryOfGoodEntryIdFeaturePatch**](DirectoryOfGoodApi.md#setfeatureddirectoryofgoodentryidfeaturepatch) | **PATCH** /directory-of-good/{entry_id}/feature | Set Featured
[**syncFromGoogleSheetDirectoryOfGoodSyncFromGoogleSheetPost**](DirectoryOfGoodApi.md#syncfromgooglesheetdirectoryofgoodsyncfromgooglesheetpost) | **POST** /directory-of-good/sync-from-google-sheet | Sync From Google Sheet
[**updateEntryDirectoryOfGoodEntryIdPatch**](DirectoryOfGoodApi.md#updateentrydirectoryofgoodentryidpatch) | **PATCH** /directory-of-good/{entry_id} | Update Entry


# **createEntryDirectoryOfGoodPost**
> DirectoryOfGoodSchema createEntryDirectoryOfGoodPost(directoryOfGoodCreate)

Create Entry

Create a new directory of good entry and an action record.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = DirectoryOfGoodApi();
final directoryOfGoodCreate = DirectoryOfGoodCreate(); // DirectoryOfGoodCreate | 

try {
    final result = api_instance.createEntryDirectoryOfGoodPost(directoryOfGoodCreate);
    print(result);
} catch (e) {
    print('Exception when calling DirectoryOfGoodApi->createEntryDirectoryOfGoodPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **directoryOfGoodCreate** | [**DirectoryOfGoodCreate**](DirectoryOfGoodCreate.md)|  | 

### Return type

[**DirectoryOfGoodSchema**](DirectoryOfGoodSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteEntryDirectoryOfGoodEntryIdDelete**
> deleteEntryDirectoryOfGoodEntryIdDelete(entryId)

Delete Entry

Delete a directory of good entry.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = DirectoryOfGoodApi();
final entryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api_instance.deleteEntryDirectoryOfGoodEntryIdDelete(entryId);
} catch (e) {
    print('Exception when calling DirectoryOfGoodApi->deleteEntryDirectoryOfGoodEntryIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **entryId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getEntriesBulkDirectoryOfGoodBulkGet**
> List<DirectoryOfGoodSchema> getEntriesBulkDirectoryOfGoodBulkGet(ids)

Get Entries Bulk

Get multiple directory of good entries by comma-separated IDs.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = DirectoryOfGoodApi();
final ids = ids_example; // String | 

try {
    final result = api_instance.getEntriesBulkDirectoryOfGoodBulkGet(ids);
    print(result);
} catch (e) {
    print('Exception when calling DirectoryOfGoodApi->getEntriesBulkDirectoryOfGoodBulkGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ids** | **String**|  | 

### Return type

[**List<DirectoryOfGoodSchema>**](DirectoryOfGoodSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getEntryDirectoryOfGoodEntryIdGet**
> DirectoryOfGoodSchema getEntryDirectoryOfGoodEntryIdGet(entryId)

Get Entry

Get a single directory of good entry by ID.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = DirectoryOfGoodApi();
final entryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getEntryDirectoryOfGoodEntryIdGet(entryId);
    print(result);
} catch (e) {
    print('Exception when calling DirectoryOfGoodApi->getEntryDirectoryOfGoodEntryIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **entryId** | **String**|  | 

### Return type

[**DirectoryOfGoodSchema**](DirectoryOfGoodSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listEntriesByUserDirectoryOfGoodByUserUserIdGet**
> List<DirectoryOfGoodSchema> listEntriesByUserDirectoryOfGoodByUserUserIdGet(userId)

List Entries By User

List directory entries linked to a specific user.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = DirectoryOfGoodApi();
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.listEntriesByUserDirectoryOfGoodByUserUserIdGet(userId);
    print(result);
} catch (e) {
    print('Exception when calling DirectoryOfGoodApi->listEntriesByUserDirectoryOfGoodByUserUserIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**List<DirectoryOfGoodSchema>**](DirectoryOfGoodSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listEntriesDirectoryOfGoodGet**
> List<DirectoryOfGoodSchema> listEntriesDirectoryOfGoodGet()

List Entries

List all directory of good entries.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = DirectoryOfGoodApi();

try {
    final result = api_instance.listEntriesDirectoryOfGoodGet();
    print(result);
} catch (e) {
    print('Exception when calling DirectoryOfGoodApi->listEntriesDirectoryOfGoodGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<DirectoryOfGoodSchema>**](DirectoryOfGoodSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setFeaturedDirectoryOfGoodEntryIdFeaturePatch**
> DirectoryOfGoodSchema setFeaturedDirectoryOfGoodEntryIdFeaturePatch(entryId, featureUpdate)

Set Featured

Feature or unfeature a directory of good entry.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = DirectoryOfGoodApi();
final entryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final featureUpdate = FeatureUpdate(); // FeatureUpdate | 

try {
    final result = api_instance.setFeaturedDirectoryOfGoodEntryIdFeaturePatch(entryId, featureUpdate);
    print(result);
} catch (e) {
    print('Exception when calling DirectoryOfGoodApi->setFeaturedDirectoryOfGoodEntryIdFeaturePatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **entryId** | **String**|  | 
 **featureUpdate** | [**FeatureUpdate**](FeatureUpdate.md)|  | 

### Return type

[**DirectoryOfGoodSchema**](DirectoryOfGoodSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **syncFromGoogleSheetDirectoryOfGoodSyncFromGoogleSheetPost**
> SheetSyncResponse syncFromGoogleSheetDirectoryOfGoodSyncFromGoogleSheetPost(xSyncSecret)

Sync From Google Sheet

Upsert directory rows from the configured 'Interesting People' Google Sheet, then geocode any entries that are still missing coordinates.  **Credentials:** If ``GOOGLE_APPLICATION_CREDENTIALS`` is set to a service account JSON path, that key is used. Otherwise **Application Default Credentials** are used (e.g. Cloud Run / GCE runtime service account). Enable the Google Sheets API for the project and share the spreadsheet with that service account email.  When ``DIRECTORY_GOOGLE_SHEET_SYNC_SECRET`` is set, the same value must be sent in the ``X-Sync-Secret`` header.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = DirectoryOfGoodApi();
final xSyncSecret = xSyncSecret_example; // String | 

try {
    final result = api_instance.syncFromGoogleSheetDirectoryOfGoodSyncFromGoogleSheetPost(xSyncSecret);
    print(result);
} catch (e) {
    print('Exception when calling DirectoryOfGoodApi->syncFromGoogleSheetDirectoryOfGoodSyncFromGoogleSheetPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xSyncSecret** | **String**|  | [optional] 

### Return type

[**SheetSyncResponse**](SheetSyncResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateEntryDirectoryOfGoodEntryIdPatch**
> DirectoryOfGoodSchema updateEntryDirectoryOfGoodEntryIdPatch(entryId, directoryOfGoodUpdate)

Update Entry

Update a directory of good entry (partial update).

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = DirectoryOfGoodApi();
final entryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final directoryOfGoodUpdate = DirectoryOfGoodUpdate(); // DirectoryOfGoodUpdate | 

try {
    final result = api_instance.updateEntryDirectoryOfGoodEntryIdPatch(entryId, directoryOfGoodUpdate);
    print(result);
} catch (e) {
    print('Exception when calling DirectoryOfGoodApi->updateEntryDirectoryOfGoodEntryIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **entryId** | **String**|  | 
 **directoryOfGoodUpdate** | [**DirectoryOfGoodUpdate**](DirectoryOfGoodUpdate.md)|  | 

### Return type

[**DirectoryOfGoodSchema**](DirectoryOfGoodSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

