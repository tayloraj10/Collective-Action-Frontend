import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/providers/auth_provider.dart';
import 'package:collective_action_frontend/providers/connection_provider.dart';
import 'package:collective_action_frontend/providers/directory_of_good_provider.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
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

  Widget _buildGradientHeader(BuildContext context, bool isMobile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradStart = isDark
        ? Color.lerp(color, Colors.black, 0.45)!
        : const Color(0xFF7C3AED);
    final gradEnd = isDark ? Color.lerp(color, Colors.black, 0.15)! : color;

    return InkWell(
      onTap: () => safeGo(context, '/network'),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          14,
          isMobile ? 9 : 12,
          14,
          isMobile ? 9 : 12,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradStart, gradEnd],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
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
              child: Icon(icon, color: Colors.white, size: isMobile ? 17 : 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Community',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: isMobile ? 14 : 16,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (!isMobile)
                    Text(
                      'Your network of change',
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
                onTap: () => safeGo(context, '/network'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(35),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withAlpha(80)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.hub_outlined, color: Colors.white, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        'Network',
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
              const SizedBox(width: 8),
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
    final isMobile = AppConstants.isMobile(context);

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
                isMobile ? 5 : 7,
                isMobile ? 8 : 10,
                isMobile ? 4 : 6,
              ),
              child: const _CommunityNetworkPanel(),
            ),
          ),
        ],
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

    final statTileHeight = isMobile ? 52.0 : 64.0;
    final statGap = isMobile ? 3.0 : 6.0;
    const communityAccent = AppColors.statusInReview;

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
                onTap: () => safeGo(context, '/network'),
                brandColor: communityAccent,
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
                label: isMobile ? null : 'People',
                tooltip:
                    '$globalPeople individual member connections across the network',
                brandColor: communityAccent,
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
                label: isMobile ? null : 'Orgs',
                tooltip:
                    '$globalOrgs organization connections across the network',
                brandColor: communityAccent,
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
                  label: isMobile ? null : 'Mine',
                  tooltip:
                      '${myConnections.length} connections you have added from your account',
                  brandColor: communityAccent,
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
                title: 'Organizations',
                icon: Icons.menu_book_rounded,
                accentColor: AppColors.warningOrange,
                rows: topOrganizations,
                moreCount: moreOrganizations,
                moreSingularNoun: 'organization',
                morePluralNoun: 'organizations',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _NetworkTopicCard(
                title: 'Initiatives',
                icon: Icons.trending_up,
                accentColor: AppColors.lightBlue,
                rows: topInitiatives,
                moreCount: moreInitiatives,
                moreSingularNoun: 'initiative',
                morePluralNoun: 'initiatives',
              ),
            ),
          ],
        ),
      const SizedBox(height: 5),
    ];

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

/// Challenges / Paths / Events placeholders — Coming soon pill on each card.
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

/// Placeholder strip for upcoming Challenges / Paths / Events on Community.
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
        title: 'Challenges',
        subtitle: isMobile
            ? 'Daily goals & competitions'
            : 'Community driven daily goals',
        icon: Icons.flag_rounded,
        accentColor: const Color(0xFF0EA5E9),
      ),
      _RoadmapMiniCard(
        compactStrip: isMobile,
        title: 'Paths',
        subtitle: isMobile ? 'Growth tracks' : 'Personal growth tracks',
        icon: Icons.alt_route_rounded,
        accentColor: const Color(0xFF14B8A6),
      ),
      _RoadmapMiniCard(
        compactStrip: isMobile,
        title: 'Events',
        subtitle: isMobile
            ? 'Meetups & mobilizing'
            : 'Gatherings & mobilization',
        icon: Icons.event_rounded,
        accentColor: const Color(0xFFF59E0B),
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
  final Color accentColor;

  /// Mobile: narrow column with icon + title + subtitle stacked (horizontal strip of three).
  final bool compactStrip;

  const _RoadmapMiniCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.compactStrip = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final muted = theme.colorScheme.onSurface.withAlpha(
      compactStrip ? 148 : 160,
    );
    final radius = BorderRadius.circular(compactStrip ? 10 : 12);

    final gradDecor = BoxDecoration(
      borderRadius: radius,
      gradient: LinearGradient(
        colors: [
          accentColor.withAlpha(isDark ? 55 : 45),
          accentColor.withAlpha(isDark ? 22 : 14),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: accentColor.withAlpha(isDark ? 100 : 75)),
    );

    if (compactStrip) {
      return ClipRRect(
        borderRadius: radius,
        child: DecoratedBox(
          decoration: gradDecor,
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
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: accentColor.withAlpha(isDark ? 60 : 40),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(icon, size: 16, color: accentColor),
                    ),
                    const SizedBox(height: 5),
                    LayoutBuilder(
                      builder: (context, box) {
                        final titleStyle = theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.15,
                          height: 1.15,
                          fontSize: 12.5,
                          color: theme.colorScheme.onSurface,
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

    return ClipRRect(
      borderRadius: radius,
      child: DecoratedBox(
        decoration: gradDecor,
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: accentColor.withAlpha(isDark ? 65 : 45),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, size: 18, color: accentColor),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withAlpha(isDark ? 50 : 30),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: accentColor.withAlpha(isDark ? 100 : 80),
                          ),
                        ),
                        child: Text(
                          'Coming soon',
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.25,
                      height: 1.12,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: muted,
                      height: 1.28,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
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
  /// Default to organizations — typically higher connection counts.
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
      accentColor: initiatives ? AppColors.lightBlue : AppColors.warningOrange,
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
  final Color accentColor;
  final List<_SummaryRow> rows;
  final int moreCount;
  final String moreSingularNoun;
  final String morePluralNoun;

  /// Shown after the title (e.g. mobile list-type toggle).
  final Widget? titleTrailing;

  const _NetworkTopicCard({
    required this.title,
    required this.icon,
    this.accentColor = AppColors.statusInReview,
    required this.rows,
    this.moreCount = 0,
    required this.moreSingularNoun,
    required this.morePluralNoun,
    this.titleTrailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = AppConstants.isMobile(context);
    final primary = accentColor;
    final moreTooltip = moreCount > 0
        ? '${moreCount == 1 ? '1 more entry' : '$moreCount more entries'} '
              '(${moreCount == 1 ? moreSingularNoun : morePluralNoun})'
        : '';

    final iconWidget = Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: primary.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 14, color: primary),
    );

    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        iconWidget,
        const SizedBox(width: 5),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (!isMobile)
                  TextSpan(
                    text: '  ·  by connections',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withAlpha(110),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (titleTrailing != null) titleTrailing!,
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
                      Container(
                        width: 4,
                        height: 14,
                        decoration: BoxDecoration(
                          color: primary.withAlpha(160),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          row.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withAlpha(220),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Tooltip(
                        message:
                            '${row.totalCount} network connection${row.totalCount == 1 ? '' : 's'}',
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: primary.withAlpha(60),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${row.totalCount}',
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (moreCount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 1, left: 11),
                  child: Tooltip(
                    message: moreTooltip,
                    child: Text(
                      '+$moreCount more',
                      style: TextStyle(
                        color: primary.withAlpha(160),
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
            ],
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(75),
          border: Border.all(color: theme.dividerColor.withAlpha(110)),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(color: primary.withAlpha(200)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(9, 8, 5, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [header, const SizedBox(height: 7), listSection],
                  ),
                ),
              ),
            ],
          ),
        ),
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
    final isPrimary = widget.tier == _StatTier.primary;

    switch (widget.tier) {
      case _StatTier.primary:
        iconSize = hasLabel ? 22 : 18;
        valueStyle = (theme.textTheme.titleLarge ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.w900,
          height: 1.0,
          color: accent,
          fontSize: hasLabel ? null : 18,
        );
        fillAlpha = 30;
        borderAlpha = 130;
        borderWidth = 1.8;
      case _StatTier.nested:
        iconSize = hasLabel ? 16 : 15;
        valueStyle = (theme.textTheme.titleSmall ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.w800,
          height: 1.0,
          color: accent.withAlpha(220),
        );
        fillAlpha = 12;
        borderAlpha = 50;
        borderWidth = 1;
      case _StatTier.standard:
        iconSize = hasLabel ? 16 : 15;
        valueStyle = (theme.textTheme.titleSmall ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.w800,
          height: 1.0,
          color: accent.withAlpha(220),
        );
        fillAlpha = 18;
        borderAlpha = 70;
        borderWidth = 1.25;
    }

    final labelStyle = (theme.textTheme.labelSmall ?? const TextStyle())
        .copyWith(
          color: theme.colorScheme.onSurface.withAlpha(isPrimary ? 200 : 160),
          height: 1.1,
          fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
          fontSize: isPrimary ? 11 : null,
        );

    Widget content;
    if (hasLabel) {
      final iconWidget = isPrimary
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accent.withAlpha(28),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(widget.icon, size: iconSize, color: accent),
            )
          : Icon(widget.icon, size: iconSize, color: accent.withAlpha(200));

      content = Padding(
        padding: EdgeInsets.fromLTRB(isPrimary ? 10 : 8, 6, 8, 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconWidget,
            SizedBox(width: isPrimary ? 9 : 7),
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
      final gapIconToValue = isPrimary ? 3.0 : 2.0;
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

    // Primary tier gets a subtle gradient background for more visual weight.
    final Decoration tileDecoration = isPrimary
        ? BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accent.withAlpha(fillAlpha),
                accent.withAlpha(fillAlpha ~/ 2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: accent.withAlpha(borderAlpha),
              width: borderWidth,
            ),
          )
        : BoxDecoration(
            color: accent.withAlpha(fillAlpha),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: accent.withAlpha(borderAlpha),
              width: borderWidth,
            ),
          );

    return Tooltip(
      key: _tooltipKey,
      message: widget.tooltip,
      triggerMode: widget.onTap != null
          ? TooltipTriggerMode.longPress
          : TooltipTriggerMode.manual,
      waitDuration: Duration.zero,
      showDuration: const Duration(seconds: 3),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap:
              widget.onTap ??
              () => _tooltipKey.currentState?.ensureTooltipVisible(),
          child: DecoratedBox(decoration: tileDecoration, child: content),
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
