import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/screens/dashboard/components/initiatives_summary.dart';
import 'package:flutter/material.dart';
import 'package:collective_action_frontend/screens/dashboard/components/summary_count.dart';

class SummaryPane extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const SummaryPane({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (title == 'Initiatives') {
      // Show a different widget for Initiatives with live count
      return InitiativesSummary(icon: icon, color: color);
    }

    // Match InitiativesSummary padding
    final isMobile = AppConstants.isMobile(context);
    final double cardPaddingHeight = isMobile ? 4 : 6;
    final double cardPaddingWidth = isMobile ? 6 : 10;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: cardPaddingWidth,
            vertical: cardPaddingHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SummaryCount(count: 0),
            ],
          ),
        ),
      ),
    );
  }
}
