# collective_action_api.model.ActionSchema

## Load the model package
```dart
import 'package:collective_action_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**actionType** | **String** |  | 
**amount** | **num** |  | [optional] 
**date** | [**DateTime**](DateTime.md) |  | 
**imageUrls** | **List<String>** | List of image URLs | [optional] [default to const []]
**linkedId** | **String** |  | [optional] 
**userId** | **String** |  | [optional] 
**latitude** | **num** |  | [optional] 
**longitude** | **num** |  | [optional] 
**eventData** | [**Map<String, Object>**](Object.md) |  | [optional] [default to const {}]
**likeUserIds** | **List<String>** | Database user ids who liked this action (newest first). | [optional] [default to const []]
**likeCount** | **int** |  | [optional] [default to 0]
**likedByMe** | **bool** |  | [optional] [default to false]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


