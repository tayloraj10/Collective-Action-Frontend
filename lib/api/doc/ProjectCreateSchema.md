# collective_action_api.model.ProjectCreateSchema

## Load the model package
```dart
import 'package:collective_action_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **String** |  | 
**description** | **String** |  | [optional] 
**categoryId** | **String** |  | [optional] 
**statusId** | **String** |  | [optional] 
**creatorId** | **String** |  | 
**active** | **bool** |  | [optional] [default to true]
**members** | [**MemberIdsByRole**](MemberIdsByRole.md) |  | [optional] 
**steps** | [**List<ProjectStepCreateSchema>**](ProjectStepCreateSchema.md) |  | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


