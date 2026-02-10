# collective_action_api.model.ProjectSchema

## Load the model package
```dart
import 'package:collective_action_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**name** | **String** |  | 
**description** | **String** |  | [optional] 
**categoryId** | **String** |  | [optional] 
**statusId** | **String** |  | [optional] 
**creatorId** | **String** |  | 
**active** | **bool** |  | [optional] [default to true]
**members** | [**MemberIdsByRole**](MemberIdsByRole.md) |  | [optional] 
**steps** | [**List<ProjectStepSchema>**](ProjectStepSchema.md) |  | [optional] [default to const []]
**links** | [**List<ProjectLinkSchema>**](ProjectLinkSchema.md) |  | [optional] [default to const []]
**createdAt** | [**DateTime**](DateTime.md) |  | 
**updatedAt** | [**DateTime**](DateTime.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


