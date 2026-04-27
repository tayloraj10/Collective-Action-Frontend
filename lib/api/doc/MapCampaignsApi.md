# collective_action_api.api.MapCampaignsApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createMapCampaignMapCampaignsPost**](MapCampaignsApi.md#createmapcampaignmapcampaignspost) | **POST** /map-campaigns/ | Create Map Campaign
[**deleteMapCampaignMapCampaignsCampaignIdDelete**](MapCampaignsApi.md#deletemapcampaignmapcampaignscampaigniddelete) | **DELETE** /map-campaigns/{campaign_id} | Delete Map Campaign
[**getMapCampaignMapCampaignsCampaignIdGet**](MapCampaignsApi.md#getmapcampaignmapcampaignscampaignidget) | **GET** /map-campaigns/{campaign_id} | Get Map Campaign
[**listActiveMapCampaignsMapCampaignsActiveGet**](MapCampaignsApi.md#listactivemapcampaignsmapcampaignsactiveget) | **GET** /map-campaigns/active | List Active Map Campaigns
[**listMapCampaignsByCreatorMapCampaignsCreatorUserIdGet**](MapCampaignsApi.md#listmapcampaignsbycreatormapcampaignscreatoruseridget) | **GET** /map-campaigns/creator/{user_id} | List Map Campaigns By Creator
[**listMapCampaignsByTypeMapCampaignsByTypeCampaignTypeGet**](MapCampaignsApi.md#listmapcampaignsbytypemapcampaignsbytypecampaigntypeget) | **GET** /map-campaigns/by-type/{campaign_type} | List Map Campaigns By Type
[**listMapCampaignsMapCampaignsGet**](MapCampaignsApi.md#listmapcampaignsmapcampaignsget) | **GET** /map-campaigns/ | List Map Campaigns


# **createMapCampaignMapCampaignsPost**
> MapCampaignSchema createMapCampaignMapCampaignsPost(mapCampaignCreateSchema)

Create Map Campaign

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapCampaignsApi();
final mapCampaignCreateSchema = MapCampaignCreateSchema(); // MapCampaignCreateSchema | 

try {
    final result = api_instance.createMapCampaignMapCampaignsPost(mapCampaignCreateSchema);
    print(result);
} catch (e) {
    print('Exception when calling MapCampaignsApi->createMapCampaignMapCampaignsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mapCampaignCreateSchema** | [**MapCampaignCreateSchema**](MapCampaignCreateSchema.md)|  | 

### Return type

[**MapCampaignSchema**](MapCampaignSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteMapCampaignMapCampaignsCampaignIdDelete**
> deleteMapCampaignMapCampaignsCampaignIdDelete(campaignId)

Delete Map Campaign

Delete a map campaign. Fails with 409 if any link references this campaign.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapCampaignsApi();
final campaignId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api_instance.deleteMapCampaignMapCampaignsCampaignIdDelete(campaignId);
} catch (e) {
    print('Exception when calling MapCampaignsApi->deleteMapCampaignMapCampaignsCampaignIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaignId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMapCampaignMapCampaignsCampaignIdGet**
> MapCampaignSchema getMapCampaignMapCampaignsCampaignIdGet(campaignId)

Get Map Campaign

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapCampaignsApi();
final campaignId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getMapCampaignMapCampaignsCampaignIdGet(campaignId);
    print(result);
} catch (e) {
    print('Exception when calling MapCampaignsApi->getMapCampaignMapCampaignsCampaignIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaignId** | **String**|  | 

### Return type

[**MapCampaignSchema**](MapCampaignSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listActiveMapCampaignsMapCampaignsActiveGet**
> List<MapCampaignSchema> listActiveMapCampaignsMapCampaignsActiveGet()

List Active Map Campaigns

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapCampaignsApi();

try {
    final result = api_instance.listActiveMapCampaignsMapCampaignsActiveGet();
    print(result);
} catch (e) {
    print('Exception when calling MapCampaignsApi->listActiveMapCampaignsMapCampaignsActiveGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<MapCampaignSchema>**](MapCampaignSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMapCampaignsByCreatorMapCampaignsCreatorUserIdGet**
> List<MapCampaignSchema> listMapCampaignsByCreatorMapCampaignsCreatorUserIdGet(userId)

List Map Campaigns By Creator

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapCampaignsApi();
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.listMapCampaignsByCreatorMapCampaignsCreatorUserIdGet(userId);
    print(result);
} catch (e) {
    print('Exception when calling MapCampaignsApi->listMapCampaignsByCreatorMapCampaignsCreatorUserIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**List<MapCampaignSchema>**](MapCampaignSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMapCampaignsByTypeMapCampaignsByTypeCampaignTypeGet**
> List<MapCampaignSchema> listMapCampaignsByTypeMapCampaignsByTypeCampaignTypeGet(campaignType)

List Map Campaigns By Type

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapCampaignsApi();
final campaignType = ; // MapCampaignTypeEnum | 

try {
    final result = api_instance.listMapCampaignsByTypeMapCampaignsByTypeCampaignTypeGet(campaignType);
    print(result);
} catch (e) {
    print('Exception when calling MapCampaignsApi->listMapCampaignsByTypeMapCampaignsByTypeCampaignTypeGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaignType** | [**MapCampaignTypeEnum**](.md)|  | 

### Return type

[**List<MapCampaignSchema>**](MapCampaignSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMapCampaignsMapCampaignsGet**
> List<MapCampaignSchema> listMapCampaignsMapCampaignsGet()

List Map Campaigns

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = MapCampaignsApi();

try {
    final result = api_instance.listMapCampaignsMapCampaignsGet();
    print(result);
} catch (e) {
    print('Exception when calling MapCampaignsApi->listMapCampaignsMapCampaignsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<MapCampaignSchema>**](MapCampaignSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

