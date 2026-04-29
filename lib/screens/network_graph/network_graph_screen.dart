import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/components/category_chip.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/providers/config_provider.dart';
import 'package:collective_action_frontend/providers/connection_provider.dart';
import 'package:collective_action_frontend/providers/directory_of_good_provider.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:collective_action_frontend/screens/network_graph/widgets/entity_detail_panel.dart';
import 'package:collective_action_frontend/screens/network_graph/widgets/circuit_view.dart';
import 'package:collective_action_frontend/screens/network_graph/widgets/map_view.dart';
import 'package:collective_action_frontend/screens/user/profile_page.dart';
import 'package:collective_action_frontend/theme/category_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphify/graphify.dart';
import 'dart:math' as math;

// ── View modes ─────────────────────────────────────────────────────────────

enum NetworkView { grid, graph, map }

// ── Palette ─────────────────────────────────────────────────────────────────

const _kMapColor = Color(0xFF16A34A);
const _kInitColor = Color(0xFF3B82F6);
const _kHubColor = Color(0xFF6366F1);
const _kUserColor = Color(0xFF8B5CF6);

class _NetworkColors {
  const _NetworkColors({
    required this.bg,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textMuted,
  });

  final Color bg;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textMuted;

  factory _NetworkColors.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _NetworkColors(
      bg: isDark ? const Color(0xFF0D1117) : const Color(0xFFEFF3F8),
      surface: isDark ? const Color(0xFF161B22) : const Color(0xFFF7FAFD),
      border: isDark ? const Color(0xFF30363D) : const Color(0xFFC5D0DF),
      textPrimary: isDark ? const Color(0xFFE6EDF3) : const Color(0xFF0F172A),
      textMuted: isDark ? const Color(0xFF8B949E) : const Color(0xFF5B6B80),
    );
  }
}

// ── Screen ─────────────────────────────────────────────────────────────────

class NetworkGraphScreen extends ConsumerStatefulWidget {
  const NetworkGraphScreen({super.key, this.initialView = NetworkView.graph});

  final NetworkView initialView;

  @override
  ConsumerState<NetworkGraphScreen> createState() => _NetworkGraphScreenState();
}

class _NetworkGraphScreenState extends ConsumerState<NetworkGraphScreen> {
  late NetworkView _view = widget.initialView;
  String _searchQuery = '';
  String? _selectedCategoryId;
  String? _selectedInitiativeId;
  String? _selectedEntityId;
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
      _selectedEntityId = id;
    });
  }

  Future<void> _openEntityDetails({
    required BuildContext context,
    required String entityId,
    required String entityType,
    required Map<String, ConnectionSummarySchema> dogSummaries,
    required Map<String, ConnectionSummarySchema> initSummaries,
    required List<DirectoryOfGoodSchema> dogs,
    required List<InitiativeSchema> inits,
  }) async {
    const dialogRadius = BorderRadius.all(Radius.circular(18));
    final panel = EntityDetailPanel(
      entityId: entityId,
      entityType: entityType,
      dogSummaries: dogSummaries,
      initSummaries: initSummaries,
      allDogs: dogs,
      allInits: inits,
      onClose: () => Navigator.of(context).pop(),
      borderRadius: dialogRadius,
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440, maxHeight: 760),
          child: panel,
        ),
      ),
    );

    if (!mounted) return;
    setState(() {
      _selectedEntityId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = _NetworkColors.of(context);

    final dogs = ref.watch(directoryOfGoodEntriesProvider).value ?? [];
    final inits = ref.watch(activeInitiativeProvider).value ?? [];
    final categories = ref.watch(categoriesProvider).value ?? [];
    final dogSummaries =
        ref.watch(connectionSummaryProvider('directory_of_good')).value ?? {};
    final initSummaries =
        ref.watch(connectionSummaryProvider('initiative')).value ?? {};
    final myConns = ref.watch(myConnectionsProvider).value ?? [];

    final selectedInitiativeOrgIds = _selectedInitiativeId == null
        ? null
        : (initSummaries[_selectedInitiativeId!]?.orgIds.toSet() ?? <String>{});

    // Apply search + category filter.
    final filteredDogs = dogs.where((d) {
      if (_selectedCategoryId != null &&
          !d.categoryIds.contains(_selectedCategoryId)) {
        return false;
      }
      if (selectedInitiativeOrgIds != null &&
          !selectedInitiativeOrgIds.contains(d.id ?? d.name)) {
        return false;
      }
      if (_searchQuery.isEmpty) {
        return true;
      }
      final q = _searchQuery.toLowerCase();
      return d.name.toLowerCase().contains(q) ||
          (d.focus?.toLowerCase().contains(q) ?? false);
    }).toList();

    final filteredInits = inits.where((i) {
      if (_selectedCategoryId != null && i.categoryId != _selectedCategoryId) {
        return false;
      }
      if (_selectedInitiativeId != null && i.id != _selectedInitiativeId) {
        return false;
      }
      if (_searchQuery.isEmpty) {
        return true;
      }
      final q = _searchQuery.toLowerCase();
      return i.title.toLowerCase().contains(q) ||
          i.action.toLowerCase().contains(q);
    }).toList();

    Widget mainContent = switch (_view) {
      NetworkView.grid => CircuitDirectoryView(
        dogs: filteredDogs,
        initiatives: filteredInits,
        categories: categories,
        dogSummaries: dogSummaries,
        initSummaries: initSummaries,
        myConns: myConns,
        selectedId: _selectedEntityId,
        selectedInitiativeId: _selectedInitiativeId,
        onInitiativeFilterToggle: (initiativeId) {
          setState(() {
            _selectedInitiativeId = _selectedInitiativeId == initiativeId
                ? null
                : initiativeId;
          });
        },
        onSelect: (id, type) {
          _selectEntity(id, type);
          _openEntityDetails(
            context: context,
            entityId: id,
            entityType: type,
            dogSummaries: dogSummaries,
            initSummaries: initSummaries,
            dogs: dogs,
            inits: inits,
          );
        },
      ),
      NetworkView.graph => _GraphView(
        dogs: filteredDogs,
        inits: filteredInits,
        categories: categories,
        dogSummaries: dogSummaries,
        initSummaries: initSummaries,
        myConns: myConns,
        colors: colors,
      ),
      NetworkView.map => NetworkMapView(
        dogs: filteredDogs,
        categories: categories,
        dogSummaries: dogSummaries,
        selectedId: _selectedEntityId,
        onSelect: (id, type) {
          _selectEntity(id, type);
          _openEntityDetails(
            context: context,
            entityId: id,
            entityType: type,
            dogSummaries: dogSummaries,
            initSummaries: initSummaries,
            dogs: dogs,
            inits: inits,
          );
        },
      ),
    };

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: _TopBar(
                searchCtrl: _searchCtrl,
                searchQuery: _searchQuery,
                categories: categories,
                selectedCategoryId: _selectedCategoryId,
                currentView: _view,
                totalDogs: filteredDogs.length,
                totalInits: filteredInits.length,
                colors: colors,
                onSearchChanged: (v) => setState(() => _searchQuery = v),
                onCategorySelected: (id) =>
                    setState(() => _selectedCategoryId = id),
                onViewChanged: (v) {
                  if (_view != v) {
                    setState(() => _view = v);
                  }
                  final path = switch (v) {
                    NetworkView.graph => '/network/graph',
                    NetworkView.grid => '/network/circuit',
                    NetworkView.map => '/network/map',
                  };
                  if (GoRouterState.of(context).uri.path != path) {
                    context.go(path);
                  }
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.border.withAlpha(130)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(22),
                        blurRadius: 16,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: mainContent,
                  ),
                ),
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
    required this.colors,
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
  final _NetworkColors colors;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onCategorySelected;
  final ValueChanged<NetworkView> onViewChanged;

  @override
  Widget build(BuildContext context) {
    final colors = _NetworkColors.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.surface, colors.surface.withAlpha(215)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border.withAlpha(120)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.hub_outlined, size: 15, color: _kHubColor),
              const SizedBox(width: 6),
              Text(
                'Network Explorer',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              const Spacer(),
              Text(
                '$totalInits initiatives · $totalDogs orgs',
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Search
              Expanded(
                child: TextField(
                  controller: searchCtrl,
                  style: TextStyle(color: colors.textPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: colors.textMuted, fontSize: 13),
                    prefixIcon: Icon(
                      Icons.search,
                      color: colors.textMuted,
                      size: 18,
                    ),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: colors.textMuted,
                              size: 16,
                            ),
                            onPressed: () => onSearchChanged(''),
                          )
                        : null,
                    filled: true,
                    fillColor: colors.bg,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: _kHubColor,
                        width: 1.5,
                      ),
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
                colors: colors,
              ),
            ],
          ),
          if (categories.isNotEmpty) ...[
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: CategoryChip(
                      label: 'All',
                      compact: true,
                      selected: selectedCategoryId == null,
                      onTap: () => onCategorySelected(null),
                      colorOverride: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  ...categories.asMap().entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: CategoryChip(
                        categoryId: e.value.id,
                        compact: true,
                        selected: selectedCategoryId == e.value.id,
                        onTap: () => onCategorySelected(
                          selectedCategoryId == e.value.id ? null : e.value.id,
                        ),
                      ),
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
  const _ViewToggle({
    required this.current,
    required this.onChanged,
    required this.colors,
  });
  final NetworkView current;
  final ValueChanged<NetworkView> onChanged;
  final _NetworkColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewBtn(
            Icons.view_list_outlined,
            'Circuit',
            NetworkView.grid,
            current,
            onChanged,
            colors,
          ),
          _ViewBtn(
            Icons.hub_outlined,
            'Graph',
            NetworkView.graph,
            current,
            onChanged,
            colors,
          ),
          _ViewBtn(
            Icons.map_outlined,
            'Map',
            NetworkView.map,
            current,
            onChanged,
            colors,
          ),
        ],
      ),
    );
  }
}

class _ViewBtn extends StatelessWidget {
  const _ViewBtn(
    this.icon,
    this.tooltip,
    this.view,
    this.current,
    this.onChanged,
    this.colors,
  );
  final IconData icon;
  final String tooltip;
  final NetworkView view;
  final NetworkView current;
  final ValueChanged<NetworkView> onChanged;
  final _NetworkColors colors;

  @override
  Widget build(BuildContext context) {
    final active = current == view;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () => onChanged(view),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: active ? _kHubColor.withAlpha(40) : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: active ? _kHubColor : colors.textMuted,
              ),
              const SizedBox(width: 5),
              Text(
                tooltip,
                style: TextStyle(
                  color: active ? _kHubColor : colors.textMuted,
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
    required this.colors,
  });

  final List<DirectoryOfGoodSchema> dogs;
  final List<InitiativeSchema> inits;
  final List<CategorySchema> categories;
  final Map<String, ConnectionSummarySchema> dogSummaries;
  final Map<String, ConnectionSummarySchema> initSummaries;
  final List<ConnectionWithUserSchema> myConns;
  final _NetworkColors colors;

  @override
  State<_GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<_GraphView> {
  late final GraphifyController _controller;
  bool _chartReady = false;
  bool _modalOpen = false;
  bool _onlyConnected = false;
  bool _onlyYou = false;
  bool _showCategories = true;
  bool _showOrganizations = true;
  bool _showInitiatives = true;
  bool _showPeople = true;

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
      _controller.update(_buildOptions(context));
    }
  }

  void _refreshChart() {
    if (_chartReady) {
      _controller.update(_buildOptions(context));
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

  static bool _isLikelyRenderableImageUrl(String url) {
    if (url.isEmpty) return false;
    final lower = url.toLowerCase();

    const nonImageHosts = [
      'tiktok.com',
      'tiktokcdn-us.com',
      'tiktokcdn.com',
      'byteoversea.com',
      'ibytedtos.com',
      'wp.com',
      'wordpress.com',
      'instagram.com',
      'facebook.com',
      'youtube.com',
      'youtu.be',
      'twitter.com',
      'x.com',
      'linkedin.com',
    ];
    if (nonImageHosts.any(lower.contains)) return false;

    const imageExts = [
      '.png',
      '.jpg',
      '.jpeg',
      '.gif',
      '.webp',
      '.bmp',
      '.svg',
      '.avif',
    ];
    if (imageExts.any(lower.contains)) return true;

    return lower.contains('/image') ||
        lower.contains('img') ||
        lower.contains('avatar') ||
        lower.contains('logo') ||
        lower.contains('cdn.');
  }

  Map<String, dynamic> _buildOptions(BuildContext context) {
    final myDogIds = widget.myConns
        .where((c) => c.fromType == 'user' && c.toType == 'directory_of_good')
        .map((c) => c.toId)
        .toSet();
    final myInitIds = widget.myConns
        .where((c) => c.fromType == 'user' && c.toType == 'initiative')
        .map((c) => c.toId)
        .toSet();
    final myUserConn = widget.myConns.firstWhere(
      (c) => c.fromType == 'user',
      orElse: () => ConnectionWithUserSchema(
        id: '',
        createdBy: '',
        fromType: '',
        fromId: '',
        toType: '',
        toId: '',
        connectionType: '',
        createdAt: DateTime.fromMillisecondsSinceEpoch(0),
      ),
    );
    final myUserId = myUserConn.fromId.isNotEmpty ? myUserConn.fromId : null;

    final dogIdsLinkedToInitiatives = <String>{
      for (final summary in widget.initSummaries.values) ...summary.orgIds,
    };

    final visibleCategories = widget.categories;
    final visibleDogs = widget.dogs.where((dog) {
      if (!_showOrganizations) return false;
      final dogId = dog.id ?? dog.name;
      if (_onlyYou) return myDogIds.contains(dogId);
      if (!_onlyConnected) return true;
      final summaryCount = widget.dogSummaries[dogId]?.totalCount ?? 0;
      final linkedToInitiative = dogIdsLinkedToInitiatives.contains(dogId);
      return summaryCount > 0 || linkedToInitiative;
    }).toList();
    final visibleInits = widget.inits.where((init) {
      if (!_showInitiatives) return false;
      if (_onlyYou) return myInitIds.contains(init.id);
      if (!_onlyConnected) return true;
      final summary = widget.initSummaries[init.id];
      final summaryCount = summary?.totalCount ?? 0;
      final hasOrgLinks = (summary?.orgIds ?? const <String>[]).isNotEmpty;
      return summaryCount > 0 || hasOrgLinks;
    }).toList();

    final colors = widget.colors;
    final bgHex = _hex(colors.bg);
    final surfaceHex = _hex(colors.surface);
    final borderHex = _hex(colors.border);
    final textHex = _hex(colors.textPrimary);
    final catColorMap = <String?, String>{};
    for (final cat in visibleCategories) {
      catColorMap[cat.id] = _hex(
        CategoryColors.resolve(
          categoryName: cat.name,
          stableKey: cat.id,
        ),
      );
    }

    final nodes = <Map<String, dynamic>>[];
    final links = <Map<String, dynamic>>[];
    final dogColorById = <String, String>{};

    // ── Category hub nodes ──────────────────────────────────────────
    if (_showCategories) {
      for (int i = 0; i < visibleCategories.length; i++) {
        final cat = visibleCategories[i];
        if (cat.id == null) continue;
        final color = catColorMap[cat.id]!;
        nodes.add({
          'id': 'cat_${cat.id}',
          'name': cat.name,
          'symbolSize': 54,
          'itemStyle': {
            'color': color,
            'borderColor': '#FFFFFF',
            'borderWidth': 1.6,
            'shadowColor': color,
            'shadowBlur': 26,
          },
          'label': {
            'show': true,
            'color': color,
            'fontSize': 12,
            'fontWeight': 'bold',
            'position': 'bottom',
            'distance': 8,
            'formatter': '{b}',
          },
        });
      }
    }

    // ── DoG nodes ───────────────────────────────────────────────────
    for (final dog in visibleDogs) {
      final id = dog.id ?? dog.name;
      final color =
          catColorMap[dog.categoryIds.firstOrNull] ?? _hex(_kMapColor);
      dogColorById[id] = color;
      final summary = widget.dogSummaries[id];
      final totalConns = summary?.totalCount ?? 0;
      final isSelf = widget.myConns.any(
        (c) =>
            c.toType == 'directory_of_good' &&
            c.toId == id &&
            c.fromType == 'user',
      );

      // Nodes grow as more users follow them.
      final size = (22.0 + totalConns * 3.0).clamp(22.0, 64.0);

      final rawUrl = dog.imageUrl?.trim();
      final imageUrl = _normalizeImageUrl(rawUrl);
      final backendBase = AppConstants.backendBaseUrl;
      final canUseImageSymbol = _isLikelyRenderableImageUrl(imageUrl);
      final proxiedUrl = canUseImageSymbol
          ? '$backendBase/image-proxy/?url=${Uri.encodeComponent(imageUrl)}'
          : '';

      nodes.add({
        'id': 'dog_$id',
        'name': dog.name,
        'symbol': proxiedUrl.isNotEmpty ? 'image://$proxiedUrl' : 'circle',
        'symbolSize': size,
        'itemStyle': {
          'color': color,
          'opacity': 0.9,
          'borderColor': isSelf ? '#FFFFFF' : color,
          'borderWidth': isSelf ? 3.0 : 0.0,
          'shadowColor': isSelf ? color : 'rgba(0,0,0,0)',
          'shadowBlur': isSelf ? 18 : 0,
        },
        'label': {
          'show': true,
          'formatter': '{b}',
          'color': textHex,
          'fontSize': 9,
          'fontWeight': 600,
          'position': 'bottom',
          'distance': 4,
          'backgroundColor': 'rgba(13,17,23,0.55)',
          'padding': [2, 4],
          'borderRadius': 3,
        },
        'emphasis': {
          'label': {
            'show': true,
            'formatter': '{b}',
            'color': textHex,
            'fontSize': 10,
            'position': 'bottom',
            'distance': 4,
          },
        },
        'tooltip': {
          'formatter':
              '${dog.name}${totalConns > 0 ? " · $totalConns connections" : ""}',
        },
      });

      // DoG → category edge
      if (_showCategories) {
        for (final catId in dog.categoryIds) {
          final edgeColor = catColorMap[catId];
          if (edgeColor == null) continue;
          links.add({
            'source': 'dog_$id',
            'target': 'cat_$catId',
            'tooltip': {'show': false},
            'lineStyle': {'color': edgeColor, 'opacity': 0.25, 'width': 1},
          });
        }
      }
    }

    // ── Initiative nodes ─────────────────────────────────────────────
    for (final init in visibleInits) {
      final summary = widget.initSummaries[init.id];
      final totalConns = summary?.totalCount ?? 0;
      final isSelf = widget.myConns.any(
        (c) =>
            c.toType == 'initiative' &&
            c.toId == init.id &&
            c.fromType == 'user',
      );

      final size = (38.0 + totalConns * 3.8).clamp(38.0, 86.0);
      final color = _hex(_kInitColor);

      nodes.add({
        'id': 'init_${init.id}',
        'name': init.title,
        'symbol': 'diamond',
        'symbolSize': [size * 1.15, size * 1.15],
        'itemStyle': {
          'color': color,
          'opacity': 0.96,
          'borderColor': isSelf ? '#FFFFFF' : color,
          'borderWidth': isSelf ? 3.0 : 2.0,
          'shadowColor': color,
          'shadowBlur': isSelf ? 24 : 14,
        },
        'label': {
          'show': true,
          'formatter': '{b}',
          'color': textHex,
          'fontSize': 11,
          'fontWeight': 700,
          'position': 'bottom',
          'distance': 7,
          'backgroundColor': 'rgba(13,17,23,0.55)',
          'padding': [2, 4],
          'borderRadius': 3,
        },
        'emphasis': {
          'label': {
            'show': true,
            'formatter': '{b}',
            'color': textHex,
            'fontSize': 12,
            'position': 'bottom',
            'distance': 7,
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
      if (_showCategories &&
          init.categoryId != null &&
          catColorMap.containsKey(init.categoryId)) {
        links.add({
          'source': 'init_${init.id}',
          'target': 'cat_${init.categoryId}',
          'tooltip': {'show': false},
          'lineStyle': {'color': _hex(_kInitColor), 'opacity': 0.2, 'width': 1},
        });
      }
    }

    // ── User nodes + links (from preview users with >=1 connection) ─────────
    if (_showPeople) {
      final usersById = <String, PreviewUserSchema>{};
      final userToDogIds = <String, Set<String>>{};
      final userToInitIds = <String, Set<String>>{};

      for (final dog in visibleDogs) {
        final dogId = dog.id ?? dog.name;
        final summary = widget.dogSummaries[dogId];
        for (final user
            in summary?.previewUsers ?? const <PreviewUserSchema>[]) {
          if (user.id.isEmpty) continue;
          usersById[user.id] = user;
          userToDogIds.putIfAbsent(user.id, () => <String>{}).add(dogId);
        }
      }

      for (final init in visibleInits) {
        final summary = widget.initSummaries[init.id];
        for (final user
            in summary?.previewUsers ?? const <PreviewUserSchema>[]) {
          if (user.id.isEmpty) continue;
          usersById[user.id] = user;
          userToInitIds.putIfAbsent(user.id, () => <String>{}).add(init.id);
        }
      }

      if (_onlyYou && myUserId != null) {
        final myPreview = usersById[myUserId] ?? myUserConn.user;
        final name = (myPreview?.name ?? '').trim();
        final displayName = name.isNotEmpty ? name : 'You';
        final normalizedPhoto = _normalizeImageUrl(myPreview?.photoUrl);
        final canUsePhoto = _isLikelyRenderableImageUrl(normalizedPhoto);
        final photoProxyUrl = canUsePhoto
            ? '${AppConstants.backendBaseUrl}/image-proxy/?url=${Uri.encodeComponent(normalizedPhoto)}'
            : '';

        nodes.add({
          'id': 'user_$myUserId',
          'name': displayName,
          'symbol': photoProxyUrl.isNotEmpty
              ? 'image://$photoProxyUrl'
              : 'circle',
          'symbolSize': 20,
          'itemStyle': {
            'color': _hex(_kUserColor),
            'opacity': 0.98,
            'borderColor': '#FFFFFF',
            'borderWidth': 1.8,
            'shadowColor': _hex(_kUserColor),
            'shadowBlur': 14,
          },
          'label': {
            'show': true,
            'formatter': '{b}',
            'color': textHex,
            'fontSize': 9,
            'fontWeight': 700,
            'position': 'bottom',
            'distance': 3,
            'backgroundColor': 'rgba(13,17,23,0.55)',
            'padding': [1, 4],
            'borderRadius': 3,
          },
        });

        for (final dogId in myDogIds) {
          if (!visibleDogs.any((d) => (d.id ?? d.name) == dogId)) continue;
          final edgeColor = dogColorById[dogId] ?? _hex(_kMapColor);
          links.add({
            'source': 'user_$myUserId',
            'target': 'dog_$dogId',
            'tooltip': {'show': false},
            'lineStyle': {'color': edgeColor, 'opacity': 0.45, 'width': 1.4},
          });
        }

        for (final initId in myInitIds) {
          if (!visibleInits.any((i) => i.id == initId)) continue;
          links.add({
            'source': 'user_$myUserId',
            'target': 'init_$initId',
            'tooltip': {'show': false},
            'lineStyle': {
              'color': _hex(_kInitColor),
              'opacity': 0.5,
              'width': 1.5,
            },
          });
        }
      } else {
        for (final entry in usersById.entries) {
          final userId = entry.key;
          final user = entry.value;
          final name = (user.name ?? '').trim();
          final displayName = name.isNotEmpty ? name : 'Member';
          final normalizedPhoto = _normalizeImageUrl(user.photoUrl);
          final canUsePhoto = _isLikelyRenderableImageUrl(normalizedPhoto);
          final photoProxyUrl = canUsePhoto
              ? '${AppConstants.backendBaseUrl}/image-proxy/?url=${Uri.encodeComponent(normalizedPhoto)}'
              : '';

          nodes.add({
            'id': 'user_$userId',
            'name': displayName,
            'symbol': photoProxyUrl.isNotEmpty
                ? 'image://$photoProxyUrl'
                : 'circle',
            'symbolSize': 18,
            'itemStyle': {
              'color': _hex(_kUserColor),
              'opacity': 0.96,
              'borderColor': '#FFFFFF',
              'borderWidth': 1.2,
              'shadowColor': _hex(_kUserColor),
              'shadowBlur': 10,
            },
            'label': {
              'show': true,
              'formatter': '{b}',
              'color': textHex,
              'fontSize': 8,
              'fontWeight': 500,
              'position': 'bottom',
              'distance': 3,
              'backgroundColor': 'rgba(13,17,23,0.50)',
              'padding': [1, 3],
              'borderRadius': 3,
            },
          });

          for (final dogId in userToDogIds[userId] ?? const <String>{}) {
            final edgeColor = dogColorById[dogId] ?? _hex(_kMapColor);
            links.add({
              'source': 'user_$userId',
              'target': 'dog_$dogId',
              'tooltip': {'show': false},
              'lineStyle': {'color': edgeColor, 'opacity': 0.35, 'width': 1.2},
            });
          }

          for (final initId in userToInitIds[userId] ?? const <String>{}) {
            links.add({
              'source': 'user_$userId',
              'target': 'init_$initId',
              'tooltip': {'show': false},
              'lineStyle': {
                'color': _hex(_kInitColor),
                'opacity': 0.4,
                'width': 1.3,
              },
            });
          }
        }
      }
    }

    final initialZoom = (1.5 / math.sqrt(nodes.length.clamp(1, 9999))).clamp(
      0.1,
      0.36,
    );

    return {
      'backgroundColor': bgHex,
      'tooltip': {
        'trigger': 'item',
        'backgroundColor': surfaceHex,
        'borderColor': borderHex,
        'borderWidth': 1,
        'padding': [8, 12],
        'textStyle': {'color': textHex, 'fontSize': 12},
        'enterable': false,
      },
      'series': [
        {
          'type': 'graph',
          'layout': 'force',
          'animation': true,
          'animationDuration': 1000,
          'roam': true,
          'zoom': initialZoom,
          'center': ['50%', '50%'],
          'draggable': true,
          'data': nodes,
          'links': links,
          'lineStyle': {'color': borderHex, 'width': 1.0, 'opacity': 0.45},
          'emphasis': {
            'focus': 'adjacency',
            'lineStyle': {'width': 2.0, 'opacity': 0.9},
          },
          'force': {
            'initLayout': 'circular',
            'repulsion': 1500,
            'gravity': 0.015,
            'edgeLength': [220, 420],
            'friction': 0.7,
            'layoutAnimation': true,
          },
        },
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
            isMobile ? 8 : 10,
            isMobile ? 6 : 8,
            isMobile ? 8 : 10,
            isMobile ? 4 : 6,
          ),
          child: Wrap(
            spacing: isMobile ? 6 : 8,
            runSpacing: isMobile ? 6 : 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _GraphToggleChip(
                label: 'Only connected',
                selected: _onlyConnected,
                kind: _GraphToggleKind.scope,
                compact: isMobile,
                onTap: () {
                  setState(() => _onlyConnected = !_onlyConnected);
                  _refreshChart();
                },
              ),
              _GraphToggleChip(
                label: 'Only you',
                selected: _onlyYou,
                kind: _GraphToggleKind.scope,
                compact: isMobile,
                onTap: () {
                  setState(() => _onlyYou = !_onlyYou);
                  _refreshChart();
                },
              ),
              _GraphToggleChip(
                label: 'Categories',
                selected: _showCategories,
                compact: isMobile,
                onTap: () {
                  setState(() => _showCategories = !_showCategories);
                  _refreshChart();
                },
              ),
              _GraphToggleChip(
                label: 'Organizations',
                selected: _showOrganizations,
                compact: isMobile,
                onTap: () {
                  setState(() => _showOrganizations = !_showOrganizations);
                  _refreshChart();
                },
              ),
              _GraphToggleChip(
                label: 'Initiatives',
                selected: _showInitiatives,
                compact: isMobile,
                onTap: () {
                  setState(() => _showInitiatives = !_showInitiatives);
                  _refreshChart();
                },
              ),
              _GraphToggleChip(
                label: 'People',
                selected: _showPeople,
                compact: isMobile,
                onTap: () {
                  setState(() => _showPeople = !_showPeople);
                  _refreshChart();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: IgnorePointer(
            ignoring: _modalOpen,
            child: GraphifyView(
              controller: _controller,
              initialOptions: _buildOptions(context),
              onGraphEvent: (event) => _handleGraphEvent(context, event),
            ),
          ),
        ),
      ],
    );
  }

  void _handleGraphEvent(BuildContext context, Map<String, dynamic> event) {
    if (event['type'] != 'node_click') return;
    final data = event['data'];
    if (data is! Map) return;
    final rawId = data['id'];
    if (rawId is! String || rawId.isEmpty) return;
    if (rawId.startsWith('init_')) {
      _openEntityDetails(context, rawId.substring(5), 'initiative');
      return;
    }
    if (rawId.startsWith('dog_')) {
      _openEntityDetails(context, rawId.substring(4), 'directory_of_good');
      return;
    }
    if (rawId.startsWith('user_')) {
      final userId = rawId.substring(5);
      if (userId.isEmpty) return;
      _openUserProfile(context, userId);
    }
  }

  Future<void> _openUserProfile(BuildContext context, String userId) async {
    if (_modalOpen) return;
    setState(() => _modalOpen = true);
    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            insetPadding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: UserProfileView(userId: userId, embedded: true),
            ),
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() => _modalOpen = false);
      }
    }
  }

  Future<void> _openEntityDetails(
    BuildContext context,
    String entityId,
    String entityType,
  ) async {
    if (_modalOpen) return;
    setState(() => _modalOpen = true);
    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => Dialog(
          insetPadding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440, maxHeight: 760),
            child: EntityDetailPanel(
              entityId: entityId,
              entityType: entityType,
              dogSummaries: widget.dogSummaries,
              initSummaries: widget.initSummaries,
              allDogs: widget.dogs,
              allInits: widget.inits,
              onClose: () => Navigator.of(dialogContext).pop(),
              borderRadius: const BorderRadius.all(Radius.circular(18)),
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _modalOpen = false);
      }
    }
  }
}

class _GraphToggleChip extends StatelessWidget {
  const _GraphToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.kind = _GraphToggleKind.layer,
    this.compact = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final _GraphToggleKind kind;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isScope = kind == _GraphToggleKind.scope;
    final activeColor = isScope
        ? const Color(0xFF0EA5E9)
        : const Color(0xFF6366F1);
    final activeIcon = isScope
        ? Icons.filter_alt
        : Icons.layers;
    final inactiveIcon = isScope
        ? Icons.tune
        : Icons.radio_button_unchecked;
    final inactiveScopeBg = const Color(0xFF0EA5E9).withAlpha(22);
    return InkWell(
      borderRadius: BorderRadius.circular(isScope ? 999 : (compact ? 10 : 12)),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(
          horizontal: isScope ? (compact ? 12 : 14) : (compact ? 10 : 12),
          vertical: compact ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? activeColor.withAlpha(isScope ? 44 : 32)
              : (isScope
                  ? inactiveScopeBg
                  : theme.colorScheme.surfaceContainerHighest.withAlpha(80)),
          borderRadius:
              BorderRadius.circular(isScope ? 999 : (compact ? 10 : 12)),
          border: Border.all(
            color: selected
                ? activeColor.withAlpha(200)
                : theme.dividerColor.withAlpha(140),
            width: isScope
                ? (selected ? 2.0 : 1.3)
                : (selected ? (compact ? 1.4 : 1.6) : 1.0),
          ),
          boxShadow: isScope && selected
              ? [
                  BoxShadow(
                    color: activeColor.withAlpha(45),
                    blurRadius: 10,
                    spreadRadius: 0.5,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? activeIcon : inactiveIcon,
              size: compact ? 12 : 14,
              color: selected ? activeColor : theme.hintColor,
            ),
            SizedBox(width: compact ? 4 : 6),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? activeColor
                    : theme.textTheme.bodyMedium?.color,
                fontWeight: selected
                    ? FontWeight.w700
                    : (isScope ? FontWeight.w700 : FontWeight.w600),
                fontSize: compact ? 12 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _GraphToggleKind { scope, layer }
