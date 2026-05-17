import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/providers/stats_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color _kLeaderboardTitleLight = Color(0xFFFF9800);
const Color _kLeaderboardCardLight = Color(0xFFFFF3E0);
const Color _kLeaderboardTitleDark = Color(0xFFFFB74D);
const Color _kLeaderboardCardDark = Color(0xFF3D2E1A);

(Color, Color) _leaderboardColors(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark
      ? (_kLeaderboardTitleDark, _kLeaderboardCardDark)
      : (_kLeaderboardTitleLight, _kLeaderboardCardLight);
}

enum LeaderboardMetric {
  cleanups('Cleanups', Icons.cleaning_services),
  bags('Total Bags', Icons.local_mall),
  pounds('Pounds', Icons.scale_outlined),
  plantings('Plantings', Icons.eco_outlined),
  trees('Trees', Icons.park),
  wildflowers('Wildflowers', Icons.local_florist);

  const LeaderboardMetric(this.label, this.icon);
  final String label;
  final IconData icon;

  /// Shorter label for narrow layouts (fits three segments without clipping).
  String get compactLabel => switch (this) {
        LeaderboardMetric.bags => 'Bags',
        _ => label,
      };
}

/// Dialog showing leaderboard with switchable metric (cleanups, bags, pounds). Top 10 only.
class LeaderboardDialog extends ConsumerStatefulWidget {
  const LeaderboardDialog({
    super.key,
    required this.campaignId,
    this.campaignType,
  });

  final String campaignId;
  final MapCampaignTypeEnum? campaignType;

  static Future<void> show(
    BuildContext context,
    String campaignId, {
    MapCampaignTypeEnum? campaignType,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) =>
          LeaderboardDialog(campaignId: campaignId, campaignType: campaignType),
    );
  }

  @override
  ConsumerState<LeaderboardDialog> createState() => _LeaderboardDialogState();
}

class _LeaderboardDialogState extends ConsumerState<LeaderboardDialog> {
  late LeaderboardMetric _metric;

  @override
  void initState() {
    super.initState();
    _metric = widget.campaignType == MapCampaignTypeEnum.plantingMap
        ? LeaderboardMetric.plantings
        : LeaderboardMetric.cleanups;
  }

  @override
  Widget build(BuildContext context) {
    final (titleColor, cardColor) = _leaderboardColors(context);
    final isPlanting = widget.campaignType == MapCampaignTypeEnum.plantingMap;
    final metrics = isPlanting
        ? const [
            LeaderboardMetric.plantings,
            LeaderboardMetric.trees,
            LeaderboardMetric.wildflowers,
          ]
        : const [
            LeaderboardMetric.cleanups,
            LeaderboardMetric.bags,
            LeaderboardMetric.pounds,
          ];
    if (!metrics.contains(_metric)) {
      _metric = metrics.first;
    }
    final entries = switch (_metric) {
      LeaderboardMetric.cleanups => ref.watch(
        leaderboardCleanupsProvider(widget.campaignId),
      ),
      LeaderboardMetric.bags => ref.watch(
        leaderboardBagsProvider(widget.campaignId),
      ),
      LeaderboardMetric.pounds => ref.watch(
        leaderboardPoundsProvider(widget.campaignId),
      ),
      LeaderboardMetric.plantings => ref.watch(
        leaderboardPlantingsProvider(widget.campaignId),
      ),
      LeaderboardMetric.trees => ref.watch(
        leaderboardTreePlantingsProvider(widget.campaignId),
      ),
      LeaderboardMetric.wildflowers => ref.watch(
        leaderboardWildflowerPlantingsProvider(widget.campaignId),
      ),
    };

    final screenWidth = MediaQuery.sizeOf(context).width;
    final useCompactMetrics = screenWidth < 500;

    return AlertDialog(
      insetPadding: useCompactMetrics
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
          : const EdgeInsets.fromLTRB(40, 56, 40, 24),
      title: Text(
        'Leaderboard',
        style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: useCompactMetrics
                ? _CompactMetricSelector(
                    metrics: metrics,
                    selected: _metric,
                    onSelected: (m) => setState(() => _metric = m),
                  )
                : SegmentedButton<LeaderboardMetric>(
                    segments: metrics
                        .map(
                          (m) => ButtonSegment<LeaderboardMetric>(
                            value: m,
                            icon: Icon(m.icon, size: 18),
                            label: Text(
                              m.label,
                              softWrap: false,
                              maxLines: 1,
                            ),
                          ),
                        )
                        .toList(),
                    selected: {_metric},
                    onSelectionChanged: (Set<LeaderboardMetric> selected) {
                      setState(() => _metric = selected.first);
                    },
                    showSelectedIcon: false,
                  ),
          ),
          _LeaderboardCard(
            entries: entries,
            cardColor: cardColor,
            metric: _metric,
            emptyText: isPlanting
                ? 'No planting data yet.'
                : 'No cleanup data yet.',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => safePop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

/// Equal-width segments on narrow screens: icon above label, no horizontal overflow.
class _CompactMetricSelector extends StatelessWidget {
  const _CompactMetricSelector({
    required this.metrics,
    required this.selected,
    required this.onSelected,
  });

  static const double segmentHeight = 52;
  static const double iconSize = 20;
  static const double labelHeight = 14;
  static const double labelFontSize = 11;

  final List<LeaderboardMetric> metrics;
  final LeaderboardMetric selected;
  final ValueChanged<LeaderboardMetric> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.outline;
    final selectedBg = theme.colorScheme.secondaryContainer;
    final selectedFg = theme.colorScheme.onSecondaryContainer;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: segmentHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < metrics.length; i++) ...[
                if (i > 0)
                  Container(width: 1, color: borderColor),
                Expanded(
                  child: _CompactMetricSegment(
                    metric: metrics[i],
                    selected: metrics[i] == selected,
                    isFirst: i == 0,
                    isLast: i == metrics.length - 1,
                    selectedBg: selectedBg,
                    selectedFg: selectedFg,
                    onTap: () => onSelected(metrics[i]),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactMetricSegment extends StatelessWidget {
  const _CompactMetricSegment({
    required this.metric,
    required this.selected,
    required this.isFirst,
    required this.isLast,
    required this.selectedBg,
    required this.selectedFg,
    required this.onTap,
  });

  static const double _outerRadius = 20;

  final LeaderboardMetric metric;
  final bool selected;
  final bool isFirst;
  final bool isLast;
  final Color selectedBg;
  final Color selectedFg;
  final VoidCallback onTap;

  BorderRadius get _selectedRadius {
    // Match parent pill corners when this end segment is selected.
    const r = Radius.circular(_outerRadius - 1);
    return BorderRadius.horizontal(
      left: isFirst ? r : Radius.zero,
      right: isLast ? r : Radius.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = selected ? _selectedRadius : BorderRadius.zero;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        splashColor: selectedFg.withValues(alpha: 0.12),
        highlightColor: selectedFg.withValues(alpha: 0.08),
        child: Ink(
          decoration: BoxDecoration(
            color: selected ? selectedBg : Colors.transparent,
            borderRadius: radius,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  metric.icon,
                  size: _CompactMetricSelector.iconSize,
                  color: selected ? selectedFg : theme.colorScheme.onSurface,
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: _CompactMetricSelector.labelHeight,
                  child: Center(
                    child: Text(
                      metric.compactLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _CompactMetricSelector.labelFontSize,
                        height: 1,
                        color: selected
                            ? selectedFg
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LeaderboardCard extends ConsumerWidget {
  const _LeaderboardCard({
    required this.entries,
    required this.cardColor,
    required this.metric,
    required this.emptyText,
  });

  final List<LeaderboardEntry> entries;
  final Color cardColor;
  final LeaderboardMetric metric;
  final String emptyText;

  String _formatValue(int value) {
    return switch (metric) {
      LeaderboardMetric.cleanups => '$value',
      LeaderboardMetric.bags => '$value',
      LeaderboardMetric.pounds => '$value lbs',
      LeaderboardMetric.plantings => '$value',
      LeaderboardMetric.trees => '$value',
      LeaderboardMetric.wildflowers => '$value',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          emptyText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < entries.length; i++) ...[
              _LeaderboardRow(
                rank: i + 1,
                entry: entries[i],
                valueText: _formatValue(entries[i].value),
              ),
              if (i < entries.length - 1)
                Divider(
                  height: 1,
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LeaderboardRow extends ConsumerWidget {
  const _LeaderboardRow({
    required this.rank,
    required this.entry,
    required this.valueText,
  });

  final int rank;
  final LeaderboardEntry entry;
  final String valueText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(entry.userId));
    final displayName = userAsync.value?.name?.trim().isNotEmpty == true
        ? userAsync.value!.name!
        : 'User';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            '$rank.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              displayName,
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            valueText,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
