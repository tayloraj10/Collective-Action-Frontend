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
          // Reserve enough space for progress bar + top padding + bottom padding + visual gap
          final progressBarGap = isMobile ? 14.0 : 18.0;
          final reserveHeight = progressBarGap +
              progressHeight +
              containerPadding;

          // Title and "by" + avatar as one inline flow so "by" is always at title end.
          final titleStyle = TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: titleFontSize,
            letterSpacing: 0.1,
            height: 1.0,
          );
          final byStyle = TextStyle(
            color: Colors.white.withAlpha(200),
            fontWeight: FontWeight.w500,
            fontSize: titleFontSize * 0.65,
            letterSpacing: 0.1,
          );

          // Content without bottom reserve (for scroll mode: avoids extra scroll space).
          Widget contentAboveProgress({required double bottomPad}) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: isMobile ? 4 : 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: initiative.title, style: titleStyle),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: SizedBox(width: 6),
                          ),
                          TextSpan(text: 'by', style: byStyle),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: SizedBox(width: 3),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: _InitiativeCreatorAvatar(
                              createdBy: initiative.createdBy,
                              isMobile: isMobile,
                            ),
                          ),
                        ],
                      ),
                      maxLines: null,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  InitiativeSubmissionButton(initiative: initiative),
                ],
              ),
              // Link row (tiny gap above for tight layouts).
              if (initiative.link != null && initiative.link!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: isMobile ? 3 : 4),
                  child: GestureDetector(
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
                  ),
                ),
              SizedBox(height: bottomPad),
            ],
          );

          // Extra top padding on progress bar for clear separation from link.
          final progressBarTop = progressBarGap;

          // Content keeps same insets; progress bar full width on mobile (no horizontal padding).
          final contentPadding = EdgeInsets.fromLTRB(
            containerPadding,
            containerPaddingTop,
            containerPadding,
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

          // When parent gives fixed height: scroll only when content overflows.
          final scrollContent = contentAboveProgress(
            bottomPad: isMobile ? 8 : 10,
          );
          final fullContent = contentAboveProgress(bottomPad: reserveHeight);

          return Stack(
            children: [
              if (hasBoundedHeight) ...[
                SizedBox(height: constraints.maxHeight),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: progressHeight,
                  child: Padding(
                    padding: contentPadding,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        clipBehavior: Clip.hardEdge,
                        physics: const ClampingScrollPhysics(),
                        child: scrollContent,
                      ),
                    ),
                  ),
                ),
              ] else
                Padding(padding: contentPadding, child: fullContent),

              // Pinned bottom progress bar (full width on mobile).
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
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
                ),
              ),
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

  const _InitiativeCreatorAvatar({
    required this.createdBy,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(createdBy));
    final mutedColor = Colors.white.withAlpha(200);
    final radius = isMobile ? 6.0 : 8.0;

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
