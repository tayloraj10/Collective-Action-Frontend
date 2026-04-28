import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/components/category_chip.dart';
import 'package:collective_action_frontend/utils/external_network_image.dart';
import 'package:flutter/material.dart';

const _kMapColor  = Color(0xFF16A34A);
const _kInitColor = Color(0xFF3B82F6);

enum GridSort { followers, name, contributions }

class NetworkGridView extends StatefulWidget {
  const NetworkGridView({
    super.key,
    required this.dogs,
    required this.initiatives,
    required this.dogSummaries,
    required this.initSummaries,
    required this.myConns,
    required this.selectedId,
    required this.onSelect,
  });

  final List<DirectoryOfGoodSchema> dogs;
  final List<InitiativeSchema> initiatives;
  final Map<String, ConnectionSummarySchema> dogSummaries;
  final Map<String, ConnectionSummarySchema> initSummaries;
  final List<ConnectionWithUserSchema> myConns;
  final String? selectedId;
  final void Function(String id, String type) onSelect;

  @override
  State<NetworkGridView> createState() => _NetworkGridViewState();
}

class _NetworkGridViewState extends State<NetworkGridView> {
  GridSort _sort = GridSort.followers;
  bool _showInits = true;
  bool _showDogs = true;

  List<_GridItem> get _items {
    final items = <_GridItem>[];

    if (_showDogs) {
      for (final d in widget.dogs) {
        final id = d.id ?? d.name;
        final summary = widget.dogSummaries[id];
        items.add(_GridItem(
          id: id,
          type: 'directory_of_good',
          name: d.name,
          subtitle: d.focus,
          imageUrl: d.imageUrl?.trim(),
          categoryIds: d.categoryIds,
          location: [d.location?.city, d.location?.state, d.location?.country]
              .whereType<String>()
              .where((s) => s.isNotEmpty)
              .join(', '),
          followerCount: summary?.userCount ?? 0,
          connectionCount: summary?.totalCount ?? 0,
          orgCount: summary?.orgCount ?? 0,
          accentColor: _kMapColor,
        ));
      }
    }

    if (_showInits) {
      for (final i in widget.initiatives) {
        final summary = widget.initSummaries[i.id];
        items.add(_GridItem(
          id: i.id,
          type: 'initiative',
          name: i.title,
          subtitle: i.action,
          imageUrl: null,
          categoryIds: i.categoryId != null ? [i.categoryId!] : [],
          location: '',
          followerCount: summary?.userCount ?? 0,
          connectionCount: summary?.totalCount ?? 0,
          orgCount: summary?.orgCount ?? 0,
          accentColor: _kInitColor,
        ));
      }
    }

    switch (_sort) {
      case GridSort.followers:
        items.sort((a, b) => b.followerCount.compareTo(a.followerCount));
      case GridSort.name:
        items.sort((a, b) => a.name.compareTo(b.name));
      case GridSort.contributions:
        items.sort(
            (a, b) => b.connectionCount.compareTo(a.connectionCount));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _items;

    return Column(
      children: [
        // Toolbar
        Container(
          color: theme.colorScheme.surface,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Type toggles
              _TypeToggle(
                label: 'Organizations',
                active: _showDogs,
                color: _kMapColor,
                onTap: () =>
                    setState(() => _showDogs = !_showDogs),
              ),
              const SizedBox(width: 8),
              _TypeToggle(
                label: 'Initiatives',
                active: _showInits,
                color: _kInitColor,
                onTap: () =>
                    setState(() => _showInits = !_showInits),
              ),
              const Spacer(),
              // Sort
              Text('Sort: ',
                  style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withAlpha(120))),
              DropdownButton<GridSort>(
                value: _sort,
                isDense: true,
                underline: const SizedBox.shrink(),
                style: theme.textTheme.labelSmall,
                items: const [
                  DropdownMenuItem(
                      value: GridSort.followers,
                      child: Text('Most followed')),
                  DropdownMenuItem(
                      value: GridSort.contributions,
                      child: Text('Most connected')),
                  DropdownMenuItem(
                      value: GridSort.name,
                      child: Text('Name A–Z')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _sort = v);
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Count
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('${items.length} entries',
                style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(100))),
          ),
        ),
        // List
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) =>
                Divider(height: 1, color: theme.dividerColor.withAlpha(60)),
            itemBuilder: (context, i) {
              final item = items[i];
              final isSelected = widget.selectedId == item.id;
              final isConnected = widget.myConns.any((c) =>
                  c.toId == item.id &&
                  c.toType == item.type &&
                  c.fromType == 'user');
              return _GridRow(
                item: item,
                isSelected: isSelected,
                isConnected: isConnected,
                onTap: () => widget.onSelect(item.id, item.type),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Grid row ───────────────────────────────────────────────────────────────

class _GridRow extends StatelessWidget {
  const _GridRow({
    required this.item,
    required this.isSelected,
    required this.isConnected,
    required this.onTap,
  });

  final _GridItem item;
  final bool isSelected;
  final bool isConnected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: isSelected
            ? item.accentColor.withAlpha(isDark ? 20 : 12)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Avatar
            _ItemAvatar(
              imageUrl: item.imageUrl,
              name: item.name,
              color: item.accentColor,
              size: 36,
            ),
            const SizedBox(width: 12),

            // Name + subtitle
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.subtitle != null &&
                      item.subtitle!.isNotEmpty)
                    Text(
                      item.subtitle!,
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withAlpha(110)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Categories (desktop only, hidden on mobile)
            if (MediaQuery.sizeOf(context).width > 700 &&
                item.categoryIds.isNotEmpty) ...[
              SizedBox(
                width: 120,
                child: Wrap(
                  spacing: 4,
                  children: item.categoryIds
                      .take(2)
                      .map((id) => CategoryChip(
                          categoryId: id, compact: true))
                      .toList(),
                ),
              ),
              const SizedBox(width: 8),
            ],

            // Location (desktop only)
            if (MediaQuery.sizeOf(context).width > 900 &&
                item.location.isNotEmpty) ...[
              SizedBox(
                width: 140,
                child: Text(
                  item.location,
                  style: theme.textTheme.labelSmall?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withAlpha(100)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
            ],

            // Stats
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.followerCount > 0) ...[
                  Icon(Icons.people_outline,
                      size: 12,
                      color: item.accentColor.withAlpha(160)),
                  const SizedBox(width: 3),
                  Text('${item.followerCount}',
                      style: TextStyle(
                          color: item.accentColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 10),
                ],
                if (item.orgCount > 0 &&
                    item.type == 'initiative') ...[
                  Icon(Icons.business_outlined,
                      size: 12,
                      color: _kMapColor.withAlpha(160)),
                  const SizedBox(width: 3),
                  Text('${item.orgCount}',
                      style: const TextStyle(
                          color: _kMapColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 10),
                ],
              ],
            ),

            // Connected indicator
            if (isConnected)
              Icon(Icons.check_circle,
                  size: 14, color: item.accentColor)
            else
              Icon(Icons.circle_outlined,
                  size: 14,
                  color: theme.colorScheme.onSurface.withAlpha(40)),
          ],
        ),
      ),
    );
  }
}

// ── Shared avatar widget ───────────────────────────────────────────────────

class _ItemAvatar extends StatelessWidget {
  const _ItemAvatar({
    required this.imageUrl,
    required this.name,
    required this.color,
    required this.size,
  });

  final String? imageUrl;
  final String name;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withAlpha(20),
      ),
      child: ClipOval(
        child: hasImage
            ? ExternalOrDataImage(
                url: imageUrl!, width: size, height: size,
                fit: BoxFit.cover)
            : Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                      color: color,
                      fontSize: size * 0.38,
                      fontWeight: FontWeight.w700),
                ),
              ),
      ),
    );
  }
}

// ── Type toggle chip ───────────────────────────────────────────────────────

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: active ? color.withAlpha(20) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                color: active ? color : color.withAlpha(40)),
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: active ? color : color.withAlpha(120),
                  fontWeight: active
                      ? FontWeight.w600
                      : FontWeight.normal)),
        ),
      );
}

// ── Data model ─────────────────────────────────────────────────────────────

class _GridItem {
  const _GridItem({
    required this.id,
    required this.type,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.categoryIds,
    required this.location,
    required this.followerCount,
    required this.connectionCount,
    required this.orgCount,
    required this.accentColor,
  });

  final String id;
  final String type;
  final String name;
  final String? subtitle;
  final String? imageUrl;
  final List<String> categoryIds;
  final String location;
  final int followerCount;
  final int connectionCount;
  final int orgCount;
  final Color accentColor;
}
