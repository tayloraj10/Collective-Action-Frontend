import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:collective_action_frontend/utils/map_area_utils.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// One borough/area captain badge anchored on the map.
class AreaCaptainBadgeLayout {
  const AreaCaptainBadgeLayout({
    required this.area,
    required this.assignments,
    required this.screenOffset,
  });

  final MapAreaSchema area;
  final List<AreaCaptainSchema> assignments;

  /// Screen position of the borough's middle-left anchor.
  final Offset screenOffset;
}

/// Vertical centering offset for the badge chip.
const kCaptainBadgeChipHeight = 36.0;

/// Inset from the west edge so the chip sits inside the borough.
const kCaptainBadgeInsetPx = 8.0;

/// Upper bound for captain badge chip width (varies with avatar count).
const kCaptainBadgeChipMaxWidth = 112.0;

const _kAreaTooltipPaddingH = 20.0;
const _kAreaTooltipPaddingV = 12.0;
const _kAreaTooltipCharWidth = 8.0;
const _kOverlapMargin = 8.0;

/// Screen rect for a captain badge chip (for overlap checks).
Rect captainBadgeScreenRect(AreaCaptainBadgeLayout layout) {
  return Rect.fromLTWH(
    layout.screenOffset.dx + kCaptainBadgeInsetPx,
    layout.screenOffset.dy - (kCaptainBadgeChipHeight / 2),
    kCaptainBadgeChipMaxWidth,
    kCaptainBadgeChipHeight,
  );
}

Size estimateAreaTooltipSize(String name) {
  final width = (name.length * _kAreaTooltipCharWidth + _kAreaTooltipPaddingH)
      .clamp(60.0, 220.0);
  return Size(width, 28.0 + _kAreaTooltipPaddingV);
}

/// Top-left screen position for an area name tooltip, avoiding captain badges.
Offset computeAreaTooltipTopLeft({
  required Offset centroidScreen,
  required String name,
  required String featureSlug,
  required List<AreaCaptainBadgeLayout> captainBadges,
}) {
  final tooltipSize = estimateAreaTooltipSize(name);
  var topLeft = Offset(centroidScreen.dx - 50, centroidScreen.dy - 36);
  var tooltipRect = Rect.fromLTWH(
    topLeft.dx,
    topLeft.dy,
    tooltipSize.width,
    tooltipSize.height,
  );

  final matchingBadge = captainBadges
      .where((badge) => badge.area.slug == featureSlug)
      .firstOrNull;
  if (matchingBadge == null) return topLeft;

  final badgeRect = captainBadgeScreenRect(matchingBadge);
  if (!tooltipRect.overlaps(badgeRect.inflate(_kOverlapMargin))) {
    return topLeft;
  }

  final candidates = <Offset>[
    Offset(
      badgeRect.right + _kOverlapMargin,
      badgeRect.center.dy - tooltipSize.height / 2,
    ),
    Offset(
      badgeRect.center.dx - tooltipSize.width / 2,
      badgeRect.top - tooltipSize.height - _kOverlapMargin,
    ),
    Offset(
      badgeRect.left - tooltipSize.width - _kOverlapMargin,
      badgeRect.center.dy - tooltipSize.height / 2,
    ),
    Offset(
      badgeRect.center.dx - tooltipSize.width / 2,
      badgeRect.bottom + _kOverlapMargin,
    ),
  ];

  for (final candidate in candidates) {
    final candidateRect = Rect.fromLTWH(
      candidate.dx,
      candidate.dy,
      tooltipSize.width,
      tooltipSize.height,
    );
    if (!candidateRect.overlaps(badgeRect.inflate(_kOverlapMargin))) {
      return candidate;
    }
  }

  // Last resort: far to the right of the badge.
  return Offset(badgeRect.right + _kOverlapMargin, topLeft.dy);
}

/// Positioned badge widgets for the map [Stack] — no full-screen overlay layer.
List<Widget> buildAreaCaptainBadgeWidgets(
  List<AreaCaptainBadgeLayout> badges, {
  VoidCallback? onOpenCaptainsSheet,
}) {
  return [
    for (final badge in badges)
      Positioned(
        left: badge.screenOffset.dx + kCaptainBadgeInsetPx,
        top: badge.screenOffset.dy - (kCaptainBadgeChipHeight / 2),
        child: PointerInterceptor(
          child: CaptainBadgeChip(
            area: badge.area,
            captainUserIds:
                badge.assignments.map((a) => a.captainUserId).toList(),
            onOpenCaptainsSheet: onOpenCaptainsSheet,
          ),
        ),
      ),
  ];
}

class CaptainBadgeChip extends StatelessWidget {
  const CaptainBadgeChip({
    super.key,
    required this.area,
    required this.captainUserIds,
    this.onOpenCaptainsSheet,
  });

  final MapAreaSchema area;
  final List<String> captainUserIds;
  final VoidCallback? onOpenCaptainsSheet;

  String get _tooltipMessage {
    final areaName = areaDisplayName(area);
    if (captainUserIds.length <= 1) {
      return 'Area captain for $areaName';
    }
    return 'Area captains for $areaName';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overflowCount =
        captainUserIds.length > 3 ? captainUserIds.length - 3 : 0;

    return Tooltip(
      message: _tooltipMessage,
      waitDuration: const Duration(milliseconds: 400),
      child: Material(
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.35),
        color: theme.colorScheme.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < captainUserIds.length && i < 3; i++)
                Transform.translate(
                  offset: Offset(i * -6.0, 0),
                  child: UserAvatar(
                    userId: captainUserIds[i],
                    radius: 14,
                    showProfileOnTap: true,
                  ),
                ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onOpenCaptainsSheet,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      captainUserIds.isEmpty ? 8 : 6,
                      2,
                      8,
                      2,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (overflowCount > 0)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              '+$overflowCount',
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                        Icon(
                          Icons.military_tech_outlined,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
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
