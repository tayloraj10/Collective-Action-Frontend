# collective_action_api.api.StatusesApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createStatusStatusesPost**](StatusesApi.md#createstatusstatusespost) | **POST** /statuses/ | Create Status
[**deleteStatusStatusesStatusIdDelete**](StatusesApi.md#deletestatusstatusesstatusiddelete) | **DELETE** /statuses/{status_id} | Delete Status
[**getStatusStatusesStatusIdGet**](StatusesApi.md#getstatusstatusesstatusidget) | **GET** /statuses/{status_id} | Get Status
[**getStatusesByTypeStatusesByTypeStatusTypeGet**](StatusesApi.md#getstatusesbytypestatusesbytypestatustypeget) | **GET** /statuses/by_type/{status_type} | Get Statuses By Type
[**listStatusesStatusesGet**](StatusesApi.md#liststatusesstatusesget) | **GET** /statuses/ | List Statuses
[**updateStatusStatusesStatusIdPut**](StatusesApi.md#updatestatusstatusesstatusidput) | **PUT** /statuses/{status_id} | Update Status


# **createStatusStatusesPost**
> StatusSchema createStatusStatusesPost(statusCreate)

Create Status

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = StatusesApi();
final statusCreate = StatusCreate(); // StatusCreate | 

try {
    final result = api_instance.createStatusStatusesPost(statusCreate);
    print(result);
} catch (e) {
    print('Exception when calling StatusesApi->createStatusStatusesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statusCreate** | [**StatusCreate**](StatusCreate.md)|  | 

### Return type

[**StatusSchema**](StatusSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteStatusStatusesStatusIdDelete**
> Object deleteStatusStatusesStatusIdDelete(statusId)

Delete Status

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = StatusesApi();
final statusId = statusId_example; // String | 

try {
    final result = api_instance.deleteStatusStatusesStatusIdDelete(statusId);
    print(result);
} catch (e) {
    print('Exception when calling StatusesApi->deleteStatusStatusesStatusIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statusId** | **String**|  | 

### Return type

[**Object**](Object.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getStatusStatusesStatusIdGet**
> StatusSchema getStatusStatusesStatusIdGet(statusId)

Get Status

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = StatusesApi();
final statusId = statusId_example; // String | 

try {
    final result = api_instance.getStatusStatusesStatusIdGet(statusId);
    print(result);
} catch (e) {
    print('Exception when calling StatusesApi->getStatusStatusesStatusIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statusId** | **String**|  | 

### Return type

[**StatusSchema**](StatusSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getStatusesByTypeStatusesByTypeStatusTypeGet**
> List<StatusSchema> getStatusesByTypeStatusesByTypeStatusTypeGet(statusType)

Get Statuses By Type

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = StatusesApi();
final statusType = statusType_example; // String | 

try {
    final result = api_instance.getStatusesByTypeStatusesByTypeStatusTypeGet(statusType);
    print(result);
} catch (e) {
    print('Exception when calling StatusesApi->getStatusesByTypeStatusesByTypeStatusTypeGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statusType** | **String**|  | 

### Return type

[**List<StatusSchema>**](StatusSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listStatusesStatusesGet**
> List<StatusSchema> listStatusesStatusesGet()

List Statuses

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = StatusesApi();

try {
    final result = api_instance.listStatusesStatusesGet();
    print(result);
} catch (e) {
    print('Exception when calling StatusesApi->listStatusesStatusesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<StatusSchema>**](StatusSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateStatusStatusesStatusIdPut**
> StatusSchema updateStatusStatusesStatusIdPut(statusId, statusCreate)

Update Status

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = StatusesApi();
final statusId = statusId_example; // String | 
final statusCreate = StatusCreate(); // StatusCreate | 

try {
    final result = api_instance.updateStatusStatusesStatusIdPut(statusId, statusCreate);
    print(result);
} catch (e) {
    print('Exception when calling StatusesApi->updateStatusStatusesStatusIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statusId** | **String**|  | 
 **statusCreate** | [**StatusCreate**](StatusCreate.md)|  | 

### Return type

[**StatusSchema**](StatusSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

