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
          return '/social';
        case 'Maps':
          return '/maps/cleanup';
        case 'Actions':
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

    if (title == 'Actions') {
      return SocialSummary(icon: icon, color: color);
    }

    if (title == 'Maps') {
      return MapsSummary(icon: icon, color: color);
    }

    // Match InitiativesSummary padding
    final isMobile = AppConstants.isMobile(context);
    final double cardPaddingHeight = isMobile ? 4 : 6;
    final double cardPaddingWidth = isMobile ? 6 : 10;
    final route = routeForTitle(title);

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
                  if (route != null)
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => safeGo(context, route),
                      child: Container(
                        padding: EdgeInsets.all(isMobile ? 10 : 12),
                        decoration: BoxDecoration(
                          color: color.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: isMobile ? 2 : 0),
                          child: Icon(
                            icon,
                            color: color,
                            size: isMobile ? 20 : 28,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: EdgeInsets.all(isMobile ? 10 : 12),
                      decoration: BoxDecoration(
                        color: color.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: isMobile ? 2 : 0),
                        child: Icon(
                          icon,
                          color: color,
                          size: isMobile ? 20 : 28,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: (!isMobile || route == null)
                          ? null
                          : () => safeGo(context, route),
                      splashColor: (!isMobile || route == null)
                          ? null
                          : Theme.of(context).colorScheme.primary.withAlpha(30),
                      highlightColor: (!isMobile || route == null)
                          ? null
                          : Theme.of(context).colorScheme.primary.withAlpha(20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: route == null
                            ? Text(
                                title,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ),
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withAlpha(38),
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
