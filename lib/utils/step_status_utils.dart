import 'package:collective_action_frontend/api/lib/api.dart';

/// Logical display order for project step statuses (workflow order).
final stepStatusDisplayOrder = <StatusValuesEnum>[
  StatusValuesEnum.notStarted,
  StatusValuesEnum.inDevelopment,
  StatusValuesEnum.inProgress,
  StatusValuesEnum.inReview,
  StatusValuesEnum.blocked,
  StatusValuesEnum.completed,
  StatusValuesEnum.active,
  StatusValuesEnum.inactive,
];

/// Returns the sort index for a status name (lower = earlier in workflow).
int stepStatusOrderIndex(StatusValuesEnum name) {
  final i = stepStatusDisplayOrder.indexOf(name);
  return i >= 0 ? i : stepStatusDisplayOrder.length;
}

/// Sorts a list of [StatusSchema] by [stepStatusDisplayOrder].
List<StatusSchema> sortStepStatusesByOrder(List<StatusSchema> statuses) {
  final list = List<StatusSchema>.from(statuses);
  list.sort(
    (a, b) =>
        stepStatusOrderIndex(a.name).compareTo(stepStatusOrderIndex(b.name)),
  );
  return list;
}
