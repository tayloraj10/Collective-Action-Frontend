import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows a list of the current user's map submissions (cleanups, trash reports),
/// excluding [excludeActionId], sorted by date descending. Use inside info dialogs.
class YourSubmissionsList extends ConsumerWidget {
  const YourSubmissionsList({
    super.key,
    this.excludeActionId,
    this.maxItems = 15,
  });

  final String? excludeActionId;
  final int maxItems;

  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String _formatDate(DateTime d) {
    return '${_monthNames[d.month - 1]} ${d.day}, ${d.year}';
  }

  static String _titleForAction(ActionSchema action) {
    final eventData = action.eventData;
    if (eventData == null || eventData.isEmpty) return 'Map Submission';
    final type = eventData['type']?.toString();
    if (type == EventDataType.cleanup.value) {
      final name = eventData['name']?.toString().trim();
      final location = eventData['location']?.toString().trim();
      if (name != null && name.isNotEmpty) return 'Cleanup: $name';
      if (location != null && location.isNotEmpty) return 'Cleanup: $location';
      return 'Cleanup';
    }
    if (type == EventDataType.trashReport.value) {
      final location = eventData['location']?.toString().trim();
      if (location != null && location.isNotEmpty) {
        return 'Trash Report: $location';
      }
      return 'Trash Report';
    }
    if (type == EventDataType.cleanupRoute.value) return 'Cleanup Route';
    if (type == EventDataType.treePlanting.value ||
        type == EventDataType.wildflowerPlanting.value) {
      final species = eventData['species']?.toString().trim();
      final location = eventData['location']?.toString().trim();
      final prefix = type == EventDataType.treePlanting.value
          ? 'Tree Planting'
          : 'Wildflower Planting';
      if (species != null && species.isNotEmpty) return '$prefix: $species';
      if (location != null && location.isNotEmpty) return '$prefix: $location';
      return prefix;
    }
    return type ?? 'Map Submission';
  }

  static IconData _iconForAction(ActionSchema action) {
    final eventData = action.eventData;
    if (eventData == null) return Icons.place;
    final type = eventData['type']?.toString();
    if (type == EventDataType.cleanup.value) return Icons.cleaning_services;
    if (type == EventDataType.trashReport.value) return Icons.delete_outline;
    if (type == EventDataType.treePlanting.value) return Icons.park;
    if (type == EventDataType.wildflowerPlanting.value) {
      return Icons.local_florist;
    }
    return Icons.place;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    if (currentUser == null) return const SizedBox.shrink();

    final actionsAsync = ref.watch(activeActionProvider);
    return actionsAsync.when(
      data: (allActions) {
        final mine =
            allActions
                .where(
                  (a) =>
                      a.actionType ==
                          ActionTypeValuesEnum.mapSubmission.value &&
                      a.userId == currentUser.id &&
                      a.id != excludeActionId,
                )
                .toList()
              ..sort((a, b) => b.date.compareTo(a.date));
        final list = mine.take(maxItems).toList();
        if (list.isEmpty) return const SizedBox.shrink();

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.list_alt,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Your submissions',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...list.map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _iconForAction(a),
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _titleForAction(a),
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(a.date),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
