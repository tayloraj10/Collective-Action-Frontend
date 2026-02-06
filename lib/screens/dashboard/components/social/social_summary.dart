import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/initiative_action_card.dart';
import 'package:collective_action_frontend/screens/dashboard/components/summary_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:go_router/go_router.dart';

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

class SocialSummary extends ConsumerStatefulWidget {
  final IconData? icon;
  final Color? color;
  const SocialSummary({super.key, this.icon, this.color});

  @override
  ConsumerState<SocialSummary> createState() => _SocialSummaryState();
}

class _SocialSummaryState extends ConsumerState<SocialSummary> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final actionsAsync = ref.watch(activeActionProvider);
    final linkedIds = ref.watch(_initiativeLinkedIdsProvider);
    final initiativesMapAsync = linkedIds.isEmpty
        ? const AsyncValue.data(<String, InitiativeSchema>{})
        : ref.watch(initiativesByIdsProvider(linkedIds));
    final isMobile = AppConstants.isMobile(context);
    final cardColor = widget.color ?? Theme.of(context).colorScheme.primary;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Always show icon and title
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => context.go('/social'),
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 10 : 12),
                      decoration: BoxDecoration(
                        color: cardColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: isMobile ? 2 : 0),
                        child: Icon(
                          widget.icon ?? Icons.people_alt_rounded,
                          color: cardColor,
                          size: isMobile ? 20 : 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: isMobile
                                ? () => context.go('/social')
                                : null,
                            splashColor: isMobile
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withAlpha(30)
                                : null,
                            highlightColor: isMobile
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withAlpha(20)
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Social',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ),
                                  if (!isMobile) ...[
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () => AppConstants.openUrl(
                                        AppConstants.discordLink,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      child: Tooltip(
                                        message: 'Join our Discord community',
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Icon(
                                            Icons.discord,
                                            color: Colors.indigo,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (isMobile) ...[
                                    const SizedBox(width: 6),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface.withAlpha(18),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withAlpha(38),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.open_in_new,
                                          size: 14,
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.color
                                              ?.withAlpha(210),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (isMobile) ...[
                          const SizedBox(width: 2),
                          InkWell(
                            onTap: () =>
                                AppConstants.openUrl(AppConstants.discordLink),
                            borderRadius: BorderRadius.circular(16),
                            child: Tooltip(
                              message: 'Join our Discord community',
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.discord,
                                  color: Colors.indigo,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Show loading/error/data below
              Expanded(
                child: actionsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
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
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    return initiativesMapAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
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
                          widget.icon,
                          isMobile,
                          actions,
                          initiativesMap,
                          _scrollController,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
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
    ScrollController scrollController,
  ) {
    // Sort actions by most recent date
    final sortedActions = [...actions]
      ..sort((a, b) => b.date.compareTo(a.date));
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left-to-right, top-to-bottom layout for cards
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                controller: scrollController,
                child: SingleChildScrollView(
                  controller: scrollController,
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
                      return InitiativeActionCard(
                        action: action,
                        initiative: initiative,
                      );
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SummaryCount(count: actions.length, title: 'actions'),
          ],
        );
      },
    );
  }
}
