import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/providers/auth_provider.dart';
import 'package:collective_action_frontend/providers/connection_provider.dart';
import 'package:collective_action_frontend/providers/directory_of_good_provider.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/navigation_button.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int _kNetworkTopicPreviewLimit = 3;

enum _MobileNetworkListKind { initiatives, organizations }

class ActivityFeedSummary extends StatelessWidget {
  final IconData icon;
  final Color color;

  const ActivityFeedSummary({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = AppConstants.isMobile(context);
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 6 : 10,
          vertical: isMobile ? 3 : 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMobile) ...[
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => safeGo(context, '/social'),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => safeGo(context, '/social'),
                      splashColor: theme.colorScheme.primary.withAlpha(30),
                      highlightColor: theme.colorScheme.primary.withAlpha(20),
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
                                  'Community',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.onSurface.withAlpha(
                                    18,
                                  ),
                                  border: Border.all(
                                    color: theme.colorScheme.onSurface
                                        .withAlpha(38),
                                  ),
                                ),
                                child: Icon(
                                  Icons.open_in_new,
                                  size: 14,
                                  color: theme.textTheme.titleLarge?.color
                                      ?.withAlpha(210),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => safeGo(context, '/social'),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 26),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Community',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  NavigationButton(
                    icon: Icons.hub_outlined,
                    label: 'Network',
                    color: AppColors.statusInReview,
                    small: true,
                    onTap: () => safeGo(context, '/network'),
                  ),
                ],
              ),
            const SizedBox(height: 7),
            const Expanded(child: _CommunityNetworkPanel()),
          ],
        ),
      ),
    );
  }
}

class _CommunityNetworkPanel extends ConsumerWidget {
  const _CommunityNetworkPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isMobile = AppConstants.isMobile(context);

    final dogSummariesAsync = ref.watch(
      connectionSummaryProvider('directory_of_good'),
    );
    final initSummariesAsync = ref.watch(
      connectionSummaryProvider('initiative'),
    );
    final dogs = ref.watch(directoryOfGoodEntriesProvider).value ?? [];
    final initiatives = ref.watch(activeInitiativeProvider).value ?? [];
    final myConnections = ref.watch(myConnectionsProvider).value ?? [];
    final isLoggedIn = ref.watch(authStateProvider).value != null;

    if (dogSummariesAsync.isLoading || initSummariesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (dogSummariesAsync.hasError || initSummariesAsync.hasError) {
      return Center(
        child: Text(
          'Community network data unavailable',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      );
    }

    final dogSummaries =
        dogSummariesAsync.value ?? <String, ConnectionSummarySchema>{};
    final initSummaries =
        initSummariesAsync.value ?? <String, ConnectionSummarySchema>{};

    final allSummaries = [...dogSummaries.values, ...initSummaries.values];
    final globalTotal = allSummaries.fold<int>(
      0,
      (sum, s) => sum + s.totalCount,
    );
    final globalPeople = allSummaries.fold<int>(
      0,
      (sum, s) => sum + s.userCount,
    );
    final globalOrgs = allSummaries.fold<int>(0, (sum, s) => sum + s.orgCount);

    final nameByDogId = <String, String>{
      for (final dog in dogs)
        if (dog.id != null && dog.id!.isNotEmpty) dog.id!: dog.name,
    };
    final nameByInitId = <String, String>{
      for (final initiative in initiatives) initiative.id: initiative.title,
    };

    final rows = <_SummaryRow>[
      ...dogSummaries.entries.map(
        (entry) => _SummaryRow(
          name: nameByDogId[entry.key] ?? 'Directory entry',
          type: 'directory',
          totalCount: entry.value.totalCount,
          userCount: entry.value.userCount,
          orgCount: entry.value.orgCount,
        ),
      ),
      ...initSummaries.entries.map(
        (entry) => _SummaryRow(
          name: nameByInitId[entry.key] ?? 'Initiative',
          type: 'initiative',
          totalCount: entry.value.totalCount,
          userCount: entry.value.userCount,
          orgCount: entry.value.orgCount,
        ),
      ),
    ]..sort((a, b) => b.totalCount.compareTo(a.totalCount));

    final initiativeRows = rows.where((r) => r.type == 'initiative').toList();
    final directoryRows = rows.where((r) => r.type == 'directory').toList();

    final topInitiatives = initiativeRows
        .take(_kNetworkTopicPreviewLimit)
        .toList();
    final topOrganizations = directoryRows
        .take(_kNetworkTopicPreviewLimit)
        .toList();
    final moreInitiatives = initiativeRows.length - topInitiatives.length;
    final moreOrganizations = directoryRows.length - topOrganizations.length;

    // Mobile first tile doubles as Network navigation (tap opens graph).
    const statTileHeight = 52.0;
    final statGap = isMobile ? 3.0 : 5.0;

    final scrollChildren = <Widget>[
      Row(
        children: [
          Expanded(
            child: SizedBox(
              height: statTileHeight,
              child: _MobileStatTile(
                value: '$globalTotal',
                icon: Icons.hub_outlined,
                tier: _StatTier.primary,
                label: isMobile ? null : 'Network links',
                tooltip:
                    '$globalTotal links across initiatives and organizations on this network',
                onTap: isMobile ? () => safeGo(context, '/network') : null,
                brandColor: isMobile ? AppColors.statusInReview : null,
              ),
            ),
          ),
          SizedBox(width: statGap),
          Expanded(
            child: SizedBox(
              height: statTileHeight,
              child: _MobileStatTile(
                value: '$globalPeople',
                icon: Icons.person_outline,
                tier: _StatTier.nested,
                label: isMobile ? null : 'People links',
                tooltip:
                    '$globalPeople links where an individual member is connected to an initiative or organization',
              ),
            ),
          ),
          SizedBox(width: statGap),
          Expanded(
            child: SizedBox(
              height: statTileHeight,
              child: _MobileStatTile(
                value: '$globalOrgs',
                icon: Icons.business_outlined,
                tier: _StatTier.nested,
                label: isMobile ? null : 'Org links',
                tooltip:
                    '$globalOrgs links where an organization is connected to an initiative or partner listing',
              ),
            ),
          ),
          if (isLoggedIn) ...[
            SizedBox(width: statGap),
            Expanded(
              child: SizedBox(
                height: statTileHeight,
                child: _MobileStatTile(
                  value: '${myConnections.length}',
                  icon: Icons.account_tree_outlined,
                  tier: _StatTier.standard,
                  label: isMobile ? null : 'Your links',
                  tooltip:
                      '${myConnections.length} links you have added from your account',
                ),
              ),
            ),
          ],
        ],
      ),
      const SizedBox(height: 7),
      if (rows.isEmpty)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(90),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor.withAlpha(100)),
          ),
          child: Text(
            'No network activity yet.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(170),
            ),
          ),
        )
      else if (isMobile)
        _MobileNetworkTopicsSwitcher(
          topInitiatives: topInitiatives,
          topOrganizations: topOrganizations,
          moreInitiatives: moreInitiatives,
          moreOrganizations: moreOrganizations,
        )
      else
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _NetworkTopicCard(
                title: 'Network: Initiatives',
                icon: Icons.trending_up,
                rows: topInitiatives,
                moreCount: moreInitiatives,
                moreSingularNoun: 'initiative',
                morePluralNoun: 'initiatives',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _NetworkTopicCard(
                title: 'Network: Organizations',
                icon: Icons.menu_book_rounded,
                rows: topOrganizations,
                moreCount: moreOrganizations,
                moreSingularNoun: 'organization',
                morePluralNoun: 'organizations',
              ),
            ),
          ],
        ),
      const SizedBox(height: 5),
    ];

    // Single scroll surface for stats + network lists + roadmap so nothing
    // stacks over the network section when vertical space is tight.
    return ListView(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        ...scrollChildren,
        const SizedBox(height: 6),
        _CommunityRoadmapSection(isMobile: isMobile),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// Goals / Paths / Events placeholders. Mobile: one “Coming soon” above the row.
/// Desktop: each card shows “Coming soon” in its top row.
class _CommunityRoadmapSection extends StatelessWidget {
  final bool isMobile;

  const _CommunityRoadmapSection({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final comingSoonStyle = theme.textTheme.labelSmall?.copyWith(
      color: primary.withAlpha(195),
      fontWeight: FontWeight.w700,
      fontSize: 11,
      letterSpacing: 0.35,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMobile) ...[
          Text('Coming soon', style: comingSoonStyle),
          const SizedBox(height: 6),
        ],
        _CommunityRoadmapCardsStrip(isMobile: isMobile),
      ],
    );
  }
}

/// Placeholder strip for upcoming Goals / Paths / Events on Community.
class _CommunityRoadmapCardsStrip extends StatelessWidget {
  final bool isMobile;

  const _CommunityRoadmapCardsStrip({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final hGap = isMobile ? 4.0 : 10.0;

    Widget hGapBox() => SizedBox(width: hGap);

    final cards = [
      _RoadmapMiniCard(
        compactStrip: isMobile,
        title: 'Goals',
        subtitle: isMobile ? 'Outcomes & targets' : 'Shared outcomes & targets',
        icon: Icons.flag_outlined,
      ),
      _RoadmapMiniCard(
        compactStrip: isMobile,
        title: 'Paths',
        subtitle: isMobile ? 'Growth tracks' : 'Personal growth tracks',
        icon: Icons.alt_route_rounded,
      ),
      _RoadmapMiniCard(
        compactStrip: isMobile,
        title: 'Events',
        subtitle: isMobile
            ? 'Meetups & mobilizing'
            : 'Gatherings & mobilization',
        icon: Icons.event_outlined,
      ),
    ];

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: cards[0]),
        hGapBox(),
        Expanded(child: cards[1]),
        hGapBox(),
        Expanded(child: cards[2]),
      ],
    );

    // Mobile: bounded height inside scroll view (see _CommunityNetworkPanel ListView).
    if (isMobile) {
      final sh = MediaQuery.sizeOf(context).shortestSide;
      final stripHeight = (sh * 0.29).clamp(106.0, 122.0);
      return SizedBox(height: stripHeight, child: row);
    }

    // Desktop: row height = tallest card; siblings stretch to match via Row.stretch.
    return IntrinsicHeight(child: row);
  }
}

class _RoadmapMiniCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  /// Mobile: narrow column with icon + title + subtitle stacked (horizontal strip of three).
  final bool compactStrip;

  const _RoadmapMiniCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.compactStrip = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final muted = theme.colorScheme.onSurface.withAlpha(
      compactStrip ? 148 : 158,
    );
    final radius = BorderRadius.circular(compactStrip ? 10 : 12);

    final decor = BoxDecoration(
      borderRadius: radius,
      color: theme.colorScheme.surfaceContainerHighest.withAlpha(
        compactStrip ? 68 : 72,
      ),
      border: Border.all(
        color: theme.dividerColor.withAlpha(compactStrip ? 88 : 95),
      ),
    );

    if (compactStrip) {
      return DecoratedBox(
        decoration: decor,
        child: ClipRRect(
          borderRadius: radius,
          child: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(7, 7, 7, 7),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primary.withAlpha(22),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        size: 18,
                        color: primary.withAlpha(235),
                      ),
                    ),
                    const SizedBox(height: 6),
                    LayoutBuilder(
                      builder: (context, box) {
                        final titleStyle = theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.15,
                          height: 1.15,
                          fontSize: 12.5,
                        );
                        final subStyle = theme.textTheme.labelSmall?.copyWith(
                          color: muted,
                          height: 1.2,
                          fontWeight: FontWeight.w500,
                          fontSize: 9,
                        );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: box.maxWidth,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.clip,
                                  style: titleStyle,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            SizedBox(
                              width: box.maxWidth,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.topLeft,
                                child: SizedBox(
                                  width: box.maxWidth,
                                  child: Text(
                                    subtitle,
                                    maxLines: 4,
                                    softWrap: true,
                                    overflow: TextOverflow.clip,
                                    style: subStyle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: decor,
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(11, 10, 11, 9),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(icon, size: 24, color: primary.withAlpha(235)),
                      const Spacer(),
                      Text(
                        'Coming soon',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: primary.withAlpha(195),
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          letterSpacing: 0.35,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.25,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: muted,
                      height: 1.28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileNetworkTopicsSwitcher extends StatefulWidget {
  final List<_SummaryRow> topInitiatives;
  final List<_SummaryRow> topOrganizations;
  final int moreInitiatives;
  final int moreOrganizations;

  const _MobileNetworkTopicsSwitcher({
    required this.topInitiatives,
    required this.topOrganizations,
    required this.moreInitiatives,
    required this.moreOrganizations,
  });

  @override
  State<_MobileNetworkTopicsSwitcher> createState() =>
      _MobileNetworkTopicsSwitcherState();
}

class _MobileNetworkTopicsSwitcherState
    extends State<_MobileNetworkTopicsSwitcher> {
  /// Mobile defaults to organizations to save vertical space.
  _MobileNetworkListKind _kind = _MobileNetworkListKind.organizations;

  void _toggleKind() {
    setState(() {
      _kind = _kind == _MobileNetworkListKind.initiatives
          ? _MobileNetworkListKind.organizations
          : _MobileNetworkListKind.initiatives;
    });
  }

  @override
  Widget build(BuildContext context) {
    final initiatives = _kind == _MobileNetworkListKind.initiatives;
    final switchTooltip = initiatives
        ? 'Switch to organizations'
        : 'Switch to initiatives';

    return _NetworkTopicCard(
      title: initiatives ? 'Initiatives' : 'Organizations',
      icon: initiatives ? Icons.trending_up : Icons.menu_book_rounded,
      rows: initiatives ? widget.topInitiatives : widget.topOrganizations,
      moreCount: initiatives
          ? widget.moreInitiatives
          : widget.moreOrganizations,
      moreSingularNoun: initiatives ? 'initiative' : 'organization',
      morePluralNoun: initiatives ? 'initiatives' : 'organizations',
      titleTrailing: IconButton.filledTonal(
        onPressed: _toggleKind,
        icon: const Icon(Icons.swap_horiz_rounded, size: 17),
        tooltip: switchTooltip,
        visualDensity: VisualDensity.compact,
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: const Size(28, 28),
          fixedSize: const Size(28, 28),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _NetworkTopicCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_SummaryRow> rows;
  final int moreCount;
  final String moreSingularNoun;
  final String morePluralNoun;

  /// Shown after the title (e.g. mobile list-type toggle).
  final Widget? titleTrailing;

  const _NetworkTopicCard({
    required this.title,
    required this.icon,
    required this.rows,
    this.moreCount = 0,
    required this.moreSingularNoun,
    required this.morePluralNoun,
    this.titleTrailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final moreTooltip = moreCount > 0
        ? '${moreCount == 1 ? '1 more entry' : '$moreCount more entries'} '
              '(${moreCount == 1 ? moreSingularNoun : morePluralNoun})'
        : '';

    final header = titleTrailing != null
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: primary),
              const SizedBox(width: 8),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    maxLines: 1,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              titleTrailing!,
            ],
          )
        : Row(
            children: [
              Icon(icon, size: 18, color: primary),
              const SizedBox(width: 8),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    maxLines: 1,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          );

    final listSection = rows.isEmpty
        ? Text('No entries yet.', style: theme.textTheme.bodySmall)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...rows.map(
                (row) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          row.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${row.totalCount}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (moreCount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Tooltip(
                    message: moreTooltip,
                    child: Text(
                      '+$moreCount',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: primary.withAlpha(200),
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        height: 1.1,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
            ],
          );

    return Container(
      padding: const EdgeInsets.fromLTRB(9, 8, 9, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(75),
        border: Border.all(color: theme.dividerColor.withAlpha(110)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [header, const SizedBox(height: 6), listSection],
      ),
    );
  }
}

/// [primary] = total (network links); [nested] = parts that roll up into it;
/// [standard] = standalone (e.g. your links).
enum _StatTier { primary, nested, standard }

/// Mobile: icon above value (saves horizontal space). Desktop: optional [label]
/// with icon beside value + caption. Tap shows tooltip via [TooltipState], or
/// runs [onTap] when set (e.g. Network navigation — use long press for tooltip).
class _MobileStatTile extends StatefulWidget {
  final String value;
  final IconData icon;
  final String tooltip;
  final _StatTier tier;

  /// Shown under [value] when non-null (typically desktop only).
  final String? label;

  /// When non-null, tap invokes this instead of showing the tooltip (tooltip:
  /// long-press).
  final VoidCallback? onTap;

  /// Accent for icon/border (e.g. Network tile matching app purple).
  final Color? brandColor;

  const _MobileStatTile({
    required this.value,
    required this.icon,
    required this.tooltip,
    this.tier = _StatTier.standard,
    this.label,
    this.onTap,
    this.brandColor,
  });

  @override
  State<_MobileStatTile> createState() => _MobileStatTileState();
}

class _MobileStatTileState extends State<_MobileStatTile> {
  final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = widget.brandColor ?? theme.colorScheme.primary;

    late final double iconSize;
    late final TextStyle valueStyle;
    late final int fillAlpha;
    late final int borderAlpha;
    late final double borderWidth;

    final hasLabel = widget.label != null;

    switch (widget.tier) {
      case _StatTier.primary:
        iconSize = hasLabel ? 20 : 18;
        valueStyle = (theme.textTheme.titleMedium ?? const TextStyle())
            .copyWith(fontWeight: FontWeight.w800, height: 1.0);
        fillAlpha = 22;
        borderAlpha = 100;
        borderWidth = 1.5;
      case _StatTier.nested:
        iconSize = hasLabel ? 16 : 15;
        valueStyle = (theme.textTheme.titleSmall ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.w800,
          height: 1.0,
        );
        fillAlpha = 10;
        borderAlpha = 44;
        borderWidth = 1;
      case _StatTier.standard:
        iconSize = hasLabel ? 16 : 15;
        valueStyle = (theme.textTheme.titleSmall ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.w800,
          height: 1.0,
        );
        fillAlpha = 16;
        borderAlpha = 62;
        borderWidth = 1.25;
    }

    final labelStyle = (theme.textTheme.labelSmall ?? const TextStyle())
        .copyWith(
          color: theme.colorScheme.onSurface.withAlpha(175),
          height: 1.1,
          fontWeight: FontWeight.w500,
        );

    Widget content;
    if (hasLabel) {
      content = Padding(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(widget.icon, size: iconSize, color: accent),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: valueStyle,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.label!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: labelStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Icon above value — narrow tiles stay readable when four stats share a row.
      final gapIconToValue = widget.tier == _StatTier.primary ? 3.0 : 2.0;
      content = Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: iconSize, color: accent),
              SizedBox(height: gapIconToValue),
              Text(
                widget.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: valueStyle,
              ),
            ],
          ),
        ),
      );
    }

    return Tooltip(
      key: _tooltipKey,
      message: widget.tooltip,
      triggerMode: widget.onTap != null
          ? TooltipTriggerMode.longPress
          : TooltipTriggerMode.manual,
      waitDuration: Duration.zero,
      showDuration: const Duration(seconds: 3),
      child: Material(
        color: accent.withAlpha(fillAlpha),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap:
              widget.onTap ??
              () => _tooltipKey.currentState?.ensureTooltipVisible(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: accent.withAlpha(borderAlpha),
                width: borderWidth,
              ),
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

class _SummaryRow {
  final String name;
  final String type;
  final int totalCount;
  final int userCount;
  final int orgCount;

  const _SummaryRow({
    required this.name,
    required this.type,
    required this.totalCount,
    required this.userCount,
    required this.orgCount,
  });
}
