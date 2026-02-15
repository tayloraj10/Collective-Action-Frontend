import 'package:flutter/material.dart';

/// A single stat row: icon, label, and value (e.g. "Total Cleanups: 42").
/// [showDivider] adds a thin light gray line below the row.
class Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;
  final bool showDivider;

  const Stat({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.color,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: effectiveColor, size: 22),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
    if (!showDivider) return row;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        row,
        Divider(height: 1, color: theme.dividerColor.withValues(alpha: 0.5)),
      ],
    );
  }
}
