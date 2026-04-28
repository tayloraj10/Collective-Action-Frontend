# collective_action_api.api.ConnectionsApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createConnectionConnectionsPost**](ConnectionsApi.md#createconnectionconnectionspost) | **POST** /connections/ | Create Connection
[**deleteConnectionConnectionsConnectionIdDelete**](ConnectionsApi.md#deleteconnectionconnectionsconnectioniddelete) | **DELETE** /connections/{connection_id} | Delete Connection
[**getConnectionSummaryConnectionsSummaryToTypeGet**](ConnectionsApi.md#getconnectionsummaryconnectionssummarytotypeget) | **GET** /connections/summary/{to_type} | Get Connection Summary
[**getConnectionsForEntityConnectionsEntityToTypeToIdGet**](ConnectionsApi.md#getconnectionsforentityconnectionsentitytotypetoidget) | **GET** /connections/entity/{to_type}/{to_id} | Get Connections For Entity
[**getConnectionsForUserConnectionsUserUserIdGet**](ConnectionsApi.md#getconnectionsforuserconnectionsuseruseridget) | **GET** /connections/user/{user_id} | Get Connections For User


# **createConnectionConnectionsPost**
> ConnectionSchema createConnectionConnectionsPost(connectionCreateSchema)

Create Connection

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ConnectionsApi();
final connectionCreateSchema = ConnectionCreateSchema(); // ConnectionCreateSchema | 

try {
    final result = api_instance.createConnectionConnectionsPost(connectionCreateSchema);
    print(result);
} catch (e) {
    print('Exception when calling ConnectionsApi->createConnectionConnectionsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **connectionCreateSchema** | [**ConnectionCreateSchema**](ConnectionCreateSchema.md)|  | 

### Return type

[**ConnectionSchema**](ConnectionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteConnectionConnectionsConnectionIdDelete**
> deleteConnectionConnectionsConnectionIdDelete(connectionId, userId)

Delete Connection

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ConnectionsApi();
final connectionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the user requesting deletion

try {
    api_instance.deleteConnectionConnectionsConnectionIdDelete(connectionId, userId);
} catch (e) {
    print('Exception when calling ConnectionsApi->deleteConnectionConnectionsConnectionIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **connectionId** | **String**|  | 
 **userId** | **String**| ID of the user requesting deletion | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getConnectionSummaryConnectionsSummaryToTypeGet**
> List<ConnectionSummarySchema> getConnectionSummaryConnectionsSummaryToTypeGet(toType)

Get Connection Summary

Aggregated connection counts + avatar previews for every entity of `to_type`. One request covers all cards on the Connect screen.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ConnectionsApi();
final toType = toType_example; // String | 

try {
    final result = api_instance.getConnectionSummaryConnectionsSummaryToTypeGet(toType);
    print(result);
} catch (e) {
    print('Exception when calling ConnectionsApi->getConnectionSummaryConnectionsSummaryToTypeGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **toType** | **String**|  | 

### Return type

[**List<ConnectionSummarySchema>**](ConnectionSummarySchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getConnectionsForEntityConnectionsEntityToTypeToIdGet**
> List<ConnectionWithUserSchema> getConnectionsForEntityConnectionsEntityToTypeToIdGet(toType, toId, connectionType)

Get Connections For Entity

All connections to a specific entity, optionally filtered by type.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ConnectionsApi();
final toType = toType_example; // String | 
final toId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final connectionType = connectionType_example; // String | Filter by connection_type

try {
    final result = api_instance.getConnectionsForEntityConnectionsEntityToTypeToIdGet(toType, toId, connectionType);
    print(result);
} catch (e) {
    print('Exception when calling ConnectionsApi->getConnectionsForEntityConnectionsEntityToTypeToIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **toType** | **String**|  | 
 **toId** | **String**|  | 
 **connectionType** | **String**| Filter by connection_type | [optional] 

### Return type

[**List<ConnectionWithUserSchema>**](ConnectionWithUserSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getConnectionsForUserConnectionsUserUserIdGet**
> List<ConnectionSchema> getConnectionsForUserConnectionsUserUserIdGet(userId, connectionType)

Get Connections For User

All connections created by a specific user, optionally filtered by type.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ConnectionsApi();
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final connectionType = connectionType_example; // String | 

try {
    final result = api_instance.getConnectionsForUserConnectionsUserUserIdGet(userId, connectionType);
    print(result);
} catch (e) {
    print('Exception when calling ConnectionsApi->getConnectionsForUserConnectionsUserUserIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **connectionType** | **String**|  | [optional] 

### Return type

[**List<ConnectionSchema>**](ConnectionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

