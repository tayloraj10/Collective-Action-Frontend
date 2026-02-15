# collective_action_api.api.InitiativesApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createInitiativeInitiativesPost**](InitiativesApi.md#createinitiativeinitiativespost) | **POST** /initiatives/ | Create Initiative
[**getFeaturedInitiativesInitiativesFeaturedGet**](InitiativesApi.md#getfeaturedinitiativesinitiativesfeaturedget) | **GET** /initiatives/featured | Get Featured Initiatives
[**getInitiativeInitiativesInitiativeIdGet**](InitiativesApi.md#getinitiativeinitiativesinitiativeidget) | **GET** /initiatives/{initiative_id} | Get Initiative
[**getInitiativesByIdsInitiativesByIdsGet**](InitiativesApi.md#getinitiativesbyidsinitiativesbyidsget) | **GET** /initiatives/by-ids | Get Initiatives By Ids
[**listActiveInitiativesInitiativesActiveGet**](InitiativesApi.md#listactiveinitiativesinitiativesactiveget) | **GET** /initiatives/active | List Active Initiatives
[**listInitiativesByCreatorInitiativesCreatorUserIdGet**](InitiativesApi.md#listinitiativesbycreatorinitiativescreatoruseridget) | **GET** /initiatives/creator/{user_id} | List Initiatives By Creator
[**listInitiativesInitiativesGet**](InitiativesApi.md#listinitiativesinitiativesget) | **GET** /initiatives/ | List Initiatives


# **createInitiativeInitiativesPost**
> InitiativeSchema createInitiativeInitiativesPost(initiativeCreateSchema)

Create Initiative

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = InitiativesApi();
final initiativeCreateSchema = InitiativeCreateSchema(); // InitiativeCreateSchema | 

try {
    final result = api_instance.createInitiativeInitiativesPost(initiativeCreateSchema);
    print(result);
} catch (e) {
    print('Exception when calling InitiativesApi->createInitiativeInitiativesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **initiativeCreateSchema** | [**InitiativeCreateSchema**](InitiativeCreateSchema.md)|  | 

### Return type

[**InitiativeSchema**](InitiativeSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getFeaturedInitiativesInitiativesFeaturedGet**
> List<InitiativeSchema> getFeaturedInitiativesInitiativesFeaturedGet()

Get Featured Initiatives

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = InitiativesApi();

try {
    final result = api_instance.getFeaturedInitiativesInitiativesFeaturedGet();
    print(result);
} catch (e) {
    print('Exception when calling InitiativesApi->getFeaturedInitiativesInitiativesFeaturedGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<InitiativeSchema>**](InitiativeSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getInitiativeInitiativesInitiativeIdGet**
> InitiativeSchema getInitiativeInitiativesInitiativeIdGet(initiativeId)

Get Initiative

Get a single initiative by ID (includes created_by).

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = InitiativesApi();
final initiativeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getInitiativeInitiativesInitiativeIdGet(initiativeId);
    print(result);
} catch (e) {
    print('Exception when calling InitiativesApi->getInitiativeInitiativesInitiativeIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **initiativeId** | **String**|  | 

### Return type

[**InitiativeSchema**](InitiativeSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getInitiativesByIdsInitiativesByIdsGet**
> List<InitiativeSchema> getInitiativesByIdsInitiativesByIdsGet(initiativeIds)

Get Initiatives By Ids

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = InitiativesApi();
final initiativeIds = []; // List<String> | List of initiative IDs

try {
    final result = api_instance.getInitiativesByIdsInitiativesByIdsGet(initiativeIds);
    print(result);
} catch (e) {
    print('Exception when calling InitiativesApi->getInitiativesByIdsInitiativesByIdsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **initiativeIds** | [**List<String>**](String.md)| List of initiative IDs | [default to const []]

### Return type

[**List<InitiativeSchema>**](InitiativeSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listActiveInitiativesInitiativesActiveGet**
> List<InitiativeSchema> listActiveInitiativesInitiativesActiveGet()

List Active Initiatives

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = InitiativesApi();

try {
    final result = api_instance.listActiveInitiativesInitiativesActiveGet();
    print(result);
} catch (e) {
    print('Exception when calling InitiativesApi->listActiveInitiativesInitiativesActiveGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<InitiativeSchema>**](InitiativeSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listInitiativesByCreatorInitiativesCreatorUserIdGet**
> List<InitiativeSchema> listInitiativesByCreatorInitiativesCreatorUserIdGet(userId)

List Initiatives By Creator

Get all initiatives created by a specific user.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = InitiativesApi();
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.listInitiativesByCreatorInitiativesCreatorUserIdGet(userId);
    print(result);
} catch (e) {
    print('Exception when calling InitiativesApi->listInitiativesByCreatorInitiativesCreatorUserIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**List<InitiativeSchema>**](InitiativeSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listInitiativesInitiativesGet**
> List<InitiativeSchema> listInitiativesInitiativesGet()

List Initiatives

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = InitiativesApi();

try {
    final result = api_instance.listInitiativesInitiativesGet();
    print(result);
} catch (e) {
    print('Exception when calling InitiativesApi->listInitiativesInitiativesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<InitiativeSchema>**](InitiativeSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

