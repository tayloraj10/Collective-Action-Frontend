# collective_action_api.api.LinksApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createLinkLinksPost**](LinksApi.md#createlinklinkspost) | **POST** /links/ | Create Link
[**deleteLinkLinksLinkIdDelete**](LinksApi.md#deletelinklinkslinkiddelete) | **DELETE** /links/{link_id} | Delete Link
[**getLinkLinksLinkIdGet**](LinksApi.md#getlinklinkslinkidget) | **GET** /links/{link_id} | Get Link
[**getLinksByInitiativeLinksInitiativeInitiativeIdGet**](LinksApi.md#getlinksbyinitiativelinksinitiativeinitiativeidget) | **GET** /links/initiative/{initiative_id} | Get Links By Initiative
[**getLinksByProjectLinksProjectProjectIdGet**](LinksApi.md#getlinksbyprojectlinksprojectprojectidget) | **GET** /links/project/{project_id} | Get Links By Project
[**listLinksLinksGet**](LinksApi.md#listlinkslinksget) | **GET** /links/ | List Links
[**updateLinkLinksLinkIdPatch**](LinksApi.md#updatelinklinkslinkidpatch) | **PATCH** /links/{link_id} | Update Link


# **createLinkLinksPost**
> LinkSchema createLinkLinksPost(linkCreateSchema)

Create Link

Create a link between a project and an initiative.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = LinksApi();
final linkCreateSchema = LinkCreateSchema(); // LinkCreateSchema | 

try {
    final result = api_instance.createLinkLinksPost(linkCreateSchema);
    print(result);
} catch (e) {
    print('Exception when calling LinksApi->createLinkLinksPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **linkCreateSchema** | [**LinkCreateSchema**](LinkCreateSchema.md)|  | 

### Return type

[**LinkSchema**](LinkSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteLinkLinksLinkIdDelete**
> LinkSchema deleteLinkLinksLinkIdDelete(linkId)

Delete Link

Delete a link.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = LinksApi();
final linkId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.deleteLinkLinksLinkIdDelete(linkId);
    print(result);
} catch (e) {
    print('Exception when calling LinksApi->deleteLinkLinksLinkIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **linkId** | **String**|  | 

### Return type

[**LinkSchema**](LinkSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLinkLinksLinkIdGet**
> LinkSchema getLinkLinksLinkIdGet(linkId)

Get Link

Get a specific link by ID.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = LinksApi();
final linkId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getLinkLinksLinkIdGet(linkId);
    print(result);
} catch (e) {
    print('Exception when calling LinksApi->getLinkLinksLinkIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **linkId** | **String**|  | 

### Return type

[**LinkSchema**](LinkSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLinksByInitiativeLinksInitiativeInitiativeIdGet**
> List<LinkSchema> getLinksByInitiativeLinksInitiativeInitiativeIdGet(initiativeId)

Get Links By Initiative

Get all links for a specific initiative.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = LinksApi();
final initiativeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getLinksByInitiativeLinksInitiativeInitiativeIdGet(initiativeId);
    print(result);
} catch (e) {
    print('Exception when calling LinksApi->getLinksByInitiativeLinksInitiativeInitiativeIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **initiativeId** | **String**|  | 

### Return type

[**List<LinkSchema>**](LinkSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLinksByProjectLinksProjectProjectIdGet**
> List<LinkSchema> getLinksByProjectLinksProjectProjectIdGet(projectId)

Get Links By Project

Get all links for a specific project.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = LinksApi();
final projectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getLinksByProjectLinksProjectProjectIdGet(projectId);
    print(result);
} catch (e) {
    print('Exception when calling LinksApi->getLinksByProjectLinksProjectProjectIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  | 

### Return type

[**List<LinkSchema>**](LinkSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listLinksLinksGet**
> List<LinkSchema> listLinksLinksGet()

List Links

Get all links.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = LinksApi();

try {
    final result = api_instance.listLinksLinksGet();
    print(result);
} catch (e) {
    print('Exception when calling LinksApi->listLinksLinksGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<LinkSchema>**](LinkSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateLinkLinksLinkIdPatch**
> LinkSchema updateLinkLinksLinkIdPatch(linkId, linkUpdateSchema)

Update Link

Update a link (change project or initiative).

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = LinksApi();
final linkId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final linkUpdateSchema = LinkUpdateSchema(); // LinkUpdateSchema | 

try {
    final result = api_instance.updateLinkLinksLinkIdPatch(linkId, linkUpdateSchema);
    print(result);
} catch (e) {
    print('Exception when calling LinksApi->updateLinkLinksLinkIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **linkId** | **String**|  | 
 **linkUpdateSchema** | [**LinkUpdateSchema**](LinkUpdateSchema.md)|  | 

### Return type

[**LinkSchema**](LinkSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

