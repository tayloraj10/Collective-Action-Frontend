import 'dart:math' show max;

import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/providers/directory_of_good_provider.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/directory_of_good_action_card.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/initiative_action_card.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/map_submission_action_card.dart';
import 'package:collective_action_frontend/screens/dashboard/components/summary_count.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

// Provider to extract directory-of-good entry linkedIds from actions
final _directoryOfGoodLinkedIdsProvider = Provider.autoDispose<List<String>>((
  ref,
) {
  final actions = ref
      .watch(activeActionProvider)
      .maybeWhen(data: (actions) => actions, orElse: () => []);
  final dogActions = actions.where(
    (a) =>
        a.actionType == ActionTypeValuesEnum.directoryOfGoodAddition.value &&
        a.linkedId != null &&
        a.linkedId!.isNotEmpty,
  );
  final linkedIds = dogActions.map((a) => a.linkedId!).toSet().toList()..sort();
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
    final directoryLinkedIds = ref.watch(_directoryOfGoodLinkedIdsProvider);
    final directoryEntriesMapAsync = directoryLinkedIds.isEmpty
        ? const AsyncValue.data(<String, DirectoryOfGoodSchema>{})
        : ref.watch(directoryOfGoodEntriesByIdsProvider(directoryLinkedIds));
    final isMobile = AppConstants.isMobile(context);
    final cardColor = widget.color ?? Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  onTap: () => safeGo(context, '/social'),
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
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: isMobile
                              ? () => safeGo(context, '/social')
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
                                    child: Tooltip(
                                      message:
                                          'Recent actions taken across the app',
                                      child: Text(
                                        'Actions',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
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
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface.withAlpha(38),
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
                                size: 24,
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
                      return directoryEntriesMapAsync.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, stack) => Center(
                          child: Text(
                            'Failed to load directory entries',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        data: (directoryEntriesMap) => Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildSocialList(
                                context,
                                cardColor,
                                widget.icon,
                                isMobile,
                                actions,
                                initiativesMap,
                                directoryEntriesMap,
                                _scrollController,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SummaryCount(
                              count: actions.length,
                              title: 'recent activities',
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
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
    Map<String, DirectoryOfGoodSchema> directoryEntriesMap,
    ScrollController scrollController,
  ) {
    return buildSocialActivityList(
      context,
      cardColor,
      isMobile,
      actions,
      initiativesMap,
      directoryEntriesMap,
      scrollController,
    );
  }
}

/// Builds a single action card for the feed. Used by [buildSocialActivityList].
Widget _buildSocialActivityCard(
  ActionSchema action,
  Map<String, InitiativeSchema> initiativesMap,
  Map<String, DirectoryOfGoodSchema> directoryEntriesMap,
) {
  if (action.actionType == ActionTypeValuesEnum.mapSubmission.value) {
    return MapSubmissionActionCard(action: action);
  }
  if (action.actionType == ActionTypeValuesEnum.directoryOfGoodAddition.value) {
    final entry = action.linkedId != null
        ? directoryEntriesMap[action.linkedId!]
        : null;
    return DirectoryOfGoodActionCard(action: action, entry: entry);
  }
  InitiativeSchema? initiative;
  if (action.actionType == ActionTypeValuesEnum.initiative.value &&
      action.linkedId != null &&
      action.linkedId!.isNotEmpty) {
    initiative = initiativesMap[action.linkedId!];
  }
  return InitiativeActionCard(action: action, initiative: initiative);
}

/// Reusable feed of action cards (map submissions, initiatives, directory of good).
/// Used in [SocialSummary] and on the Social screen.
/// Desktop: Wrap layout so cards flow and take less vertical space.
/// Mobile: ListView.builder so only visible items are built (avoids scroll crashes).
Widget buildSocialActivityList(
  BuildContext context,
  Color cardColor,
  bool isMobile,
  List<ActionSchema> actions,
  Map<String, InitiativeSchema> initiativesMap,
  Map<String, DirectoryOfGoodSchema> directoryEntriesMap,
  ScrollController scrollController,
) {
  if (isMobile) {
    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        itemCount: actions.length,
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        itemBuilder: (context, index) {
          final action = actions[index];
          return RepaintBoundary(
            key: ValueKey<String>(action.id),
            child: _buildSocialActivityCard(
              action,
              initiativesMap,
              directoryEntriesMap,
            ),
          );
        },
      ),
    );
  }
  // Desktop: multi-column rows, built lazily (Wrap + List.generate built everything at once).
  return LayoutBuilder(
    builder: (context, constraints) {
      const double cardWidth = 180;
      const double gap = 4;
      final maxW = constraints.maxWidth;
      final cols = maxW <= 0
          ? 1
          : (max(1, ((maxW + gap) / (cardWidth + gap)).floor()));
      final rowCount = (actions.length + cols - 1) ~/ cols;

      return Scrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: ListView.builder(
          controller: scrollController,
          itemCount: rowCount,
          padding: const EdgeInsets.only(bottom: 8),
          itemBuilder: (context, rowIndex) {
            final start = rowIndex * cols;
            final end = start + cols > actions.length
                ? actions.length
                : start + cols;
            return Padding(
              padding: const EdgeInsets.only(bottom: gap),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = start; i < end; i++) ...[
                    if (i > start) SizedBox(width: gap),
                    RepaintBoundary(
                      key: ValueKey<String>(actions[i].id),
                      child: _buildSocialActivityCard(
                        actions[i],
                        initiativesMap,
                        directoryEntriesMap,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

/// Standalone activity feed for use on the Social page (right panel or tab).
class SocialActivityFeed extends ConsumerStatefulWidget {
  final ScrollController? scrollController;
  final String? title;

  const SocialActivityFeed({super.key, this.scrollController, this.title});

  @override
  ConsumerState<SocialActivityFeed> createState() => _SocialActivityFeedState();
}

class _SocialActivityFeedState extends ConsumerState<SocialActivityFeed> {
  ScrollController? _ownScrollController;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController == null) {
      _ownScrollController = ScrollController();
    }
  }

  @override
  void dispose() {
    _ownScrollController?.dispose();
    super.dispose();
  }

  ScrollController get _scrollController =>
      widget.scrollController ?? _ownScrollController!;

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final actionsAsync = ref.watch(activeActionProvider);
    final linkedIds = ref.watch(_initiativeLinkedIdsProvider);
    final initiativesMapAsync = linkedIds.isEmpty
        ? const AsyncValue.data(<String, InitiativeSchema>{})
        : ref.watch(initiativesByIdsProvider(linkedIds));
    final directoryLinkedIds = ref.watch(_directoryOfGoodLinkedIdsProvider);
    final directoryEntriesMapAsync = directoryLinkedIds.isEmpty
        ? const AsyncValue.data(<String, DirectoryOfGoodSchema>{})
        : ref.watch(directoryOfGoodEntriesByIdsProvider(directoryLinkedIds));
    final isMobile = AppConstants.isMobile(context);
    final cardColor = Theme.of(context).colorScheme.primary;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
        ],
        Expanded(
          child: actionsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text(
                'Failed to load activity',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
            data: (actions) {
              if (actions.isEmpty) {
                return Center(
                  child: Text(
                    'No recent activity.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                );
              }
              return initiativesMapAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Failed to load initiatives',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
                data: (initiativesMap) {
                  return directoryEntriesMapAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                      child: Text(
                        'Failed to load directory entries',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                    data: (directoryEntriesMap) => buildSocialActivityList(
                      context,
                      cardColor,
                      isMobile,
                      actions,
                      initiativesMap,
                      directoryEntriesMap,
                      _scrollController,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
