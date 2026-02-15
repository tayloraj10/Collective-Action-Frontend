import 'package:collective_action_frontend/components/stat.dart';
import 'package:collective_action_frontend/providers/stats_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Light mode: section colors to match reference
const Color _kOverallTitleLight = Color(0xFF4CAF50);
const Color _kOverallCardLight = Color(0xFFE8F5E9);
const Color _kYourTitleLight = Color(0xFF2196F3);
const Color _kYourCardLight = Color(0xFFE3F2FD);
// Dark mode: darker card backgrounds and slightly brighter titles so they don't wash out
const Color _kOverallTitleDark = Color(0xFF81C784);
const Color _kOverallCardDark = Color(0xFF1E3320);
const Color _kYourTitleDark = Color(0xFF64B5F6);
const Color _kYourCardDark = Color(0xFF1A2D3D);

(Color, Color, Color, Color) _statsColors(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark
      ? (_kOverallTitleDark, _kOverallCardDark, _kYourTitleDark, _kYourCardDark)
      : (_kOverallTitleLight, _kOverallCardLight, _kYourTitleLight, _kYourCardLight);
}

/// Dialog showing overall stats and your stats (when logged in).
class StatsDialog extends ConsumerWidget {
  const StatsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const StatsDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overall = ref.watch(overallMapStatsProvider);
    final your = ref.watch(yourMapStatsProvider);
    final isLoggedIn = ref.watch(currentUserProvider).value != null;
    final (overallTitle, overallCard, yourTitle, yourCard) = _statsColors(context);

    return AlertDialog(
      insetPadding: const EdgeInsets.fromLTRB(40, 56, 40, 24),
      title: const Text('Stats for Cleanups & Trash Reports'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionTitle(title: 'Overall Stats', color: overallTitle),
            const SizedBox(height: 6),
            _StatsCard(
              stats: overall,
              cardColor: overallCard,
              iconColor: overallTitle,
              labels: const (
                cleanups: 'Total Cleanups:',
                trashReports: 'Total Trash Reports:',
                smallBags: 'Small Bags:',
                largeBags: 'Large Bags:',
                weight: 'Total Weight:',
              ),
            ),
            if (isLoggedIn) ...[
              const SizedBox(height: 20),
              _SectionTitle(title: 'Your Stats', color: yourTitle),
              const SizedBox(height: 6),
              _StatsCard(
                stats: your,
                cardColor: yourCard,
                iconColor: yourTitle,
                labels: const (
                  cleanups: 'Your Cleanups:',
                  trashReports: 'Your Trash Reports:',
                  smallBags: 'Your Small Bags:',
                  largeBags: 'Your Large Bags:',
                  weight: 'Your Weight:',
                ),
              ),
            ],
          ],
        ),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.stats,
    required this.cardColor,
    required this.iconColor,
    required this.labels,
  });

  final MapSubmissionStats stats;
  final Color cardColor;
  final Color iconColor;
  final ({
    String cleanups,
    String trashReports,
    String smallBags,
    String largeBags,
    String weight,
  }) labels;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stat(
            icon: Icons.cleaning_services,
            label: labels.cleanups,
            value: '${stats.cleanupCount}',
            color: iconColor,
            showDivider: true,
          ),
          Stat(
            icon: Icons.report_outlined,
            label: labels.trashReports,
            value: '${stats.trashReportCount}',
            color: iconColor,
            showDivider: true,
          ),
          Stat(
            icon: Icons.shopping_bag_outlined,
            label: labels.smallBags,
            value: '${stats.totalSmallBags}',
            color: iconColor,
            showDivider: true,
          ),
          Stat(
            icon: Icons.delete_outline,
            label: labels.largeBags,
            value: '${stats.totalLargeBags}',
            color: iconColor,
            showDivider: true,
          ),
          Stat(
            icon: Icons.scale_outlined,
            label: labels.weight,
            value: '${stats.totalPounds}',
            color: iconColor,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
