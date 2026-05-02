import 'package:flutter/material.dart';

/// Shared category color resolver used across app surfaces.
///
/// Strategy:
/// - First, match known topic keywords for intentional semantic colors.
/// - Otherwise, pick from a curated palette using a stable hash of id/name.
///   This keeps new categories visually distinct without manual updates.
class CategoryColors {
  CategoryColors._();

  static const List<MapEntry<String, Color>> _topicColors = [
    MapEntry('environment', Color(0xFF16A34A)),
    MapEntry('nature', Color(0xFF65A30D)),
    MapEntry('water', Color(0xFF0284C7)),
    MapEntry('trash', Color(0xFF64748B)),
    MapEntry('animals', Color(0xFFEA580C)),
    MapEntry('fitness', Color(0xFFDC2626)),
  ];

  static const List<Color> _palette = [
    Color(0xFF059669),
    Color(0xFF2563EB),
    Color(0xFF7C3AED),
    Color(0xFFEA580C),
    Color(0xFF0D9488),
    Color(0xFFCA8A04),
    Color(0xFF0284C7),
    Color(0xFFEC4899),
    Color(0xFF14B8A6),
    Color(0xFF6366F1),
    Color(0xFF84CC16),
    Color(0xFFA855F7),
  ];

  static Color resolve({String? categoryName, String? stableKey}) {
    final name = (categoryName ?? '').trim();
    final lower = name.toLowerCase();
    for (final entry in _topicColors) {
      if (lower.contains(entry.key)) return entry.value;
    }

    final key = ((stableKey ?? '').trim().isNotEmpty ? stableKey! : name)
        .toLowerCase()
        .trim();
    if (key.isEmpty) return _palette.first;
    return _palette[_stableHash(key) % _palette.length];
  }

  static int _stableHash(String input) {
    var hash = 0;
    for (final code in input.codeUnits) {
      hash = ((hash * 31) + code) & 0x7fffffff;
    }
    return hash;
  }
}
