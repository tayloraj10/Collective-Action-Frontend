import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/link.dart';
import 'package:collective_action_frontend/screens/dashboard/components/initiatives/initiative_submission_button.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class InitiativeCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
      padding: EdgeInsets.fromLTRB(
        containerPadding,
        containerPaddingTop,
        containerPadding,
        containerPadding,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final hasBoundedHeight = constraints.maxHeight.isFinite;
          final reserveHeight = progressHeight + (isMobile ? 12 : 16);

          Widget contentColumn() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      initiative.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: titleFontSize,
                        letterSpacing: 0.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InitiativeSubmissionButton(initiative: initiative),
                ],
              ),
              if (initiative.link != null && initiative.link!.isNotEmpty)
                GestureDetector(
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
              if (!hasBoundedHeight) SizedBox(height: reserveHeight),
            ],
          );

          return Stack(
            children: [
              if (hasBoundedHeight)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: progressHeight,
                  child: SingleChildScrollView(
                    clipBehavior: Clip.hardEdge,
                    child: contentColumn(),
                  ),
                )
              else
                contentColumn(),

              // Pinned bottom progress bar (no flex widgets required).
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
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
            ],
          );
        },
      ),
    );
  }
}
