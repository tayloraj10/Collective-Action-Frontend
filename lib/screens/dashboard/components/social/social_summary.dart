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

  Widget _buildGradientHeader(BuildContext context, bool isMobile) {
    final cardColor = widget.color ?? Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradStart = isDark
        ? Color.lerp(cardColor, Colors.black, 0.45)!
        : const Color(0xFF7C2D12);
    final gradEnd = isDark
        ? Color.lerp(cardColor, Colors.black, 0.15)!
        : cardColor;

    return InkWell(
      onTap: () => safeGo(context, '/social'),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(14, isMobile ? 9 : 12, 14, isMobile ? 9 : 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradStart, gradEnd],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 5 : 7),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(38),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                widget.icon ?? Icons.people_alt_rounded,
                color: Colors.white,
                size: isMobile ? 17 : 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Action',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: isMobile ? 14 : 16,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (!isMobile)
                    Text(
                      'Recent activity feed',
                      style: TextStyle(
                        color: Colors.white.withAlpha(210),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                ],
              ),
            ),
            if (!isMobile) ...[
              InkWell(
                onTap: () => AppConstants.openUrl(AppConstants.discordLink),
                borderRadius: BorderRadius.circular(20),
                child: Tooltip(
                  message: 'Join our Discord community',
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(35),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withAlpha(80)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.discord, color: Colors.white, size: 13),
                        const SizedBox(width: 4),
                        Text(
                          'Discord',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ] else ...[
              InkWell(
                onTap: () => AppConstants.openUrl(AppConstants.discordLink),
                borderRadius: BorderRadius.circular(16),
                child: Tooltip(
                  message: 'Join our Discord community',
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.discord, color: Colors.white, size: 18),
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withAlpha(200),
              size: 18,
            ),
          ],
        ),
      ),
    );
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGradientHeader(context, isMobile),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 8 : 10,
                isMobile ? 6 : 8,
                isMobile ? 8 : 10,
                isMobile ? 4 : 6,
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
          ),
        ],
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
  Map<String, DirectoryOfGoodSchema> directoryEntriesMap, {
  bool feedMode = false,
}) {
  if (action.actionType == ActionTypeValuesEnum.mapSubmission.value) {
    return MapSubmissionActionCard(action: action, feedMode: feedMode);
  }
  if (action.actionType == ActionTypeValuesEnum.directoryOfGoodAddition.value) {
    final entry = action.linkedId != null
        ? directoryEntriesMap[action.linkedId!]
        : null;
    return DirectoryOfGoodActionCard(action: action, entry: entry, feedMode: feedMode);
  }
  InitiativeSchema? initiative;
  if (action.actionType == ActionTypeValuesEnum.initiative.value &&
      action.linkedId != null &&
      action.linkedId!.isNotEmpty) {
    initiative = initiativesMap[action.linkedId!];
  }
  return InitiativeActionCard(action: action, initiative: initiative, feedMode: feedMode);
}

/// Reusable feed of action cards (map submissions, initiatives, directory of good).
/// Used in [SocialSummary] and on the Social screen.
/// feedMode: vertical list with full-width timeline cards (used on the /social page).
/// !feedMode desktop: multi-column grid with compact cards (used in dashboard summary).
/// Mobile always uses a vertical list.
Widget buildSocialActivityList(
  BuildContext context,
  Color cardColor,
  bool isMobile,
  List<ActionSchema> actions,
  Map<String, InitiativeSchema> initiativesMap,
  Map<String, DirectoryOfGoodSchema> directoryEntriesMap,
  ScrollController scrollController, {
  bool feedMode = false,
}) {
  if (isMobile || feedMode) {
    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        itemCount: actions.length,
        padding: feedMode ? const EdgeInsets.only(bottom: 8) : EdgeInsets.zero,
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
              feedMode: feedMode,
            ),
          );
        },
      ),
    );
  }
  // Dashboard desktop: multi-column compact grid.
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
                      feedMode: true,
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
