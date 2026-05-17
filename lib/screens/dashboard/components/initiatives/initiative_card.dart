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
    final hasDescription =
        initiative.description != null &&
        initiative.description!.trim().isNotEmpty;
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
          final progressBarGapBase = (hasBoundedHeight && compact)
              ? (isMobile ? 6.0 : 6.0)
              : compact
              ? (isMobile ? 10.0 : 8.0)
              : (isMobile ? 12.0 : 14.0);
          // Link is pinned outside the scroll area in bounded-height cards,
          // so no extra gap needed here.
          final progressBarGap = progressBarGapBase;
          // Less padding below progress bar on desktop to free space for content.
          final bottomPadProgress = isMobile
              ? containerPadding
              : (containerPadding * 0.6).clamp(8.0, 14.0);
          final progressBarBlockHeight =
              progressBarGap + progressHeight + bottomPadProgress;
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

          final descriptionIcon = hasDescription
              ? _InitiativeDescriptionIcon(
                  onTap: () => _showInitiativeDescriptionDialog(
                    context,
                    initiative.title,
                    initiative.description!.trim(),
                  ),
                  isMobile: isMobile,
                )
              : null;

          // includeLink: false is used in bounded-height (grid) cards where the
          // link is pinned as a separate Positioned widget so it never scrolls away.
          Widget contentAboveProgress({
            required double bottomPad,
            bool includeLink = true,
          }) => Column(
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
              if (includeLink && linkWidget != null)
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

          // Reserve right side for top action icons so title never overlaps them.
          const double plusButtonReserve = 44.0;
          final descriptionIconSize = isMobile ? 24.0 : 26.0;
          final topRightReserve =
              plusButtonReserve +
              (descriptionIcon != null ? descriptionIconSize + 6 : 0);
          final contentPadding = EdgeInsets.fromLTRB(
            containerPadding,
            containerPaddingTop,
            containerPadding + topRightReserve,
            0,
          );
          final progressBarPadding = isMobile
              ? EdgeInsets.only(top: progressBarTop, bottom: containerPadding)
              : EdgeInsets.fromLTRB(
                  containerPadding,
                  progressBarTop,
                  containerPadding,
                  bottomPadProgress,
                );

          // Minimal bottom padding; keep a little space above progress bar.
          final bottomPad = (hasBoundedHeight && compact)
              ? (isMobile ? 3.0 : 5.0)
              : compact
              ? (isMobile ? 5.0 : 6.0)
              : (isMobile ? 6.0 : 8.0);
          // In bounded-height (grid) cards the link is pinned as a Positioned
          // widget, so the scroll area contains title only.
          final pinnedLinkHeight = (hasBoundedHeight && hasLink)
              ? (isMobile ? 26.0 : 29.0)
              : 0.0;
          final titleScrollContent = contentAboveProgress(
            bottomPad: bottomPad,
            includeLink: false,
          );
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
                  // Scrollable title area — link is excluded so it never scrolls away.
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: progressBarBlockHeight + pinnedLinkHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: contentPadding,
                          child: SingleChildScrollView(
                            clipBehavior: Clip.hardEdge,
                            physics: const ClampingScrollPhysics(),
                            child: titleScrollContent,
                          ),
                        ),
                        ..._cardTopRightActions(
                          isMobile: isMobile,
                          descriptionIcon: descriptionIcon,
                          initiative: initiative,
                        ),
                      ],
                    ),
                  ),
                  // Pinned link — always visible above the progress bar.
                  if (linkWidget != null)
                    Positioned(
                      left: containerPadding,
                      right: containerPadding,
                      bottom: progressBarBlockHeight + 4,
                      child: linkWidget,
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
                    ..._cardTopRightActions(
                      isMobile: isMobile,
                      descriptionIcon: descriptionIcon,
                      initiative: initiative,
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

List<Widget> _cardTopRightActions({
  required bool isMobile,
  required Widget? descriptionIcon,
  required InitiativeSchema initiative,
}) {
  final topPad = isMobile ? 6.0 : 8.0;
  final sidePad = isMobile ? 6.0 : 8.0;
  final iconGap = isMobile ? 4.0 : 6.0;

  return [
    if (descriptionIcon != null)
      Positioned(
        top: topPad,
        right: sidePad + 44 + iconGap,
        child: descriptionIcon,
      ),
    Positioned(
      top: topPad,
      right: sidePad,
      child: InitiativeSubmissionButton(initiative: initiative),
    ),
  ];
}

class _InitiativeDescriptionIcon extends StatelessWidget {
  const _InitiativeDescriptionIcon({
    required this.onTap,
    required this.isMobile,
  });

  final VoidCallback onTap;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final size = isMobile ? 24.0 : 26.0;
    final iconSize = isMobile ? 15.0 : 17.0;
    return Tooltip(
      message: 'View description',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(48),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.info_outline_rounded,
            size: iconSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

List<String> _descriptionParagraphs(String description) {
  final normalized = description.replaceAll('\r\n', '\n').trim();
  if (normalized.isEmpty) return const [];

  var parts = normalized
      .split(RegExp(r'\n\s*\n'))
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.length > 1) return parts;

  parts = normalized
      .split(RegExp(r'\n(?=(?:HOW TO |STEP #\d))'))
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.isNotEmpty) return parts;

  return [normalized];
}

void _showInitiativeDescriptionDialog(
  BuildContext context,
  String title,
  String description,
) {
  final paragraphs = _descriptionParagraphs(description);
  if (paragraphs.isEmpty) return;

  final screenWidth = MediaQuery.sizeOf(context).width;
  final dialogWidth = (screenWidth * 0.88).clamp(280.0, 440.0);

  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final bodyStyle = Theme.of(dialogContext).textTheme.bodyMedium;
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: dialogWidth,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < paragraphs.length; i++) ...[
                  if (i > 0) const SizedBox(height: 16),
                  Text(paragraphs[i], style: bodyStyle),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
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
