import 'package:collective_action_frontend/app/theme.dart';
import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const NavigationButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.lightBlue.withAlpha(128),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.lightBlue, size: 20),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
