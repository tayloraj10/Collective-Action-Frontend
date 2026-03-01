import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/link.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/initiatives/initiative_submission_button.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';

class InitiativeCard extends ConsumerWidget {
  final InitiativeSchema initiative;
  final Color cardColor;
  final bool isMobile;
  final bool showCreatedBy;
  final double titleFontSize;
  final double descFontSize;
  final double progressHeight;
  final double progressFontSize;
  final double spacing;
  final double containerPadding;
  final double containerPaddingTop;

  const InitiativeCard({
    required this.initiative,
    required this.cardColor,
    required this.isMobile,
    this.showCreatedBy = true,
    required this.titleFontSize,
    required this.descFontSize,
    required this.progressHeight,
    required this.progressFontSize,
    required this.spacing,
    required this.containerPadding,
    required this.containerPaddingTop,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = (initiative.goal == null || initiative.goal == 0)
        ? 1
        : initiative.goal!;
    final progress = (initiative.complete ?? 0.0) / goal;

    final isPriority = initiative.priority == true;
    final borderColor = isPriority
        ? Color.lerp(cardColor, Colors.black, 0.5)!
        : null;
    final borderWidth = isPriority ? (isMobile ? 3.0 : 4.0) : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(isMobile ? 10 : 16),
        border: borderColor != null
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isPriority ? 40 : 26),
            blurRadius: isMobile
                ? (isPriority ? 12 : 8)
                : (isPriority ? 20 : 14),
            offset: Offset(0, isPriority ? 6 : 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final hasBoundedHeight = constraints.maxHeight.isFinite;
          final compact = !showCreatedBy;
          final hasLink =
              initiative.link != null && initiative.link!.isNotEmpty;
          // In grid with link, use larger gap so link never overlaps progress bar on small screens.
          final progressBarGapBase = (hasBoundedHeight && compact)
              ? (isMobile ? 6.0 : 6.0)
              : compact
              ? (isMobile ? 10.0 : 8.0)
              : (isMobile ? 12.0 : 14.0);
          final progressBarGap = (hasBoundedHeight && compact && hasLink)
              ? (isMobile ? 10.0 : 10.0)
              : progressBarGapBase;
          final progressBarBlockHeight =
              progressBarGap + progressHeight + containerPadding;
          // Title and optionally "by" + avatar as one inline flow so "by" is always at title end.
          final titleStyle = TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: titleFontSize,
            letterSpacing: 0.1,
            height: 1.0,
          );
          // When showing created-by, use larger text on full initiatives page (showCreatedBy implies more space).
          final byFontSize = showCreatedBy
              ? titleFontSize * 0.82
              : titleFontSize * 0.65;
          final byStyle = TextStyle(
            color: Colors.white.withAlpha(200),
            fontWeight: FontWeight.w500,
            fontSize: byFontSize,
            letterSpacing: 0.1,
          );

          // Top padding: minimal but visible; tighter in grid so link is visible by default.
          final topPad = (hasBoundedHeight && compact)
              ? (isMobile ? 3.0 : 5.0)
              : (isMobile ? 4.0 : 6.0);

          final linkWidget =
              initiative.link != null && initiative.link!.isNotEmpty
              ? GestureDetector(
                  onTap: () async {
                    final url = initiative.link!;
                    AppConstants.openUrl(url);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: LinkText(
                      text: initiative.link!,
                      fontSize: descFontSize,
                      color: AppColors.blueAccent,
                    ),
                  ),
                )
              : null;

          Widget contentAboveProgress({required double bottomPad}) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: topPad),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: initiative.title, style: titleStyle),
                    if (showCreatedBy) ...[
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: SizedBox(width: 6),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('by', style: byStyle),
                            SizedBox(width: 4),
                            _InitiativeCreatorAvatar(
                              createdBy: initiative.createdBy,
                              isMobile: isMobile,
                              showCreatedBy: showCreatedBy,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                maxLines: null,
                overflow: TextOverflow.visible,
              ),
              if (linkWidget != null)
                Padding(
                  padding: EdgeInsets.only(
                    top: (hasBoundedHeight && compact)
                        ? (isMobile ? 8.0 : 10.0)
                        : (isMobile ? 10.0 : 12.0),
                  ),
                  child: linkWidget,
                ),
              SizedBox(height: bottomPad),
            ],
          );

          final progressBarTop = progressBarGap;

          // Reserve right side for the plus button so title never overlaps it.
          const double _plusButtonReserve = 44.0;
          final contentPadding = EdgeInsets.fromLTRB(
            containerPadding,
            containerPaddingTop,
            containerPadding + _plusButtonReserve,
            0,
          );
          final progressBarPadding = isMobile
              ? EdgeInsets.only(top: progressBarTop, bottom: containerPadding)
              : EdgeInsets.fromLTRB(
                  containerPadding,
                  progressBarTop,
                  containerPadding,
                  containerPadding,
                );

          // Minimal bottom padding; keep a little space above progress bar.
          final bottomPad = (hasBoundedHeight && compact)
              ? (isMobile ? 3.0 : 5.0)
              : compact
              ? (isMobile ? 5.0 : 6.0)
              : (isMobile ? 6.0 : 8.0);
          final scrollContent = contentAboveProgress(bottomPad: bottomPad);
          final fullContent = contentAboveProgress(bottomPad: bottomPad);

          final progressBarWidget = Padding(
            padding: progressBarPadding,
            child: LinearPercentIndicator(
              animation: true,
              lineHeight: progressHeight,
              animationDuration: 1200,
              percent: progress.toDouble(),
              center: Text(
                '${(progress * 100).toStringAsFixed(2)}%',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: progressFontSize,
                ),
              ),
              progressColor: Colors.white,
              backgroundColor: Colors.white.withAlpha(46),
              barRadius: Radius.circular(24),
            ),
          );

          if (hasBoundedHeight) {
            return SizedBox(
              height: constraints.maxHeight,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: progressBarBlockHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: contentPadding,
                          child: SingleChildScrollView(
                            clipBehavior: Clip.hardEdge,
                            physics: const ClampingScrollPhysics(),
                            child: scrollContent,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: isMobile ? 6.0 : 8.0,
                              right: isMobile ? 6.0 : 8.0,
                            ),
                            child: InitiativeSubmissionButton(
                              initiative: initiative,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: progressBarWidget,
                  ),
                ],
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: constraints.maxWidth,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(padding: contentPadding, child: fullContent),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: isMobile ? 6.0 : 8.0,
                          right: isMobile ? 6.0 : 8.0,
                        ),
                        child: InitiativeSubmissionButton(
                          initiative: initiative,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              progressBarWidget,
            ],
          );
        },
      ),
    );
  }
}

/// Avatar only for inline use after "by" in title; tooltip shows "Created by [name]".
class _InitiativeCreatorAvatar extends ConsumerWidget {
  final String createdBy;
  final bool isMobile;
  final bool showCreatedBy;

  const _InitiativeCreatorAvatar({
    required this.createdBy,
    required this.isMobile,
    this.showCreatedBy = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(createdBy));
    final mutedColor = Colors.white.withAlpha(200);
    // Larger avatar when shown on full initiatives page (showCreatedBy = more space).
    final radius = showCreatedBy
        ? (isMobile ? 10.0 : 12.0)
        : (isMobile ? 6.0 : 8.0);

    return userAsync.when(
      loading: () => Tooltip(
        message: 'Created by...',
        child: SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: CircularProgressIndicator(strokeWidth: 1.5, color: mutedColor),
        ),
      ),
      error: (_, _) => Tooltip(
        message: 'Created by Unknown',
        child: UserAvatar(
          userId: createdBy,
          radius: radius,
          showProfileOnTap: true,
        ),
      ),
      data: (user) {
        final name = user?.name ?? user?.email ?? 'Unknown';
        return Tooltip(
          message: 'Created by $name',
          child: UserAvatar(
            userId: createdBy,
            radius: radius,
            showProfileOnTap: true,
          ),
        );
      },
    );
  }
}
