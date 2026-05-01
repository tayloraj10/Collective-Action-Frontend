import 'package:collective_action_frontend/app/theme.dart';
import 'package:flutter/material.dart';

class NavigationButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final bool small;

  const NavigationButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.small = false,
  });

  @override
  State<NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? AppColors.lightBlue;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // On hover: fill with the section color. Icon/text flip to white.
    // On rest: transparent background with a colored border.
    final bgColor = _hovered ? effectiveColor : Colors.transparent;
    final borderColor = _hovered
        ? effectiveColor
        : effectiveColor.withAlpha(isDark ? 160 : 140);
    final contentColor = _hovered ? Colors.white : effectiveColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: bgColor,
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(8),
            splashColor: Colors.white.withAlpha(50),
            highlightColor: Colors.white.withAlpha(25),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.small ? 8 : 14,
                vertical: widget.small ? 5 : 9,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: contentColor,
                    size: widget.small ? 15 : 19,
                  ),
                  SizedBox(width: widget.small ? 5 : 7),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: widget.small ? 12 : 14,
                      fontWeight: FontWeight.w600,
                      color: contentColor,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
