import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/action_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';

// Provider to extract stable, sorted initiative linkedIds from actions
final _initiativeLinkedIdsProvider = Provider.autoDispose<List<String>>((ref) {
  final actions = ref
      .watch(activeActionProvider)
      .maybeWhen(data: (actions) => actions, orElse: () => []);
  final initiativeActions = actions.where(
    (a) =>
        a.actionType == ActionTypeValuesEnum.initiative.value &&
        a.linkedId != null &&
        a.linkedId!.isNotEmpty,
  );
  final linkedIds = initiativeActions.map((a) => a.linkedId!).toSet().toList()
    ..sort();
  return List.unmodifiable(linkedIds);
});

class SocialSummary extends ConsumerWidget {
  final IconData? icon;
  final Color? color;
  const SocialSummary({super.key, this.icon, this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionsAsync = ref.watch(activeActionProvider);
    final linkedIds = ref.watch(_initiativeLinkedIdsProvider);
    final initiativesMapAsync = linkedIds.isEmpty
        ? const AsyncValue.data(<String, InitiativeSchema>{})
        : ref.watch(initiativesByIdsProvider(linkedIds));
    final isMobile = AppConstants.isMobile(context);
    final cardColor = color ?? Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 6 : 10,
            vertical: isMobile ? 4 : 6,
          ),
          child: actionsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text(
                'Failed to load social activity',
                style: TextStyle(color: Colors.red),
              ),
            ),
            data: (actions) {
              if (actions.isEmpty) {
                return Center(
                  child: Text(
                    'No recent social activity.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                );
              }
              return initiativesMapAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text(
                    'Failed to load initiatives',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                data: (initiativesMap) {
                  return _buildSocialList(
                    context,
                    cardColor,
                    icon,
                    isMobile,
                    actions,
                    initiativesMap,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSocialList(
    BuildContext context,
    Color cardColor,
    IconData? icon,
    bool isMobile,
    List<ActionSchema> actions,
    Map<String, InitiativeSchema> initiativesMap,
  ) {
    // Sort actions by most recent date
    final sortedActions = [...actions]
      ..sort((a, b) => b.date.compareTo(a.date));
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon ?? Icons.people_alt_rounded,
                    color: cardColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Social',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Left-to-right, top-to-bottom layout for cards
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 0,
                    runSpacing: 0,
                    children: List.generate(sortedActions.length, (idx) {
                      final action = sortedActions[idx];
                      InitiativeSchema? initiative;
                      if (action.actionType ==
                              ActionTypeValuesEnum.initiative.value &&
                          action.linkedId != null &&
                          action.linkedId!.isNotEmpty) {
                        initiative = initiativesMap[action.linkedId!];
                      }
                      return ActionCard(action: action, initiative: initiative);
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
