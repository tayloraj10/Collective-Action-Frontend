import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/utils/external_network_image.dart';
import 'package:flutter/material.dart';

// ── Layout constants ───────────────────────────────────────────────────────

const double _kCardW    = 148.0;
const double _kCardH    = 56.0;
const double _kCardGapX = 10.0;
const double _kCardGapY = 8.0;
const double _kPadX     = 20.0;
const double _kPadTop   = 52.0;  // space above first row (label)
const double _kCatGap   = 28.0;  // gap between category sections
const double _kCatLabelH= 20.0;

// ── Palette ────────────────────────────────────────────────────────────────

const Color _kBg        = Color(0xFF0D1117);
const Color _kSurface   = Color(0xFF161B22);
const Color _kBorder    = Color(0xFF30363D);
const Color _kTextPri   = Color(0xFFE6EDF3);
const Color _kTextMut   = Color(0xFF8B949E);
const Color _kInitColor = Color(0xFF3B82F6);
const Color _kMapColor  = Color(0xFF16A34A);

const _kCatColors = [
  Color(0xFF6366F1), Color(0xFF0EA5E9), Color(0xFF10B981),
  Color(0xFFF59E0B), Color(0xFFEC4899), Color(0xFF14B8A6),
  Color(0xFFF97316), Color(0xFF84CC16), Color(0xFFEF4444),
];

const _kTraceColors = [
  Color(0xFF3B82F6), Color(0xFF10B981), Color(0xFFF59E0B),
  Color(0xFFEC4899), Color(0xFF8B5CF6), Color(0xFF14B8A6),
  Color(0xFFF97316), Color(0xFF06B6D4), Color(0xFF84CC16),
];

// ── Main widget ────────────────────────────────────────────────────────────

class CircuitDirectoryView extends StatelessWidget {
  const CircuitDirectoryView({
    super.key,
    required this.dogs,
    required this.initiatives,
    required this.categories,
    required this.dogSummaries,
    required this.initSummaries,
    required this.myConns,
    required this.selectedId,
    required this.onSelect,
  });

  final List<DirectoryOfGoodSchema> dogs;
  final List<InitiativeSchema> initiatives;
  final List<CategorySchema> categories;
  final Map<String, ConnectionSummarySchema> dogSummaries;
  final Map<String, ConnectionSummarySchema> initSummaries;
  final List<ConnectionWithUserSchema> myConns;
  final String? selectedId;
  final void Function(String id, String type) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LegendBar(
          initCount: initiatives.length,
          dogCount: dogs.length,
          connectionCount: initSummaries.values
              .fold(0, (s, v) => s + v.orgIds.length),
        ),
        Expanded(
          child: Container(
            color: _kBg,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availW = constraints.maxWidth;
                final cols = _cardsPerRow(availW);

                // Sort and group.
                final sortedInits = [...initiatives]
                  ..sort((a, b) =>
                      (initSummaries[b.id]?.totalCount ?? 0)
                          .compareTo(initSummaries[a.id]?.totalCount ?? 0));

                final catById = {for (final c in categories) c.id: c};
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
                    sortedInits, catKeys, grouped, cols, availW);

                // Connection map: initId → [dogId...]
                final Map<String, List<String>> initToDogs = {};
                for (final init in sortedInits) {
                  final orgIds =
                      initSummaries[init.id]?.orgIds ?? [];
                  if (orgIds.isNotEmpty) {
                    initToDogs[init.id] = orgIds;
                  }
                }

                return SingleChildScrollView(
                  child: SizedBox(
                    width: availW,
                    height: pos.canvasH,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Trace lines
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _TracePainter(
                              positions: pos,
                              initToDogs: initToDogs,
                              selectedId: selectedId,
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
                                  _kCardW / 2,
                              top: pos.initCenters[init.id]!.dy -
                                  _kCardH / 2,
                              child: _InitCard(
                                init: init,
                                summary: initSummaries[init.id],
                                isSelected: selectedId == init.id,
                                isContributing: myConns.any((c) =>
                                    c.toType == 'initiative' &&
                                    c.toId == init.id &&
                                    c.fromType == 'user'),
                                onTap: () =>
                                    onSelect(init.id, 'initiative'),
                              ),
                            ),

                        // Category labels + DoG cards
                        ..._buildCategoryWidgets(
                          catKeys, catById, grouped,
                          pos, dogSummaries, myConns,
                          selectedId, onSelect,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  int _cardsPerRow(double availW) =>
      ((availW - 2 * _kPadX + _kCardGapX) /
              (_kCardW + _kCardGapX))
          .floor()
          .clamp(1, 999);

  Map<String?, List<DirectoryOfGoodSchema>> _groupDogs() {
    final Map<String?, List<DirectoryOfGoodSchema>> grouped = {};
    for (final d in dogs) {
      final key =
          d.categoryIds.isNotEmpty ? d.categoryIds.first : null;
      grouped.putIfAbsent(key, () => []).add(d);
    }
    for (final list in grouped.values) {
      list.sort((a, b) {
        final idA = a.id ?? a.name;
        final idB = b.id ?? b.name;
        return (dogSummaries[idB]?.totalCount ?? 0)
            .compareTo(dogSummaries[idA]?.totalCount ?? 0);
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
    List<Offset> rowCenters(int count, double rowTopY) {
      final result = <Offset>[];
      for (int i = 0; i < count; i++) {
        final x = _kPadX + i % cols * (_kCardW + _kCardGapX) +
            _kCardW / 2;
        final y = rowTopY +
            (i ~/ cols) * (_kCardH + _kCardGapY) +
            _kCardH / 2;
        result.add(Offset(x, y));
      }
      return result;
    }

    // Initiative row.
    final initRowTop = _kPadTop;
    final initCenters = <String, Offset>{};
    final initOffsets =
        rowCenters(sortedInits.length, initRowTop);
    for (int i = 0; i < sortedInits.length; i++) {
      initCenters[sortedInits[i].id] = initOffsets[i];
    }
    final initRows = (sortedInits.length / cols).ceil().clamp(1, 999);
    double cursorY = initRowTop +
        initRows * (_kCardH + _kCardGapY) +
        _kCatGap;

    // Category sections.
    final catLabelY = <String?, double>{};
    final dogCenters = <String, Offset>{};

    for (final catId in catKeys) {
      catLabelY[catId] = cursorY;
      cursorY += _kCatLabelH;

      final entries = grouped[catId] ?? [];
      final offsets = rowCenters(entries.length, cursorY);
      for (int d = 0; d < entries.length; d++) {
        final id = entries[d].id ?? entries[d].name;
        dogCenters[id] = offsets[d];
      }
      final rows = (entries.length / cols).ceil().clamp(1, 999);
      cursorY +=
          rows * (_kCardH + _kCardGapY) + _kCatGap;
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
          left: center.dx - _kCardW / 2,
          top: center.dy - _kCardH / 2,
          child: _DogCard(
            dog: dog,
            summary: dogSummaries[dogId],
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
    required this.selectedId,
  });

  final _LayoutPositions positions;
  final Map<String, List<String>> initToDogs;
  final String? selectedId;

  @override
  void paint(Canvas canvas, Size size) {
    int ci = 0;
    for (final entry in initToDogs.entries) {
      final initCenter = positions.initCenters[entry.key];
      if (initCenter == null) { ci++; continue; }

      final color =
          _kTraceColors[ci % _kTraceColors.length];
      ci++;

      final isHighlighted = selectedId == entry.key ||
          entry.value.contains(selectedId);

      final paint = Paint()
        ..color =
            color.withAlpha(isHighlighted ? 200 : 45)
        ..strokeWidth = isHighlighted ? 1.5 : 1.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final fromY = initCenter.dy + _kCardH / 2;

      for (final dogId in entry.value) {
        final dogCenter = positions.dogCenters[dogId];
        if (dogCenter == null) continue;

        final toY = dogCenter.dy - _kCardH / 2;

        // Orthogonal trace: down from init, horizontal bus, down to dog.
        final busY = fromY + (toY - fromY) * 0.35;
        canvas.drawPath(
          Path()
            ..moveTo(initCenter.dx, fromY + 2)
            ..lineTo(initCenter.dx, busY)
            ..lineTo(dogCenter.dx, busY)
            ..lineTo(dogCenter.dx, toY - 2),
          paint,
        );

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
    }
  }

  @override
  bool shouldRepaint(_TracePainter old) =>
      old.initToDogs != initToDogs || old.selectedId != selectedId;
}

// ── Cards ──────────────────────────────────────────────────────────────────

class _InitCard extends StatelessWidget {
  const _InitCard({
    required this.init,
    required this.summary,
    required this.isSelected,
    required this.isContributing,
    required this.onTap,
  });

  final InitiativeSchema init;
  final ConnectionSummarySchema? summary;
  final bool isSelected;
  final bool isContributing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final total = summary?.totalCount ?? 0;
    final progress = (init.goal ?? 0) > 0
        ? ((init.complete ?? 0) / (init.goal ?? 1)).clamp(0.0, 1.0)
        : null;

    return _CircuitCard(
      accentColor: _kInitColor,
      isSelected: isSelected,
      isConnected: isContributing,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            const Icon(Icons.trending_up,
                size: 10, color: _kInitColor),
            const SizedBox(width: 4),
            Expanded(
              child: Text(init.title,
                  style: const TextStyle(
                      color: _kTextPri,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      height: 1.2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
            if (total > 0) ...[
              const SizedBox(width: 4),
              _Badge('$total', _kInitColor),
            ],
          ]),
          if (progress != null) ...[
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 3,
                backgroundColor: _kInitColor.withAlpha(20),
                valueColor:
                    const AlwaysStoppedAnimation(_kInitColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DogCard extends StatelessWidget {
  const _DogCard({
    required this.dog,
    required this.summary,
    required this.isSelected,
    required this.isFollowing,
    required this.onTap,
  });

  final DirectoryOfGoodSchema dog;
  final ConnectionSummarySchema? summary;
  final bool isSelected;
  final bool isFollowing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = dog.imageUrl?.trim();
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    final total = summary?.totalCount ?? 0;

    return _CircuitCard(
      accentColor: _kMapColor,
      isSelected: isSelected,
      isConnected: isFollowing,
      onTap: onTap,
      child: Row(children: [
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
                    fit: BoxFit.cover)
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
                  style: const TextStyle(
                      color: _kTextPri,
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
                  style: const TextStyle(
                      color: _kTextMut,
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
    );
  }
}

class _CircuitCard extends StatelessWidget {
  const _CircuitCard({
    required this.accentColor,
    required this.isSelected,
    required this.isConnected,
    required this.onTap,
    required this.child,
  });

  final Color accentColor;
  final bool isSelected;
  final bool isConnected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            width: _kCardW,
            height: _kCardH,
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? accentColor.withAlpha(22)
                  : _kSurface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected
                    ? accentColor
                    : isConnected
                        ? accentColor.withAlpha(90)
                        : _kBorder,
                width: isSelected ? 1.5 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                          color: accentColor.withAlpha(50),
                          blurRadius: 10,
                          spreadRadius: 1),
                    ]
                  : [],
            ),
            child: child,
          ),
        ),
      );
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
        color: _kSurface,
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        child: Row(children: [
          _L(_kInitColor, '$initCount initiatives'),
          const SizedBox(width: 14),
          _L(_kMapColor, '$dogCount organizations'),
          if (connectionCount > 0) ...[
            const SizedBox(width: 14),
            _L(_kInitColor,
                '$connectionCount org connection${connectionCount == 1 ? '' : 's'}',
                dashed: true),
          ],
          const Spacer(),
          const Text('Tap a card to view details',
              style: TextStyle(
                  color: _kTextMut, fontSize: 10)),
        ]),
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
              style: const TextStyle(
                  color: _kTextMut, fontSize: 10)),
        ],
      );
}
