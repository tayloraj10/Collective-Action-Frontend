import 'package:collective_action_frontend/providers/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reusable chip that displays a category by ID (looks up name from
/// [categoriesProvider]) or by an explicit [label]. Each category gets a
/// topic-related color (e.g. environment = green, education = blue).
///
/// Use [categoryId] when you have the backend category id; use [label]
/// when you already have the display name (e.g. from another source).
/// If both are null or the category is not found, renders nothing.
class CategoryChip extends ConsumerWidget {
  /// Backend category id. The chip looks up the category name from
  /// [categoriesProvider]. Ignored if [label] is non-null.
  final String? categoryId;

  /// Display label. When set, [categoryId] is ignored and this is shown.
  final String? label;

  /// Optional compact style (smaller padding and text).
  final bool compact;

  /// When true, chip is shown as selected (filled style). Use for filter chips.
  final bool selected;

  /// When set, the chip is tappable (e.g. for filter row).
  final VoidCallback? onTap;

  /// Override the topic color (e.g. neutral for an "All" chip).
  final Color? colorOverride;

  const CategoryChip({
    super.key,
    this.categoryId,
    this.label,
    this.compact = false,
    this.selected = false,
    this.onTap,
    this.colorOverride,
  });

  /// Topic-related colors. Keys are lowercase; category name is matched
  /// case-insensitively. Longer keys are checked first so "mental health"
  /// wins over "health". Add entries as you add categories.
  static const List<MapEntry<String, Color>> _topicColors = [
    MapEntry('environment', Color(0xFF16A34A)), // green – planet, eco
    MapEntry('water', Color(0xFF0284C7)), // blue – water, ocean
    MapEntry('trash', Color(0xFF64748B)), // slate – cleanup, waste
    MapEntry('animals', Color(0xFFEA580C)), // orange – wildlife
    MapEntry('fitness', Color(0xFFDC2626)), // red – activity, movement
  ];

  /// Fallback palette when category name doesn't match [_topicColors].
  static const List<Color> _palette = [
    Color(0xFF059669),
    Color(0xFF2563EB),
    Color(0xFF7C3AED),
    Color(0xFFEA580C),
    Color(0xFF0D9488),
    Color(0xFFCA8A04),
    Color(0xFF0284C7),
    Color(0xFFEC4899),
  ];

  static Color _colorForCategory(String name) {
    final lower = name.toLowerCase();
    for (final entry in _topicColors) {
      if (lower.contains(entry.key)) return entry.value;
    }
    final hash = lower.hashCode.abs();
    return _palette[hash % _palette.length];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayLabel = label ?? _resolveName(ref, categoryId);
    if (displayLabel == null || displayLabel.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final padding = compact
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
    final fontSize = compact ? 11.0 : 12.0;
    final color = colorOverride ?? _colorForCategory(displayLabel);

    final backgroundColor = selected
        ? color
        : color.withAlpha(isDark ? 60 : 26);
    final borderColor = selected
        ? color
        : color.withAlpha(isDark ? 120 : 100);
    final textColor = selected ? Colors.white : color;

    final chip = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        displayLabel,
        style: theme.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: chip,
        ),
      );
    }
    return chip;
  }

  static String? _resolveName(WidgetRef ref, String? id) {
    if (id == null || id.isEmpty) return null;
    final categories = ref.watch(categoriesProvider).asData?.value;
    if (categories == null) return null;
    try {
      return categories.firstWhere((c) => c.id == id).name;
    } catch (_) {
      return null;
    }
  }
}
