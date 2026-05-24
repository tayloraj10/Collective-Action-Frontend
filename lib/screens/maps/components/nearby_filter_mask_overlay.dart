import 'package:flutter/material.dart';

/// Dims the map everywhere except a circular cutout (area outside the circle).
class NearbyFilterMaskOverlay extends StatelessWidget {
  const NearbyFilterMaskOverlay({
    super.key,
    required this.center,
    required this.radius,
    required this.dimColor,
    this.borderColor,
    this.borderWidth = 2,
  });

  final Offset center;
  final double radius;
  final Color dimColor;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _NearbyFilterMaskPainter(
          center: center,
          radius: radius,
          dimColor: dimColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _NearbyFilterMaskPainter extends CustomPainter {
  _NearbyFilterMaskPainter({
    required this.center,
    required this.radius,
    required this.dimColor,
    this.borderColor,
    required this.borderWidth,
  });

  final Offset center;
  final double radius;
  final Color dimColor;
  final Color? borderColor;
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final dimPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(dimPath, Paint()..color = dimColor);

    if (borderColor != null && borderWidth > 0) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = borderColor!
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NearbyFilterMaskPainter oldDelegate) {
    return oldDelegate.center != center ||
        oldDelegate.radius != radius ||
        oldDelegate.dimColor != dimColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth;
  }
}
