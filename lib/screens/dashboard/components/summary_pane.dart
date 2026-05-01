import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/screens/dashboard/components/feed/activity_feed_summary.dart';
import 'package:collective_action_frontend/screens/dashboard/components/initiatives/initiatives_summary.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:collective_action_frontend/screens/dashboard/components/maps/maps_summary.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/social_summary.dart';
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
    String? routeForTitle(String title) {
      switch (title) {
        case 'Initiatives':
          return '/initiatives';
        case 'Community':
          return '/network';
        case 'Maps':
          return '/maps/cleanup';
        case 'Action':
          return '/social';
        default:
          return null;
      }
    }

    if (title == 'Initiatives') {
      // Show a different widget for Initiatives with live count
      return InitiativesSummary(icon: icon, color: color);
    }

    if (title == 'Community') {
      return ActivityFeedSummary(icon: icon, color: color);
    }

    if (title == 'Action') {
      return SocialSummary(icon: icon, color: color);
    }

    if (title == 'Maps') {
      return MapsSummary(icon: icon, color: color);
    }

    final isMobile = AppConstants.isMobile(context);
    final route = routeForTitle(title);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradStart = isDark
        ? Color.lerp(color, Colors.black, 0.45)!
        : Color.lerp(color, Colors.black, 0.28)!;
    final gradEnd = isDark
        ? Color.lerp(color, Colors.black, 0.15)!
        : color;

    Widget gradientHeader = InkWell(
      onTap: route != null ? () => safeGo(context, route) : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(14, isMobile ? 9 : 12, 14, isMobile ? 9 : 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradStart, gradEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: isMobile ? 14 : 16,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            if (route != null)
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withAlpha(200),
                size: 18,
              ),
          ],
        ),
      ),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          gradientHeader,
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
                    ..shader = LinearGradient(
                      colors: [color.withAlpha(180), color.withAlpha(80)],
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
                      color: color.withAlpha(60),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, isMobile ? 8 : 10),
            child: SummaryCount(count: 0),
          ),
        ],
      ),
    );
  }
}
