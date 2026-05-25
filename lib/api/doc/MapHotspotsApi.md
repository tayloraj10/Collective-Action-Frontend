# collective_action_api.api.MapHotspotsApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**assignAreaCaptainMapHotspotsAreaCaptainsAssignPost**](MapHotspotsApi.md#assignareacaptainmaphotspotsareacaptainsassignpost) | **POST** /map-hotspots/area-captains/assign | Assign Area Captain
[**createAreaMapHotspotsAreasPost**](MapHotspotsApi.md#createareamaphotspotsareaspost) | **POST** /map-hotspots/areas | Create Area
[**createHotspotMapHotspotsPost**](MapHotspotsApi.md#createhotspotmaphotspotspost) | **POST** /map-hotspots/ | Create Hotspot
[**deleteHotspotMapHotspotsHotspotIdDelete**](MapHotspotsApi.md#deletehotspotmaphotspotshotspotiddelete) | **DELETE** /map-hotspots/{hotspot_id} | Delete Hotspot
[**listAreaCaptainsMapHotspotsCampaignCampaignIdAreaCaptainsGet**](MapHotspotsApi.md#listareacaptainsmaphotspotscampaigncampaignidareacaptainsget) | **GET** /map-hotspots/campaign/{campaign_id}/area-captains | List Area Captains
[**listAreasMapHotspotsCampaignCampaignIdAreasGet**](MapHotspotsApi.md#listareasmaphotspotscampaigncampaignidareasget) | **GET** /map-hotspots/campaign/{campaign_id}/areas | List Areas
[**listHotspotsMapHotspotsCampaignCampaignIdGet**](MapHotspotsApi.md#listhotspotsmaphotspotscampaigncampaignidget) | **GET** /map-hotspots/campaign/{campaign_id} | List Hotspots
[**removeAreaCaptainMapHotspotsAreaCaptainsAssignmentIdDelete**](MapHotspotsApi.md#removeareacaptainmaphotspotsareacaptainsassignmentiddelete) | **DELETE** /map-hotspots/area-captains/{assignment_id} | Remove Area Captain
[**updateHotspotMapHotspotsHotspotIdPatch**](MapHotspotsApi.md#updatehotspotmaphotspotshotspotidpatch) | **PATCH** /map-hotspots/{hotspot_id} | Update Hotspot


# **assignAreaCaptainMapHotspotsAreaCaptainsAssignPost**
> AreaCaptainSchema assignAreaCaptainMapHotspotsAreaCaptainsAssignPost(areaCaptainAssignSchema)

Assign Area Captain

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapHotspotsApi();
final areaCaptainAssignSchema = AreaCaptainAssignSchema(); // AreaCaptainAssignSchema | 

try {
    final result = api_instance.assignAreaCaptainMapHotspotsAreaCaptainsAssignPost(areaCaptainAssignSchema);
    print(result);
} catch (e) {
    print('Exception when calling MapHotspotsApi->assignAreaCaptainMapHotspotsAreaCaptainsAssignPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **areaCaptainAssignSchema** | [**AreaCaptainAssignSchema**](AreaCaptainAssignSchema.md)|  | 

### Return type

[**AreaCaptainSchema**](AreaCaptainSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createAreaMapHotspotsAreasPost**
> MapAreaSchema createAreaMapHotspotsAreasPost(mapAreaCreateSchema)

Create Area

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapHotspotsApi();
final mapAreaCreateSchema = MapAreaCreateSchema(); // MapAreaCreateSchema | 

try {
    final result = api_instance.createAreaMapHotspotsAreasPost(mapAreaCreateSchema);
    print(result);
} catch (e) {
    print('Exception when calling MapHotspotsApi->createAreaMapHotspotsAreasPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mapAreaCreateSchema** | [**MapAreaCreateSchema**](MapAreaCreateSchema.md)|  | 

### Return type

[**MapAreaSchema**](MapAreaSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createHotspotMapHotspotsPost**
> MapHotspotSchema createHotspotMapHotspotsPost(mapHotspotCreateSchema)

Create Hotspot

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapHotspotsApi();
final mapHotspotCreateSchema = MapHotspotCreateSchema(); // MapHotspotCreateSchema | 

try {
    final result = api_instance.createHotspotMapHotspotsPost(mapHotspotCreateSchema);
    print(result);
} catch (e) {
    print('Exception when calling MapHotspotsApi->createHotspotMapHotspotsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mapHotspotCreateSchema** | [**MapHotspotCreateSchema**](MapHotspotCreateSchema.md)|  | 

### Return type

[**MapHotspotSchema**](MapHotspotSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteHotspotMapHotspotsHotspotIdDelete**
> deleteHotspotMapHotspotsHotspotIdDelete(hotspotId, actingUserId)

Delete Hotspot

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapHotspotsApi();
final hotspotId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final actingUserId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api_instance.deleteHotspotMapHotspotsHotspotIdDelete(hotspotId, actingUserId);
} catch (e) {
    print('Exception when calling MapHotspotsApi->deleteHotspotMapHotspotsHotspotIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hotspotId** | **String**|  | 
 **actingUserId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAreaCaptainsMapHotspotsCampaignCampaignIdAreaCaptainsGet**
> List<AreaCaptainSchema> listAreaCaptainsMapHotspotsCampaignCampaignIdAreaCaptainsGet(campaignId)

List Area Captains

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapHotspotsApi();
final campaignId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.listAreaCaptainsMapHotspotsCampaignCampaignIdAreaCaptainsGet(campaignId);
    print(result);
} catch (e) {
    print('Exception when calling MapHotspotsApi->listAreaCaptainsMapHotspotsCampaignCampaignIdAreaCaptainsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaignId** | **String**|  | 

### Return type

[**List<AreaCaptainSchema>**](AreaCaptainSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAreasMapHotspotsCampaignCampaignIdAreasGet**
> List<MapAreaSchema> listAreasMapHotspotsCampaignCampaignIdAreasGet(campaignId)

List Areas

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapHotspotsApi();
final campaignId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.listAreasMapHotspotsCampaignCampaignIdAreasGet(campaignId);
    print(result);
} catch (e) {
    print('Exception when calling MapHotspotsApi->listAreasMapHotspotsCampaignCampaignIdAreasGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaignId** | **String**|  | 

### Return type

[**List<MapAreaSchema>**](MapAreaSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listHotspotsMapHotspotsCampaignCampaignIdGet**
> List<MapHotspotSchema> listHotspotsMapHotspotsCampaignCampaignIdGet(campaignId, includeInactive)

List Hotspots

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapHotspotsApi();
final campaignId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final includeInactive = true; // bool | 

try {
    final result = api_instance.listHotspotsMapHotspotsCampaignCampaignIdGet(campaignId, includeInactive);
    print(result);
} catch (e) {
    print('Exception when calling MapHotspotsApi->listHotspotsMapHotspotsCampaignCampaignIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaignId** | **String**|  | 
 **includeInactive** | **bool**|  | [optional] [default to false]

### Return type

[**List<MapHotspotSchema>**](MapHotspotSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeAreaCaptainMapHotspotsAreaCaptainsAssignmentIdDelete**
> removeAreaCaptainMapHotspotsAreaCaptainsAssignmentIdDelete(assignmentId, actingUserId)

Remove Area Captain

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapHotspotsApi();
final assignmentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final actingUserId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api_instance.removeAreaCaptainMapHotspotsAreaCaptainsAssignmentIdDelete(assignmentId, actingUserId);
} catch (e) {
    print('Exception when calling MapHotspotsApi->removeAreaCaptainMapHotspotsAreaCaptainsAssignmentIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assignmentId** | **String**|  | 
 **actingUserId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateHotspotMapHotspotsHotspotIdPatch**
> MapHotspotSchema updateHotspotMapHotspotsHotspotIdPatch(hotspotId, mapHotspotUpdateSchema)

Update Hotspot

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapHotspotsApi();
final hotspotId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final mapHotspotUpdateSchema = MapHotspotUpdateSchema(); // MapHotspotUpdateSchema | 

try {
    final result = api_instance.updateHotspotMapHotspotsHotspotIdPatch(hotspotId, mapHotspotUpdateSchema);
    print(result);
} catch (e) {
    print('Exception when calling MapHotspotsApi->updateHotspotMapHotspotsHotspotIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hotspotId** | **String**|  | 
 **mapHotspotUpdateSchema** | [**MapHotspotUpdateSchema**](MapHotspotUpdateSchema.md)|  | 

### Return type

[**MapHotspotSchema**](MapHotspotSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

