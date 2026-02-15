import 'package:collective_action_frontend/providers/stats_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
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
  pounds('Pounds', Icons.scale_outlined);

  const LeaderboardMetric(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Dialog showing leaderboard with switchable metric (cleanups, bags, pounds). Top 10 only.
class LeaderboardDialog extends ConsumerStatefulWidget {
  const LeaderboardDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const LeaderboardDialog(),
    );
  }

  @override
  ConsumerState<LeaderboardDialog> createState() => _LeaderboardDialogState();
}

class _LeaderboardDialogState extends ConsumerState<LeaderboardDialog> {
  LeaderboardMetric _metric = LeaderboardMetric.bags;

  @override
  Widget build(BuildContext context) {
    final (titleColor, cardColor) = _leaderboardColors(context);
    final entries = switch (_metric) {
      LeaderboardMetric.cleanups => ref.watch(leaderboardCleanupsProvider),
      LeaderboardMetric.bags => ref.watch(leaderboardBagsProvider),
      LeaderboardMetric.pounds => ref.watch(leaderboardPoundsProvider),
    };

    return AlertDialog(
      insetPadding: const EdgeInsets.fromLTRB(40, 56, 40, 24),
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
            child: SegmentedButton<LeaderboardMetric>(
              segments: LeaderboardMetric.values
                  .map(
                    (m) => ButtonSegment<LeaderboardMetric>(
                      value: m,
                      icon: Icon(m.icon, size: 18),
                      label: Text(m.label),
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
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _LeaderboardCard extends ConsumerWidget {
  const _LeaderboardCard({
    required this.entries,
    required this.cardColor,
    required this.metric,
  });

  final List<LeaderboardEntry> entries;
  final Color cardColor;
  final LeaderboardMetric metric;

  String _formatValue(int value) {
    return switch (metric) {
      LeaderboardMetric.cleanups => '$value',
      LeaderboardMetric.bags => '$value',
      LeaderboardMetric.pounds => '$value lbs',
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
          'No cleanup data yet.',
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
