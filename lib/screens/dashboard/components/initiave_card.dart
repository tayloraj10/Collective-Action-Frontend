import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/link.dart';
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
    final progress = (initiative.complete ?? 0.0) / 100;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        border: initiative.priority == true
            ? Border.all(
                color: AppColors.highlightYelllow,
                width: isMobile ? 1.5 : 2.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: cardColor.withAlpha((0.18 * 255).toInt()),
            blurRadius: isMobile ? 4 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        containerPadding,
        containerPaddingTop,
        containerPadding,
        containerPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              if (initiative.priority == true) ...[
                SizedBox(width: 6),
                Tooltip(
                  message: 'Priority Initiative',
                  child: SizedBox(
                    width: isMobile ? 16 : 18,
                    height: isMobile ? 16 : 18,
                    child: Icon(
                      Icons.star,
                      color: AppColors.highlightYelllow,
                      size: isMobile ? 14 : 16,
                      semanticLabel: 'Priority',
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (initiative.link != null && initiative.link!.isNotEmpty) ...[
            SizedBox(height: isMobile ? 4 : 6),
            GestureDetector(
              onTap: () async {
                final url = initiative.link!;
                AppConstants.openUrl(url);
              },
              child: LinkText(
                text: initiative.link!,
                fontSize: descFontSize,
                color: AppColors.blueAccent,
              ),
            ),
          ],
          isMobile ? SizedBox(height: isMobile ? 8 : 12) : Spacer(),
          LinearPercentIndicator(
            animation: true,
            lineHeight: progressHeight,
            animationDuration: 1200,
            percent: progress.toDouble(),
            center: Text(
              '${(progress * 100).toStringAsFixed(2)}%',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: progressFontSize,
              ),
            ),
            progressColor: Colors.white,
            backgroundColor: Colors.grey.shade300,
            barRadius: Radius.circular(40),
          ),
        ],
      ),
    );
  }
}
