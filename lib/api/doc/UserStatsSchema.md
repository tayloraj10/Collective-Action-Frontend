# collective_action_api.model.UserStatsSchema

## Load the model package
```dart
import 'package:collective_action_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**userId** | **String** |  | 
**mapSubmissionCount** | **int** |  | [optional] [default to 0]
**cleanupCount** | **int** |  | [optional] [default to 0]
**trashReportCount** | **int** |  | [optional] [default to 0]
**totalSmallBags** | **int** |  | [optional] [default to 0]
**totalLargeBags** | **int** |  | [optional] [default to 0]
**totalBags** | **int** |  | [optional] [default to 0]
**totalPounds** | **num** |  | [optional] [default to 0.0]
**treePlantingCount** | **int** |  | [optional] [default to 0]
**wildflowerPlantingCount** | **int** |  | [optional] [default to 0]
**totalPlantings** | **int** |  | [optional] [default to 0]
**initiativeActionCount** | **int** |  | [optional] [default to 0]
**initiativesParticipated** | **int** |  | [optional] [default to 0]
**mapCampaignBreakdown** | [**List<MapCampaignStatsSchema>**](MapCampaignStatsSchema.md) |  | [optional] [default to const []]
**actionTypeCounts** | **Map<String, int>** |  | [optional] [default to const {}]
**followsCount** | **int** |  | [optional] [default to 0]
**contributionsCount** | **int** |  | [optional] [default to 0]
**orgId** | **String** |  | [optional] 
**orgName** | **String** |  | [optional] 
**orgFollowersCount** | **int** |  | [optional] [default to 0]
**orgPartnershipsCount** | **int** |  | [optional] [default to 0]
**orgInitiativeConnections** | **int** |  | [optional] [default to 0]
**totalActions** | **int** |  | [optional] [default to 0]
**firstActionDate** | [**DateTime**](DateTime.md) |  | [optional] 
**lastActionDate** | [**DateTime**](DateTime.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


