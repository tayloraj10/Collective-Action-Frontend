import 'package:collective_action_frontend/api/lib/api.dart';
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
          Text(
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
          if (initiative.action.isNotEmpty) ...[
            SizedBox(height: isMobile ? 4 : 6),
            Text(
              initiative.action,
              style: TextStyle(
                color: Colors.white70,
                fontSize: descFontSize,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          SizedBox(height: spacing),
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
