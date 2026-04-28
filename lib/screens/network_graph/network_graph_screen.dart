import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/providers/config_provider.dart';
import 'package:collective_action_frontend/providers/connection_provider.dart';
import 'package:collective_action_frontend/providers/directory_of_good_provider.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:collective_action_frontend/screens/network_graph/widgets/entity_detail_panel.dart';
import 'package:collective_action_frontend/screens/network_graph/widgets/circuit_view.dart';
import 'package:collective_action_frontend/screens/network_graph/widgets/map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphify/graphify.dart';

// ── View modes ─────────────────────────────────────────────────────────────

enum NetworkView { grid, graph, map }

// ── Palette ─────────────────────────────────────────────────────────────────

const _kBg        = Color(0xFF0D1117);
const _kSurface   = Color(0xFF161B22);
const _kBorder    = Color(0xFF30363D);
const _kTextPri   = Color(0xFFE6EDF3);
const _kTextMuted = Color(0xFF8B949E);

const _kMapColor  = Color(0xFF16A34A);
const _kInitColor = Color(0xFF3B82F6);
const _kHubColor  = Color(0xFF6366F1);

const _kCategoryColors = [
  Color(0xFF6366F1), Color(0xFF0EA5E9), Color(0xFF10B981),
  Color(0xFFF59E0B), Color(0xFFEC4899), Color(0xFF8B5CF6),
  Color(0xFF14B8A6), Color(0xFFF97316), Color(0xFF84CC16),
  Color(0xFFEF4444), Color(0xFF06B6D4), Color(0xFFA855F7),
];

// ── Screen ─────────────────────────────────────────────────────────────────

class NetworkGraphScreen extends ConsumerStatefulWidget {
  const NetworkGraphScreen({
    super.key,
    this.initialView = NetworkView.graph,
  });

  final NetworkView initialView;

  @override
  ConsumerState<NetworkGraphScreen> createState() =>
      _NetworkGraphScreenState();
}

class _NetworkGraphScreenState
    extends ConsumerState<NetworkGraphScreen> {
  late NetworkView _view = widget.initialView;
  String _searchQuery = '';
  String? _selectedCategoryId;
  String? _selectedEntityId;
  String? _selectedEntityType;
  final _searchCtrl = TextEditingController();

  @override
  void didUpdateWidget(NetworkGraphScreen old) {
    super.didUpdateWidget(old);
    if (old.initialView != widget.initialView) {
      setState(() => _view = widget.initialView);
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _selectEntity(String id, String type) {
    setState(() {
      if (_selectedEntityId == id) {
        _selectedEntityId = null;
        _selectedEntityType = null;
      } else {
        _selectedEntityId = id;
        _selectedEntityType = type;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppConstants.isMobile(context);

    final dogs      = ref.watch(directoryOfGoodEntriesProvider).value ?? [];
    final inits     = ref.watch(activeInitiativeProvider).value ?? [];
    final categories = ref.watch(categoriesProvider).value ?? [];
    final dogSummaries =
        ref.watch(connectionSummaryProvider('directory_of_good')).value ?? {};
    final initSummaries =
        ref.watch(connectionSummaryProvider('initiative')).value ?? {};
    final myConns = ref.watch(myConnectionsProvider).value ?? [];

    // Apply search + category filter.
    final filteredDogs = dogs.where((d) {
      if (_selectedCategoryId != null &&
          !d.categoryIds.contains(_selectedCategoryId)) { return false; }
      if (_searchQuery.isEmpty) { return true; }
      final q = _searchQuery.toLowerCase();
      return d.name.toLowerCase().contains(q) ||
          (d.focus?.toLowerCase().contains(q) ?? false);
    }).toList();

    final filteredInits = inits.where((i) {
      if (_selectedCategoryId != null &&
          i.categoryId != _selectedCategoryId) { return false; }
      if (_searchQuery.isEmpty) { return true; }
      final q = _searchQuery.toLowerCase();
      return i.title.toLowerCase().contains(q) ||
          i.action.toLowerCase().contains(q);
    }).toList();

    final showPanel = _selectedEntityId != null &&
        _selectedEntityType != null &&
        !isMobile;

    Widget mainContent = switch (_view) {
      NetworkView.grid => CircuitDirectoryView(
          dogs: filteredDogs,
          initiatives: filteredInits,
          categories: categories,
          dogSummaries: dogSummaries,
          initSummaries: initSummaries,
          myConns: myConns,
          selectedId: _selectedEntityId,
          onSelect: _selectEntity,
        ),
      NetworkView.graph => _GraphView(
          dogs: filteredDogs,
          inits: filteredInits,
          categories: categories,
          dogSummaries: dogSummaries,
          initSummaries: initSummaries,
          myConns: myConns,
        ),
      NetworkView.map => NetworkMapView(
          dogs: filteredDogs,
          categories: categories,
          dogSummaries: dogSummaries,
          selectedId: _selectedEntityId,
          onSelect: _selectEntity,
        ),
    };

    return Scaffold(
      backgroundColor: _kBg,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              searchCtrl: _searchCtrl,
              searchQuery: _searchQuery,
              categories: categories,
              selectedCategoryId: _selectedCategoryId,
              currentView: _view,
              totalDogs: filteredDogs.length,
              totalInits: filteredInits.length,
              onSearchChanged: (v) =>
                  setState(() => _searchQuery = v),
              onCategorySelected: (id) =>
                  setState(() => _selectedCategoryId = id),
              onViewChanged: (v) {
                // Update locally first so the toggle always responds immediately,
                // even if route transitions are delayed.
                if (_view != v) {
                  setState(() => _view = v);
                }
                final path = switch (v) {
                  NetworkView.graph => '/network/graph',
                  NetworkView.grid  => '/network/directory',
                  NetworkView.map   => '/network/map',
                };
                context.go(path);
              },
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: mainContent),
                  // Detail panel (desktop slide-in)
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: showPanel
                        ? SizedBox(
                            width: 300,
                            child: EntityDetailPanel(
                              entityId: _selectedEntityId!,
                              entityType: _selectedEntityType!,
                              dogSummaries: dogSummaries,
                              initSummaries: initSummaries,
                              allDogs: dogs,
                              allInits: inits,
                              onClose: () => setState(() {
                                _selectedEntityId = null;
                                _selectedEntityType = null;
                              }),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Top bar ────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.searchCtrl,
    required this.searchQuery,
    required this.categories,
    required this.selectedCategoryId,
    required this.currentView,
    required this.totalDogs,
    required this.totalInits,
    required this.onSearchChanged,
    required this.onCategorySelected,
    required this.onViewChanged,
  });

  final TextEditingController searchCtrl;
  final String searchQuery;
  final List<CategorySchema> categories;
  final String? selectedCategoryId;
  final NetworkView currentView;
  final int totalDogs;
  final int totalInits;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onCategorySelected;
  final ValueChanged<NetworkView> onViewChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kSurface,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Search
              Expanded(
                child: TextField(
                  controller: searchCtrl,
                  style: const TextStyle(
                      color: _kTextPri, fontSize: 13),
                  decoration: InputDecoration(
                    hintText:
                        'Search organizations & initiatives…',
                    hintStyle: const TextStyle(
                        color: _kTextMuted, fontSize: 13),
                    prefixIcon: const Icon(Icons.search,
                        color: _kTextMuted, size: 18),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear,
                                color: _kTextMuted, size: 16),
                            onPressed: () => onSearchChanged(''),
                          )
                        : null,
                    filled: true,
                    fillColor: _kBg,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: _kBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: _kBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: _kHubColor, width: 1.5),
                    ),
                  ),
                  onChanged: onSearchChanged,
                ),
              ),
              const SizedBox(width: 12),
              // View toggle
              _ViewToggle(
                current: currentView,
                onChanged: onViewChanged,
              ),
            ],
          ),
          if (categories.isNotEmpty) ...[
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _CatChip(
                      label: 'All',
                      color: _kTextMuted,
                      selected: selectedCategoryId == null,
                      onTap: () => onCategorySelected(null)),
                  ...categories.asMap().entries.map((e) {
                    final color = _kCategoryColors[
                        e.key % _kCategoryColors.length];
                    return _CatChip(
                      label: e.value.name,
                      color: color,
                      selected: selectedCategoryId == e.value.id,
                      onTap: () => onCategorySelected(
                          selectedCategoryId == e.value.id
                              ? null
                              : e.value.id),
                    );
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle(
      {required this.current, required this.onChanged});
  final NetworkView current;
  final ValueChanged<NetworkView> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewBtn(Icons.view_list_outlined, 'Directory',
              NetworkView.grid, current, onChanged),
          _ViewBtn(Icons.hub_outlined, 'Graph', NetworkView.graph,
              current, onChanged),
          _ViewBtn(Icons.map_outlined, 'Map', NetworkView.map,
              current, onChanged),
        ],
      ),
    );
  }
}

class _ViewBtn extends StatelessWidget {
  const _ViewBtn(
      this.icon, this.tooltip, this.view, this.current, this.onChanged);
  final IconData icon;
  final String tooltip;
  final NetworkView view;
  final NetworkView current;
  final ValueChanged<NetworkView> onChanged;

  @override
  Widget build(BuildContext context) {
    final active = current == view;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () => onChanged(view),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: active
                ? _kHubColor.withAlpha(40)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon,
              size: 17,
              color: active ? _kHubColor : _kTextMuted),
        ),
      ),
    );
  }
}

class _CatChip extends StatelessWidget {
  const _CatChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: selected
                ? color.withAlpha(30)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? color : _kBorder,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: selected ? color : _kTextMuted,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.normal)),
        ),
      );
}

// ── Graph view (ECharts with connections + sized nodes) ────────────────────

class _GraphView extends StatefulWidget {
  const _GraphView({
    required this.dogs,
    required this.inits,
    required this.categories,
    required this.dogSummaries,
    required this.initSummaries,
    required this.myConns,
  });

  final List<DirectoryOfGoodSchema> dogs;
  final List<InitiativeSchema> inits;
  final List<CategorySchema> categories;
  final Map<String, ConnectionSummarySchema> dogSummaries;
  final Map<String, ConnectionSummarySchema> initSummaries;
  final List<ConnectionWithUserSchema> myConns;

  @override
  State<_GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<_GraphView> {
  late final GraphifyController _controller;
  bool _chartReady = false;

  @override
  void initState() {
    super.initState();
    _controller = GraphifyController();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _chartReady = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_GraphView old) {
    super.didUpdateWidget(old);
    if (_chartReady) {
      _controller.update(_buildOptions());
    }
  }

  static String _hex(Color c) =>
      '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';

  static String _normalizeImageUrl(String? raw) {
    if (raw == null || raw.isEmpty || raw.startsWith('data:')) {
      return '';
    }
    var u = raw.trim().replaceAll('&amp;', '&');
    if (!u.startsWith('http://') && !u.startsWith('https://')) {
      u = u.startsWith('//') ? 'https:$u' : 'https://$u';
    }
    if (u.startsWith('http://')) u = u.replaceFirst('http://', 'https://');
    return u;
  }

  Map<String, dynamic> _buildOptions() {
    final catColorMap = <String?, String>{};
    for (int i = 0; i < widget.categories.length; i++) {
      catColorMap[widget.categories[i].id] =
          _hex(_kCategoryColors[i % _kCategoryColors.length]);
    }

    final nodes = <Map<String, dynamic>>[];
    final links = <Map<String, dynamic>>[];

    // ── Category hub nodes ──────────────────────────────────────────
    for (int i = 0; i < widget.categories.length; i++) {
      final cat = widget.categories[i];
      if (cat.id == null) continue;
      final color = catColorMap[cat.id]!;
      nodes.add({
        'id': 'cat_${cat.id}',
        'name': cat.name,
        'symbolSize': 36,
        'itemStyle': {
          'color': color,
          'borderWidth': 0,
          'shadowColor': color,
          'shadowBlur': 16,
        },
        'label': {
          'show': true,
          'color': color,
          'fontSize': 11,
          'fontWeight': 'bold',
          'position': 'bottom',
          'distance': 6,
          'formatter': '{b}',
        },
      });
    }

    // ── DoG nodes ───────────────────────────────────────────────────
    for (final dog in widget.dogs) {
      final id = dog.id ?? dog.name;
      final color =
          catColorMap[dog.categoryIds.firstOrNull] ?? _hex(_kMapColor);
      final summary = widget.dogSummaries[id];
      final totalConns = summary?.totalCount ?? 0;
      final isSelf = widget.myConns.any((c) =>
          c.toType == 'directory_of_good' &&
          c.toId == id &&
          c.fromType == 'user');

      // Nodes grow as more users follow them.
      final size = (22.0 + totalConns * 3.0).clamp(22.0, 64.0);

      final rawUrl = dog.imageUrl?.trim();
      final imageUrl = _normalizeImageUrl(rawUrl);
      final backendBase = AppConstants.backendBaseUrl;
      final proxiedUrl = imageUrl.isNotEmpty
          ? '$backendBase/image-proxy/?url=${Uri.encodeComponent(imageUrl)}'
          : '';

      nodes.add({
        'id': 'dog_$id',
        'name': dog.name,
        'symbol': 'circle',
        'symbolSize': size,
        'itemStyle': {
          'color': color,
          'opacity': 0.9,
          'borderColor': isSelf ? '#FFFFFF' : color,
          'borderWidth': isSelf ? 3.0 : 0.0,
          'shadowColor': isSelf ? color : 'rgba(0,0,0,0)',
          'shadowBlur': isSelf ? 18 : 0,
        },
        if (proxiedUrl.isNotEmpty) 'label': {
          'show': true,
          'position': 'inside',
          'formatter': '{img|}',
          'rich': {
            'img': {
              'backgroundColor': {'image': proxiedUrl},
              'width': (size - 6).round(),
              'height': (size - 6).round(),
              'borderRadius': ((size - 6) / 2).round(),
            },
          },
        } else 'label': {'show': false},
        'emphasis': {
          'label': {
            'show': true,
            'formatter': '{b}',
            'color': '#E6EDF3',
            'fontSize': 11,
            'position': 'bottom',
            'distance': 4,
          },
        },
        'tooltip': {'formatter': '${dog.name}${totalConns > 0 ? " · $totalConns connections" : ""}'},
      });

      // DoG → category edge
      for (final catId in dog.categoryIds) {
        if (catColorMap.containsKey(catId)) {
          links.add({
            'source': 'dog_$id',
            'target': 'cat_$catId',
            'tooltip': {'show': false},
            'lineStyle': {
              'color': color,
              'opacity': 0.25,
              'width': 1,
            },
          });
        }
      }
    }

    // ── Initiative nodes ─────────────────────────────────────────────
    for (final init in widget.inits) {
      final summary = widget.initSummaries[init.id];
      final totalConns = summary?.totalCount ?? 0;
      final isSelf = widget.myConns.any((c) =>
          c.toType == 'initiative' &&
          c.toId == init.id &&
          c.fromType == 'user');

      final size = (26.0 + totalConns * 3.0).clamp(26.0, 64.0);
      final color = _hex(_kInitColor);

      nodes.add({
        'id': 'init_${init.id}',
        'name': init.title,
        'symbol': 'roundRect',
        'symbolSize': [size * 1.4, size * 0.7], // wider rectangle
        'itemStyle': {
          'color': color,
          'opacity': 0.85,
          'borderColor': isSelf ? '#FFFFFF' : color,
          'borderWidth': isSelf ? 3.0 : 0.0,
          'shadowColor': isSelf ? color : 'rgba(0,0,0,0)',
          'shadowBlur': isSelf ? 18 : 0,
        },
        'label': {'show': false},
        'emphasis': {
          'label': {
            'show': true,
            'formatter': '{b}',
            'color': '#E6EDF3',
            'fontSize': 11,
            'position': 'bottom',
            'distance': 4,
          },
        },
        'tooltip': {
          'formatter':
              '${init.title}${totalConns > 0 ? " · $totalConns connections" : ""}',
        },
      });

      // DoG → Initiative edges (from orgIds in summaries)
      final orgIds = summary?.orgIds ?? [];
      for (final orgId in orgIds) {
        links.add({
          'source': 'dog_$orgId',
          'target': 'init_${init.id}',
          'tooltip': {'show': false},
          'lineStyle': {
            'color': _hex(_kInitColor),
            'opacity': 0.5,
            'width': 1.5,
            'type': 'dashed',
          },
        });
      }

      // Initiative → category edge (if categoryId set)
      if (init.categoryId != null &&
          catColorMap.containsKey(init.categoryId)) {
        links.add({
          'source': 'init_${init.id}',
          'target': 'cat_${init.categoryId}',
          'tooltip': {'show': false},
          'lineStyle': {
            'color': _hex(_kInitColor),
            'opacity': 0.2,
            'width': 1,
          },
        });
      }
    }

    return {
      'backgroundColor': '#0D1117',
      'tooltip': {
        'trigger': 'item',
        'backgroundColor': '#161B22',
        'borderColor': '#30363D',
        'borderWidth': 1,
        'padding': [8, 12],
        'textStyle': {'color': '#E6EDF3', 'fontSize': 12},
        'enterable': false,
      },
      'legend': [
        {
          'data': [
            {'name': 'Organization', 'icon': 'circle'},
            {'name': 'Initiative', 'icon': 'roundRect'},
          ],
          'textStyle': {'color': '#8B949E', 'fontSize': 11},
          'top': 10, 'right': 10,
          'backgroundColor': '#161B22',
          'borderColor': '#30363D',
          'borderWidth': 1,
          'padding': [8, 12],
          'borderRadius': 6,
        }
      ],
      'series': [
        {
          'type': 'graph',
          'layout': 'force',
          'animation': true,
          'animationDuration': 1000,
          'roam': true,
          'draggable': true,
          'data': nodes,
          'links': links,
          'lineStyle': {
            'color': '#30363D',
            'width': 1.0,
            'opacity': 0.45,
          },
          'emphasis': {
            'focus': 'adjacency',
            'lineStyle': {'width': 2.0, 'opacity': 0.9},
          },
          'force': {
            'initLayout': 'circular',
            'repulsion': 420,
            'gravity': 0.07,
            'edgeLength': [100, 200],
            'friction': 0.6,
            'layoutAnimation': true,
          },
        },
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return GraphifyView(
      controller: _controller,
      initialOptions: _buildOptions(),
    );
  }
}
