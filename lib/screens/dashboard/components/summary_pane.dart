import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/screens/dashboard/components/initiatives/initiatives_summary.dart';
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

    if (title == 'Maps') {
      final isMobile = AppConstants.isMobile(context);
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => AppConstants.openUrl('https://trash-map.com'),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 6 : 10,
              vertical: isMobile ? 4 : 6,
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
                const SizedBox(height: 6),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: isMobile ? 2 : 3,
                              right: 2,
                            ),
                            child: Icon(
                              Icons.open_in_new,
                              color: AppColors.textSecondary,
                              size: isMobile ? 18 : 22,
                            ),
                          ),
                        ),
                        WidgetSpan(child: SizedBox(width: isMobile ? 2 : 4)),
                        TextSpan(
                          text: AppConstants.isMobile(context)
                              ? 'Check out The Trash Map'
                              : 'Check out The Trash Map while this is Under Construction',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: isMobile ? 15 : 19,
                            letterSpacing: 1.2,
                            color: AppColors.textSecondary,
                            height: 1.25,
                            shadows: [
                              Shadow(
                                color: Colors.black.withAlpha(60),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 6),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/trash_map_preview.png',
                      fit: BoxFit.cover,
                      height: isMobile ? 100 : 160,
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SummaryCount(count: 0),
              ],
            ),
          ),
        ),
      );
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
              // Centered Under Construction text
              Expanded(
                child: Center(
                  child: Text(
                    'Under Construction',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: isMobile ? 20 : 35,
                      letterSpacing: 2.5,
                      foreground: Paint()
                        ..shader =
                            LinearGradient(
                              colors: [Colors.black, Colors.grey.shade600],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(
                              Rect.fromLTWH(
                                0,
                                0,
                                isMobile ? 180 : 260,
                                isMobile ? 40 : 60,
                              ),
                            ),
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha(89),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                        Shadow(
                          color: Colors.white.withAlpha(77),
                          blurRadius: 2,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
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
