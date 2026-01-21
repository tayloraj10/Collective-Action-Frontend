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
[**listActiveInitiativesInitiativesActiveGet**](InitiativesApi.md#listactiveinitiativesinitiativesactiveget) | **GET** /initiatives/active | List Active Initiatives
[**listInitiativesInitiativesGet**](InitiativesApi.md#listinitiativesinitiativesget) | **GET** /initiatives/ | List Initiatives
[**listInitiativesSummaryInitiativesSummaryGet**](InitiativesApi.md#listinitiativessummaryinitiativessummaryget) | **GET** /initiatives/summary | List Initiatives Summary


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

# **listInitiativesSummaryInitiativesSummaryGet**
> List<InitiativeSchema> listInitiativesSummaryInitiativesSummaryGet()

List Initiatives Summary

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = InitiativesApi();

try {
    final result = api_instance.listInitiativesSummaryInitiativesSummaryGet();
    print(result);
} catch (e) {
    print('Exception when calling InitiativesApi->listInitiativesSummaryInitiativesSummaryGet: $e\n');
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

