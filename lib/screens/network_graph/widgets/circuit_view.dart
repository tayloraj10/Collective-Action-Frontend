import 'dart:math' as math;

import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:collective_action_frontend/utils/external_network_image.dart';
import 'package:flutter/material.dart';

// ── Layout constants ───────────────────────────────────────────────────────

const double _kDogCardW  = 148.0;
const double _kDogCardH  = 74.0;
const double _kInitCardW = 160.0;
const double _kInitCardH = 86.0;
const double _kCardGapX = 12.0;
const double _kCardGapY = 10.0;
const double _kPadX     = 20.0;
const double _kPadTop   = 44.0;  // space above first row (label)
const double _kCatGap   = 28.0;  // gap between category sections
const double _kCatLabelH= 20.0;

// ── Palette ────────────────────────────────────────────────────────────────

const Color _kBg        = Color(0xFF0D1117);
const Color _kSurface   = Color(0xFF161B22);
const Color _kBorder    = Color(0xFF30363D);
const Color _kInitColor = Color(0xFF3B82F6);
const Color _kMapColor  = Color(0xFF16A34A);
const Color _kHubColor  = Color(0xFF6366F1);

const _kCatColors = [
  Color(0xFF6366F1), Color(0xFF0EA5E9), Color(0xFF10B981),
  Color(0xFFF59E0B), Color(0xFFEC4899), Color(0xFF14B8A6),
  Color(0xFFF97316), Color(0xFF84CC16), Color(0xFFEF4444),
];

int _stableColorIndex(String seed, int mod) {
  var hash = 0;
  for (final c in seed.codeUnits) {
    hash = ((hash * 31) + c) & 0x7fffffff;
  }
  return mod == 0 ? 0 : hash % mod;
}

const _kInitiativeColors = [
  Color(0xFF3B82F6), // blue
  Color(0xFF10B981), // emerald
  Color(0xFFF59E0B), // amber
  Color(0xFFEC4899), // pink
  Color(0xFF8B5CF6), // violet
  Color(0xFF06B6D4), // cyan
  Color(0xFFEF4444), // red
  Color(0xFF84CC16), // lime
  Color(0xFFF97316), // orange
  Color(0xFF14B8A6), // teal
  Color(0xFF22C55E), // green
  Color(0xFFA855F7), // purple
];

Color _initiativeColorForId(String id) {
  return _kInitiativeColors[
    _stableColorIndex(id, _kInitiativeColors.length)
  ];
}

// ── Main widget ────────────────────────────────────────────────────────────

class CircuitDirectoryView extends StatefulWidget {
  const CircuitDirectoryView({
    super.key,
    required this.dogs,
    required this.initiatives,
    required this.categories,
    required this.dogSummaries,
    required this.initSummaries,
    required this.myConns,
    required this.selectedId,
    required this.selectedInitiativeId,
    required this.onInitiativeFilterToggle,
    required this.onSelect,
  });

  final List<DirectoryOfGoodSchema> dogs;
  final List<InitiativeSchema> initiatives;
  final List<CategorySchema> categories;
  final Map<String, ConnectionSummarySchema> dogSummaries;
  final Map<String, ConnectionSummarySchema> initSummaries;
  final List<ConnectionWithUserSchema> myConns;
  final String? selectedId;
  final String? selectedInitiativeId;
  final ValueChanged<String> onInitiativeFilterToggle;
  final void Function(String id, String type) onSelect;

  @override
  State<CircuitDirectoryView> createState() => _CircuitDirectoryViewState();
}

class _CircuitDirectoryViewState extends State<CircuitDirectoryView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  final ScrollController _scrollController = ScrollController();
  Map<String?, double> _categoryOffsets = const {};
  String? _activeCategoryId;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_categoryOffsets.isEmpty) return;
    final offset = _scrollController.offset + 16;
    String? current = _activeCategoryId;
    final ordered = _categoryOffsets.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    for (final e in ordered) {
      if (e.value <= offset) current = e.key;
    }
    if (current != _activeCategoryId && mounted) {
      setState(() => _activeCategoryId = current);
    }
  }

  Future<void> _jumpToCategory(String? categoryId) async {
    final y = _categoryOffsets[categoryId];
    if (y == null || !_scrollController.hasClients) return;
    final target = (y - 8).clamp(0.0, _scrollController.position.maxScrollExtent);
    await _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LegendBar(
          initCount: widget.initiatives.length,
          dogCount: widget.dogs.length,
          connectionCount: widget.initSummaries.values
              .fold(0, (s, v) => s + v.orgIds.length),
        ),
        Expanded(
          child: Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? _kBg
                : const Color(0xFFEFF3F8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availW = constraints.maxWidth;
                final showRail = availW >= 1100;
                final railWidth = showRail ? 180.0 : 0.0;
                final canvasW = showRail
                    ? (availW - railWidth - 1).clamp(0.0, double.infinity).toDouble()
                    : availW;
                final cols = _cardsPerRow(canvasW);

                // Sort and group.
                final sortedInits = [...widget.initiatives]
                  ..sort((a, b) =>
                      (widget.initSummaries[b.id]?.totalCount ?? 0)
                          .compareTo(widget.initSummaries[a.id]?.totalCount ?? 0));

                final catById = {for (final c in widget.categories) c.id: c};
                final grouped = _groupDogs();
                final catKeys = grouped.keys.toList()
                  ..sort((a, b) {
                    if (a == null) return 1;
                    if (b == null) return -1;
                    return (catById[a]?.name ?? '')
                        .compareTo(catById[b]?.name ?? '');
                  });

                // Compute positions.
                final pos = _computePositions(
                    sortedInits, catKeys, grouped, cols, canvasW);
                _categoryOffsets = Map<String?, double>.from(pos.catLabelY);
                if (_activeCategoryId == null && catKeys.isNotEmpty) {
                  _activeCategoryId = catKeys.first;
                }

                // Connection map: initId → [dogId...]
                final Map<String, List<String>> initToDogs = {};
                for (final init in sortedInits) {
                  final orgIds =
                      widget.initSummaries[init.id]?.orgIds ?? [];
                  if (orgIds.isNotEmpty) {
                    initToDogs[init.id] = orgIds;
                  }
                }

                // Stable per-initiative colors used by cards + trace lines.
                final Map<String, Color> initColorById = {
                  for (final init in sortedInits) init.id: _initiativeColorForId(init.id),
                };

                // For each organization, keep a primary linked initiative color
                // (highest-priority initiative in the sorted list) and count.
                final Map<String, Color> dogPrimaryInitColor = {};
                final Map<String, int> dogLinkedInitCount = {};
                final Map<String, List<Color>> dogInitColors = {};
                for (final init in sortedInits) {
                  final initColor = initColorById[init.id] ?? _kInitColor;
                  final linkedDogIds = initToDogs[init.id] ?? const <String>[];
                  for (final dogId in linkedDogIds) {
                    dogLinkedInitCount[dogId] =
                        (dogLinkedInitCount[dogId] ?? 0) + 1;
                    dogPrimaryInitColor.putIfAbsent(dogId, () => initColor);
                    dogInitColors.putIfAbsent(dogId, () => []);
                    if (!dogInitColors[dogId]!.contains(initColor)) {
                      dogInitColors[dogId]!.add(initColor);
                    }
                  }
                }

                final scrollContent = SingleChildScrollView(
                  controller: _scrollController,
                  child: SizedBox(
                    width: availW,
                    height: pos.canvasH,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                          // Trace lines (always behind cards)
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (_, _) => CustomPaint(
                                painter: _TracePainter(
                                  positions: pos,
                                  initToDogs: initToDogs,
                                  initColorById: initColorById,
                                  selectedId: widget.selectedId,
                                  pulse: _pulseController.value,
                                ),
                              ),
                            ),
                          ),

                        // "INITIATIVES" label
                        Positioned(
                          left: _kPadX,
                          top: _kPadTop - 18,
                          child: _SectionLabel(
                              'INITIATIVES', _kInitColor),
                        ),

                        // Initiative cards
                        for (final init in sortedInits)
                          if (pos.initCenters.containsKey(init.id))
                            Positioned(
                              left: pos.initCenters[init.id]!.dx -
                                  _kInitCardW / 2,
                              top: pos.initCenters[init.id]!.dy -
                                  _kInitCardH / 2,
                              child: _InitCard(
                                init: init,
                                summary: widget.initSummaries[init.id],
                                accentColor:
                                    initColorById[init.id] ?? _kInitColor,
                                isSelected: widget.selectedId == init.id,
                                isFilterActive:
                                    widget.selectedInitiativeId == init.id,
                                onFilterTap: () =>
                                    widget.onInitiativeFilterToggle(init.id),
                                isContributing: widget.myConns.any((c) =>
                                    c.toType == 'initiative' &&
                                    c.toId == init.id &&
                                    c.fromType == 'user'),
                                onTap: () =>
                                    widget.onSelect(init.id, 'initiative'),
                              ),
                            ),

                        // Category labels + DoG cards
                        ..._buildCategoryWidgets(
                          catKeys, catById, grouped,
                          pos, widget.dogSummaries, widget.myConns,
                          widget.selectedId, widget.onSelect,
                          dogPrimaryInitColor, dogLinkedInitCount, dogInitColors,
                        ),
                      ],
                    ),
                  ),
                );

                final showDesktopRail = showRail && catKeys.isNotEmpty;
                final showTopBar = !showDesktopRail && catKeys.isNotEmpty;
                final categoryBar = !showTopBar
                    ? const SizedBox.shrink()
                    : _CategoryJumpBar(
                        categories: catKeys
                            .map((id) => (
                                  id,
                                  catById[id]?.name ?? 'Other',
                                  (grouped[id] ?? const <DirectoryOfGoodSchema>[]).length,
                                ))
                            .toList(),
                        activeCategoryId: _activeCategoryId,
                        onTap: _jumpToCategory,
                      );

                return Column(
                  children: [
                    if (showTopBar) categoryBar,
                    Expanded(
                      child: showDesktopRail
                          ? Row(
                              children: [
                                Expanded(child: scrollContent),
                                Container(
                                  width: 1,
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withAlpha(70),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: _CategoryOverviewRail(
                                    categories: catKeys
                                        .map((id) => (
                                              id,
                                              catById[id]?.name ?? 'Other',
                                              (grouped[id] ?? const <DirectoryOfGoodSchema>[]).length,
                                            ))
                                        .toList(),
                                    activeCategoryId: _activeCategoryId,
                                    onTap: _jumpToCategory,
                                  ),
                                ),
                              ],
                            )
                          : scrollContent,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  int _cardsPerRow(double availW) {
    final computed = ((availW - 2 * _kPadX + _kCardGapX) /
            (_kInitCardW + _kCardGapX))
        .floor()
        .clamp(1, 999);
    // On mobile-ish widths, force at least 2 columns for denser initiative layout.
    if (availW <= 520) return computed.clamp(2, 999);
    return computed;
  }

  Map<String?, List<DirectoryOfGoodSchema>> _groupDogs() {
    final Map<String?, List<DirectoryOfGoodSchema>> grouped = {};
    for (final d in widget.dogs) {
      final key =
          d.categoryIds.isNotEmpty ? d.categoryIds.first : null;
      grouped.putIfAbsent(key, () => []).add(d);
    }
    for (final list in grouped.values) {
      list.sort((a, b) {
        final idA = a.id ?? a.name;
        final idB = b.id ?? b.name;
        return (widget.dogSummaries[idB]?.totalCount ?? 0)
            .compareTo(widget.dogSummaries[idA]?.totalCount ?? 0);
      });
    }
    return grouped;
  }

  _LayoutPositions _computePositions(
    List<InitiativeSchema> sortedInits,
    List<String?> catKeys,
    Map<String?, List<DirectoryOfGoodSchema>> grouped,
    int cols,
    double availW,
  ) {
    // Left-aligned row builder: returns center offsets for [count] cards.
    List<Offset> rowCenters(
      int count,
      double rowTopY, {
      required double cardW,
      required double cardH,
    }) {
      final result = <Offset>[];
      for (int i = 0; i < count; i++) {
        final x = _kPadX + i % cols * (_kInitCardW + _kCardGapX) +
            cardW / 2;
        final y = rowTopY +
            (i ~/ cols) * (cardH + _kCardGapY) +
            cardH / 2;
        result.add(Offset(x, y));
      }
      return result;
    }

    // Initiative row.
    final initRowTop = _kPadTop;
    final initCenters = <String, Offset>{};
    final initOffsets = rowCenters(
      sortedInits.length,
      initRowTop,
      cardW: _kInitCardW,
      cardH: _kInitCardH,
    );
    for (int i = 0; i < sortedInits.length; i++) {
      initCenters[sortedInits[i].id] = initOffsets[i];
    }
    final initRows = (sortedInits.length / cols).ceil().clamp(1, 999);
    double cursorY = initRowTop +
        initRows * (_kInitCardH + _kCardGapY) +
        _kCatGap;

    // Category sections.
    final catLabelY = <String?, double>{};
    final dogCenters = <String, Offset>{};

    for (final catId in catKeys) {
      catLabelY[catId] = cursorY;
      cursorY += _kCatLabelH;

      final entries = grouped[catId] ?? [];
      final offsets = rowCenters(
        entries.length,
        cursorY,
        cardW: _kDogCardW,
        cardH: _kDogCardH,
      );
      for (int d = 0; d < entries.length; d++) {
        final id = entries[d].id ?? entries[d].name;
        dogCenters[id] = offsets[d];
      }
      final rows = (entries.length / cols).ceil().clamp(1, 999);
      cursorY +=
          rows * (_kDogCardH + _kCardGapY) + _kCatGap;
    }

    return _LayoutPositions(
      canvasH: cursorY + 32,
      initCenters: initCenters,
      catLabelY: catLabelY,
      dogCenters: dogCenters,
    );
  }

  List<Widget> _buildCategoryWidgets(
    List<String?> catKeys,
    Map<String?, CategorySchema> catById,
    Map<String?, List<DirectoryOfGoodSchema>> grouped,
    _LayoutPositions pos,
    Map<String, ConnectionSummarySchema> dogSummaries,
    List<ConnectionWithUserSchema> myConns,
    String? selectedId,
    void Function(String, String) onSelect,
    Map<String, Color> dogPrimaryInitColor,
    Map<String, int> dogLinkedInitCount,
    Map<String, List<Color>> dogInitColors,
  ) {
    final widgets = <Widget>[];
    for (int ci = 0; ci < catKeys.length; ci++) {
      final catId    = catKeys[ci];
      final catName  = catById[catId]?.name ?? 'Other';
      final catColor = _kCatColors[ci % _kCatColors.length];
      final labelY   = pos.catLabelY[catId]!;

      widgets.add(Positioned(
        left: _kPadX, top: labelY,
        child: _SectionLabel(catName.toUpperCase(), catColor),
      ));

      for (final dog in grouped[catId] ?? []) {
        final dogId = dog.id ?? dog.name;
        final center = pos.dogCenters[dogId];
        if (center == null) continue;
        widgets.add(Positioned(
          left: center.dx - _kDogCardW / 2,
          top: center.dy - _kDogCardH / 2,
          child: _DogCard(
            dog: dog,
            summary: dogSummaries[dogId],
            linkedInitColor: dogPrimaryInitColor[dogId],
            linkedInitCount: dogLinkedInitCount[dogId] ?? 0,
            linkedInitColors: dogInitColors[dogId] ?? const [],
            isSelected: selectedId == dogId,
            isFollowing: myConns.any((c) =>
                c.toType == 'directory_of_good' &&
                c.toId == dogId &&
                c.fromType == 'user'),
            onTap: () => onSelect(dogId, 'directory_of_good'),
          ),
        ));
      }
    }
    return widgets;
  }
}

// ── Position data ──────────────────────────────────────────────────────────

class _LayoutPositions {
  const _LayoutPositions({
    required this.canvasH,
    required this.initCenters,
    required this.catLabelY,
    required this.dogCenters,
  });

  final double canvasH;
  final Map<String, Offset> initCenters;  // initId → card centre
  final Map<String?, double> catLabelY;
  final Map<String, Offset> dogCenters;   // dogId → card centre
}

// ── Trace painter ──────────────────────────────────────────────────────────

class _TracePainter extends CustomPainter {
  const _TracePainter({
    required this.positions,
    required this.initToDogs,
    required this.initColorById,
    required this.selectedId,
    required this.pulse,
  });

  final _LayoutPositions positions;
  final Map<String, List<String>> initToDogs;
  final Map<String, Color> initColorById;
  final String? selectedId;
  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    int ci = 0;
    for (final entry in initToDogs.entries) {
      final initCenter = positions.initCenters[entry.key];
      if (initCenter == null) continue;

      final color = initColorById[entry.key] ?? _kInitColor;
      final isHighlighted = selectedId == entry.key ||
          entry.value.contains(selectedId);
      final pulseWave =
          0.45 + 0.55 * math.sin((pulse * 2 * math.pi) + (ci * 0.7));

      final glowPaint = Paint()
        ..color = color.withAlpha((90 + 85 * pulseWave).round().clamp(0, 255))
        ..strokeWidth = isHighlighted ? 3.2 : 2.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final corePaint = Paint()
        ..color = color.withAlpha((170 + 70 * pulseWave).round().clamp(0, 255))
        ..strokeWidth = isHighlighted ? 2.0 : 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final fromY = initCenter.dy + _kInitCardH / 2;

      for (final dogId in entry.value) {
        final dogCenter = positions.dogCenters[dogId];
        if (dogCenter == null) continue;

        final toY = dogCenter.dy - _kDogCardH / 2;

        // Orthogonal trace: down from init, horizontal bus, down to dog.
        final busY = fromY + (toY - fromY) * 0.35;
        final path = Path()
          ..moveTo(initCenter.dx, fromY + 2)
          ..lineTo(initCenter.dx, busY)
          ..lineTo(dogCenter.dx, busY)
          ..lineTo(dogCenter.dx, toY - 2);
        canvas.drawPath(path, glowPaint);
        canvas.drawPath(path, corePaint);

        // Traveling spark to mimic electrical flow.
        final p0 = Offset(initCenter.dx, fromY + 2);
        final p1 = Offset(initCenter.dx, busY);
        final p2 = Offset(dogCenter.dx, busY);
        final p3 = Offset(dogCenter.dx, toY - 2);
        final seg1 = (p1 - p0).distance;
        final seg2 = (p2 - p1).distance;
        final seg3 = (p3 - p2).distance;
        final totalLen = seg1 + seg2 + seg3;
        if (totalLen > 0) {
          final travel = ((pulse * totalLen) + (ci * 27)) % totalLen;
          final spark = _pointAlongSegments(p0, p1, p2, p3, seg1, seg2, seg3, travel);
          canvas.drawCircle(
            spark,
            isHighlighted ? 2.4 : 2.0,
            Paint()..color = Colors.white.withAlpha(230),
          );
          canvas.drawCircle(
            spark,
            isHighlighted ? 3.4 : 3.0,
            Paint()
              ..color = color.withAlpha(160)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.2,
          );
        }

        if (isHighlighted) {
          canvas.drawCircle(
            Offset(initCenter.dx, fromY + 2), 3,
            Paint()..color = color..style = PaintingStyle.fill,
          );
          canvas.drawCircle(
            Offset(dogCenter.dx, toY - 2), 3,
            Paint()
              ..color = _kMapColor
              ..style = PaintingStyle.fill,
          );
        }
      }
      ci++;
    }
  }

  Offset _pointAlongSegments(
    Offset p0,
    Offset p1,
    Offset p2,
    Offset p3,
    double seg1,
    double seg2,
    double seg3,
    double d,
  ) {
    if (d <= seg1 && seg1 > 0) {
      final t = d / seg1;
      return Offset.lerp(p0, p1, t)!;
    }
    final d2 = d - seg1;
    if (d2 <= seg2 && seg2 > 0) {
      final t = d2 / seg2;
      return Offset.lerp(p1, p2, t)!;
    }
    final d3 = (d2 - seg2).clamp(0.0, seg3);
    final t = seg3 > 0 ? d3 / seg3 : 0.0;
    return Offset.lerp(p2, p3, t)!;
  }

  @override
  bool shouldRepaint(_TracePainter old) =>
      old.initToDogs != initToDogs ||
      old.selectedId != selectedId ||
      old.pulse != pulse;
}

// ── Cards ──────────────────────────────────────────────────────────────────

class _InitCard extends StatelessWidget {
  const _InitCard({
    required this.init,
    required this.summary,
    required this.accentColor,
    required this.isSelected,
    required this.isFilterActive,
    required this.onFilterTap,
    required this.isContributing,
    required this.onTap,
  });

  final InitiativeSchema init;
  final ConnectionSummarySchema? summary;
  final Color accentColor;
  final bool isSelected;
  final bool isFilterActive;
  final VoidCallback onFilterTap;
  final bool isContributing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final total = summary?.totalCount ?? 0;
    final hasPreviewUsers = (summary?.userCount ?? 0) > 0;
    final progress = (init.goal ?? 0) > 0
        ? ((init.complete ?? 0) / (init.goal ?? 1)).clamp(0.0, 1.0)
        : null;
    final percentLabel = progress != null ? '${(progress * 100).round()}%' : null;

    return _CircuitCard(
      accentColor: accentColor,
      isSelected: isSelected,
      isConnected: isContributing,
      emphasize: true,
      width: _kInitCardW,
      height: _kInitCardH,
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: accentColor.withAlpha(35),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: accentColor.withAlpha(110)),
                    ),
                    child: Text(
                      'INITIATIVE',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Tooltip(
                    message: isFilterActive
                        ? 'Clear initiative filter'
                        : 'Filter to this initiative',
                    child: GestureDetector(
                      onTap: onFilterTap,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: isFilterActive
                              ? accentColor.withAlpha(38)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isFilterActive
                                ? accentColor.withAlpha(180)
                                : accentColor.withAlpha(90),
                          ),
                        ),
                        child: Icon(
                          isFilterActive ? Icons.filter_alt : Icons.filter_list,
                          size: 11,
                          color: isFilterActive
                              ? accentColor
                              : accentColor.withAlpha(200),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 2),
              Row(children: [
                Icon(Icons.trending_up,
                    size: 12, color: accentColor),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(init.title,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
                if (total > 0) ...[
                  const SizedBox(width: 4),
                  _Badge('$total', accentColor),
                ],
              ]),
              if (progress != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 5,
                          backgroundColor: accentColor.withAlpha(20),
                          valueColor:
                              AlwaysStoppedAnimation(accentColor),
                        ),
                      ),
                    ),
                    if (percentLabel != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        percentLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
          if (hasPreviewUsers)
            Positioned(
              top: -10,
              right: -8,
              child: _PreviewAvatarCluster(
                users: summary?.previewUsers ?? const [],
                totalUserCount: summary?.userCount ?? 0,
                accentColor: accentColor,
              ),
            ),
        ],
      ),
    );
  }
}

class _DogCard extends StatelessWidget {
  const _DogCard({
    required this.dog,
    required this.summary,
    required this.linkedInitColor,
    required this.linkedInitCount,
    required this.linkedInitColors,
    required this.isSelected,
    required this.isFollowing,
    required this.onTap,
  });

  final DirectoryOfGoodSchema dog;
  final ConnectionSummarySchema? summary;
  final Color? linkedInitColor;
  final int linkedInitCount;
  final List<Color> linkedInitColors;
  final bool isSelected;
  final bool isFollowing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = dog.imageUrl?.trim();
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    final total = summary?.totalCount ?? 0;
    final linkColor = linkedInitColor;
    final hasInitLink = linkColor != null && linkedInitCount > 0;

    Widget card = _CircuitCard(
      accentColor: hasInitLink ? linkColor : _kMapColor,
      isSelected: isSelected,
      isConnected: hasInitLink,
      connectedBorderWidth: hasInitLink ? 2.4 : 1.2,
      strongConnectedGlow: hasInitLink,
      width: _kDogCardW,
      height: _kDogCardH,
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _kMapColor.withAlpha(25)),
                  child: ClipOval(
                    child: hasImage
                        ? ExternalOrDataImage(
                            url: imageUrl,
                            width: 28, height: 28,
                            fit: BoxFit.cover,
                            preferHtmlElementOnWeb: false,
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Text(
                                dog.name.isNotEmpty
                                    ? dog.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                    color: _kMapColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700),
                              ),
                            ))
                        : Center(
                            child: Text(
                              dog.name.isNotEmpty
                                  ? dog.name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                  color: _kMapColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(dog.name,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              height: 1.2),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      if ((dog.location?.city ?? '').isNotEmpty)
                        Text(
                          [dog.location?.city, dog.location?.state]
                              .whereType<String>()
                              .where((s) => s.isNotEmpty)
                              .join(', '),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(150),
                              fontSize: 9,
                              height: 1.2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (total > 0) ...[
                  const SizedBox(width: 4),
                  _Badge('$total', _kMapColor),
                ],
              ]),
            ],
          ),
          if ((summary?.userCount ?? 0) > 0)
            Positioned(
              top: -10,
              right: -8,
              child: _PreviewAvatarCluster(
                users: summary?.previewUsers ?? const [],
                totalUserCount: summary?.userCount ?? 0,
                accentColor: _kMapColor,
              ),
            ),
        ],
      ),
    );
    if (linkedInitColors.length > 1) {
      final rainbow = [...linkedInitColors, linkedInitColors.first];
      card = Container(
        width: _kDogCardW,
        height: _kDogCardH,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          gradient: SweepGradient(
            colors: rainbow,
            transform: const GradientRotation(math.pi / 6),
          ),
          boxShadow: [
            BoxShadow(
              color: linkedInitColors.first.withAlpha(90),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.8),
          child: card,
        ),
      );
    }
    return card;
  }
}

class _CircuitCard extends StatelessWidget {
  const _CircuitCard({
    required this.accentColor,
    required this.isSelected,
    required this.isConnected,
    this.emphasize = false,
    this.connectedBorderWidth = 1.0,
    this.strongConnectedGlow = false,
    required this.width,
    required this.height,
    required this.onTap,
    required this.child,
  });

  final Color accentColor;
  final bool isSelected;
  final bool isConnected;
  final bool emphasize;
  final double connectedBorderWidth;
  final bool strongConnectedGlow;
  final double width;
  final double height;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? _kSurface : const Color(0xFFF7FAFD);
    final border = isDark ? _kBorder : const Color(0xFFC5D0DF);
    final fillColor = emphasize
        ? Color.lerp(surface, accentColor, isSelected ? 0.2 : 0.13)!
        : surface;
    return GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            width: width,
            height: height,
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              gradient: null,
              color: fillColor,
              borderRadius: BorderRadius.circular(emphasize ? 10 : 6),
              border: Border.all(
                color: isSelected
                    ? accentColor
                    : emphasize
                        ? accentColor.withAlpha(130)
                    : isConnected
                        ? accentColor.withAlpha(220)
                        : border,
                width: isSelected || emphasize
                    ? 1.6
                    : isConnected
                        ? connectedBorderWidth
                        : 1.0,
              ),
              boxShadow: isSelected || emphasize || (isConnected && strongConnectedGlow)
                  ? [
                      BoxShadow(
                          color: accentColor.withAlpha(
                            isSelected
                                ? 75
                                : (strongConnectedGlow ? 95 : 42),
                          ),
                          blurRadius: isSelected
                              ? 14
                              : (strongConnectedGlow ? 14 : 10),
                          spreadRadius: strongConnectedGlow ? 1.3 : 1),
                    ]
                  : [],
            ),
            child: child,
          ),
        ),
      );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text,
            style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w700)),
      );
}

class _PreviewAvatarCluster extends StatelessWidget {
  const _PreviewAvatarCluster({
    required this.users,
    required this.totalUserCount,
    required this.accentColor,
  });

  final List<PreviewUserSchema> users;
  final int totalUserCount;
  final Color accentColor;

  static const double _size = 18;
  static const double _overlap = 12;
  static const int _maxVisible = 5;

  @override
  Widget build(BuildContext context) {
    final visible = users.take(_maxVisible).toList();
    final overflow = (totalUserCount - _maxVisible).clamp(0, 9999);
    final bubbles = visible.length + (overflow > 0 ? 1 : 0);
    if (bubbles == 0) return const SizedBox.shrink();
    final width = _size + (bubbles - 1) * _overlap;

    return SizedBox(
      width: width,
      height: _size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < visible.length; i++)
            Positioned(
              left: i * _overlap,
              child: _AvatarBubble(user: visible[i], accentColor: accentColor),
            ),
          if (overflow > 0)
            Positioned(
              left: visible.length * _overlap,
              child: _OverflowBubble(count: overflow, accentColor: accentColor),
            ),
        ],
      ),
    );
  }
}

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({required this.user, required this.accentColor});

  final PreviewUserSchema user;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final userId = user.id.trim();
    final letter = (user.name?.trim().isNotEmpty ?? false)
        ? user.name!.trim()[0].toUpperCase()
        : '?';
    Widget fallback() => Container(
          color: accentColor.withAlpha(35),
          alignment: Alignment.center,
          child: Text(
            letter,
            style: TextStyle(
              color: accentColor,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
    return Container(
      width: _PreviewAvatarCluster._size,
      height: _PreviewAvatarCluster._size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: accentColor.withAlpha(180), width: 1),
      ),
      child: ClipOval(
        child: userId.isNotEmpty
            ? UserAvatar(
                userId: userId,
                radius: _PreviewAvatarCluster._size / 2,
                borderWidth: 0,
                accentColorOverride: accentColor,
                cardColorOverride: accentColor.withAlpha(35),
                showTooltip: false,
                enableHero: false,
                showProfileOnTap: true,
              )
            : fallback(),
      ),
    );
  }
}

class _OverflowBubble extends StatelessWidget {
  const _OverflowBubble({required this.count, required this.accentColor});

  final int count;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _PreviewAvatarCluster._size,
      height: _PreviewAvatarCluster._size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accentColor,
        border: Border.all(color: accentColor.withAlpha(200), width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        '+$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 7.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
            color: color.withAlpha(180),
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4),
      );
}

class _CategoryJumpBar extends StatelessWidget {
  const _CategoryJumpBar({
    required this.categories,
    required this.activeCategoryId,
    required this.onTap,
  });

  final List<(String?, String, int)> categories;
  final String? activeCategoryId;
  final ValueChanged<String?> onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? _kSurface.withAlpha(235) : const Color(0xFFF3F7FB),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withAlpha(90),
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: categories.map((c) {
              final isActive = c.$1 == activeCategoryId;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => onTap(c.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: isActive
                          ? LinearGradient(
                              colors: [
                                _kHubColor.withAlpha(46),
                                _kHubColor.withAlpha(22),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isActive ? null : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isActive
                            ? _kHubColor.withAlpha(185)
                            : Theme.of(context).dividerColor.withAlpha(110),
                      ),
                    ),
                    child: Text(
                      '${c.$2} (${c.$3})',
                      style: TextStyle(
                        color: isActive
                            ? _kHubColor
                            : Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryOverviewRail extends StatelessWidget {
  const _CategoryOverviewRail({
    required this.categories,
    required this.activeCategoryId,
    required this.onTap,
  });

  final List<(String?, String, int)> categories;
  final String? activeCategoryId;
  final ValueChanged<String?> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? _kSurface.withAlpha(120)
          : const Color(0xFFF3F7FB),
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OVERVIEW',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(170),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final item = categories[index];
                final isActive = item.$1 == activeCategoryId;
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => onTap(item.$1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                    decoration: BoxDecoration(
                      color: isActive ? _kHubColor.withAlpha(24) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isActive
                            ? _kHubColor.withAlpha(160)
                            : Theme.of(context).dividerColor.withAlpha(90),
                      ),
                    ),
                    child: Text(
                      '${item.$2} (${item.$3})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isActive
                            ? _kHubColor
                            : Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Legend bar ─────────────────────────────────────────────────────────────

class _LegendBar extends StatelessWidget {
  const _LegendBar({
    required this.initCount,
    required this.dogCount,
    required this.connectionCount,
  });

  final int initCount;
  final int dogCount;
  final int connectionCount;

  @override
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? _kSurface
            : const Color(0xFFF3F7FB),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        child: Wrap(
          spacing: 14,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _L(_kInitColor, '$initCount initiatives'),
            _L(_kMapColor, '$dogCount organizations'),
            if (connectionCount > 0)
              _L(
                _kInitColor,
                '$connectionCount org connection${connectionCount == 1 ? '' : 's'}',
                dashed: true,
              ),
            Text(
              'Tap a card to view details',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
}

class _L extends StatelessWidget {
  const _L(this.color, this.label, {this.dashed = false});
  final Color color;
  final String label;
  final bool dashed;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 1.5,
              color: dashed ? Colors.transparent : color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                  fontSize: 10)),
        ],
      );
}
