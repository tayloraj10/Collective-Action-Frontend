import 'package:collective_action_frontend/app/theme.dart';
import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: small ? 6 : 12,
            vertical: small ? 4 : 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (color ?? AppColors.lightBlue).withAlpha(128),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color ?? AppColors.lightBlue,
                size: small ? 16 : 20,
              ),
              SizedBox(width: small ? 4 : 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: small ? 12 : 14,
                  fontWeight: FontWeight.w500,
                  color: color ?? AppColors.lightBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
