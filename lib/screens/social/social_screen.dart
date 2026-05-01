import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/category_chip.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/providers/config_provider.dart';
import 'package:collective_action_frontend/providers/directory_of_good_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/social_summary.dart';
import 'package:collective_action_frontend/screens/social/directory_of_good_entry_card.dart';
import 'package:collective_action_frontend/services/directory_of_good_service.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'dart:math' show Random, max;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocialScreen extends ConsumerStatefulWidget {
  const SocialScreen({super.key});

  @override
  ConsumerState<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends ConsumerState<SocialScreen> {
  /// null = All categories
  String? _selectedCategoryId;
  final TextEditingController _searchController = TextEditingController();

  /// Mobile: 0 = Directory of Good, 1 = Action. Kept in state so tab
  /// switch can be deferred on mobile web (avoids crashes when changing tabs).
  int _selectedMobileTabIndex = 0;
  DirectoryOfGoodSchema? _randomPick;

  static String _entryIdentity(DirectoryOfGoodSchema entry) =>
      (entry.id != null && entry.id!.trim().isNotEmpty)
      ? 'id:${entry.id}'
      : 'name:${entry.name.trim().toLowerCase()}';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DirectoryOfGoodSchema> _filterByCategory(
    List<DirectoryOfGoodSchema> entries,
    String? categoryId,
  ) {
    if (categoryId == null) return entries;
    return entries.where((e) => e.categoryIds.contains(categoryId)).toList();
  }

  static String _locationString(LocationSchema? loc) {
    if (loc == null) return '';
    final parts = <String>[
      if (loc.city != null && loc.city!.isNotEmpty) loc.city!,
      if (loc.state != null && loc.state!.isNotEmpty) loc.state!,
      if (loc.country != null && loc.country!.isNotEmpty) loc.country!,
    ];
    return parts.join(' ');
  }

  List<DirectoryOfGoodSchema> _filterBySearch(
    List<DirectoryOfGoodSchema> entries,
    String query,
  ) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return entries;
    return entries.where((e) {
      final name = e.name.toLowerCase();
      final focus = (e.focus ?? '').toLowerCase();
      final loc = _locationString(e.location).toLowerCase();
      final website = (e.socialLinks?.website ?? '').trim().toLowerCase();
      return name.contains(q) ||
          focus.contains(q) ||
          loc.contains(q) ||
          website.contains(q);
    }).toList();
  }

  static String _normalizeExternalUrl(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return value;
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    return 'https://$value';
  }

  static bool _hasValue(String? value) =>
      value != null && value.trim().isNotEmpty;

  static String _socialUrl(String platform, String value) {
    final t = value.trim();
    if (t.startsWith('http://') || t.startsWith('https://')) return t;
    switch (platform) {
      case 'youtube':
        return 'https://youtube.com/@$t';
      case 'instagram':
        return 'https://instagram.com/$t';
      case 'tiktok':
        return 'https://tiktok.com/@$t';
      case 'website':
      default:
        return _normalizeExternalUrl(t);
    }
  }

  String? _randomCheckoutUrl(DirectoryOfGoodSchema entry) {
    final links = entry.socialLinks;
    if (links == null) return null;

    if (_hasValue(links.website)) {
      return _socialUrl('website', links.website!);
    }

    final socialOnlyUrls = <String>[
      if (_hasValue(links.youtube)) _socialUrl('youtube', links.youtube!),
      if (_hasValue(links.instagram)) _socialUrl('instagram', links.instagram!),
      if (_hasValue(links.tiktok)) _socialUrl('tiktok', links.tiktok!),
    ];
    if (socialOnlyUrls.isEmpty) return null;
    return socialOnlyUrls[Random().nextInt(socialOnlyUrls.length)];
  }

  void _pickRandomEntry(
    BuildContext context,
    List<DirectoryOfGoodSchema> pool,
  ) {
    if (pool.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.error('No entries available for random pick yet'),
      );
      return;
    }
    final pick = pool[Random().nextInt(pool.length)];
    setState(() {
      _randomPick = pick;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(CustomSnackBar.success('Random pick: ${pick.name}'));
  }

  void _clearRandomPick() {
    setState(() {
      _randomPick = null;
    });
  }

  void _checkOutRandomPick(BuildContext context, DirectoryOfGoodSchema pick) {
    final url = _randomCheckoutUrl(pick);
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.error(
          'No website or social links available for ${pick.name}',
        ),
      );
      return;
    }
    AppConstants.openUrl(url);
  }

  DirectoryOfGoodSchema? _activeRandomPickInPool(
    List<DirectoryOfGoodSchema> pool,
  ) {
    final pick = _randomPick;
    if (pick == null) return null;
    final pickIdentity = _entryIdentity(pick);
    for (final entry in pool) {
      if (_entryIdentity(entry) == pickIdentity) {
        return entry;
      }
    }
    return null;
  }

  List<DirectoryOfGoodSchema> _entriesToShow(List<DirectoryOfGoodSchema> pool) {
    final activePick = _activeRandomPickInPool(pool);
    if (activePick == null) return pool;
    return [activePick];
  }

  Widget _buildRandomPickAction(
    BuildContext context, {
    required List<DirectoryOfGoodSchema> pool,
  }) {
    final theme = Theme.of(context);
    final canPick = pool.isNotEmpty;
    final fill = theme.colorScheme.primary.withAlpha(canPick ? 26 : 14);
    final border = theme.colorScheme.primary.withAlpha(canPick ? 100 : 55);
    final textColor = theme.colorScheme.primary.withAlpha(canPick ? 255 : 135);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canPick ? () => _pickRandomEntry(context, pool) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: border, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.casino_rounded, size: 16, color: textColor),
              const SizedBox(width: 6),
              Text(
                'Pick for me',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionActionChip(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
    bool primary = false,
  }) {
    final theme = Theme.of(context);
    final color = primary
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;
    final textColor = primary
        ? color
        : theme.colorScheme.onSurface.withAlpha(190);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: color.withAlpha(primary ? 28 : 18),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color.withAlpha(primary ? 120 : 65)),
          ),
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRandomPickBanner(
    BuildContext context, {
    required DirectoryOfGoodSchema? pick,
  }) {
    if (pick == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final hasCheckoutOption = _randomCheckoutUrl(pick) != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(90)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildSelectionActionChip(
            context,
            label: 'Show all',
            onTap: _clearRandomPick,
          ),
          if (hasCheckoutOption) const SizedBox(width: 8),
          if (hasCheckoutOption)
            _buildSelectionActionChip(
              context,
              label: 'Check them out',
              onTap: () => _checkOutRandomPick(context, pick),
              primary: true,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppConstants.isMobile(context);
    final entriesAsync = ref.watch(directoryOfGoodEntriesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final previousData = entriesAsync.asData?.value;
    final allEntries = entriesAsync.asData?.value ?? [];
    final filteredEntries = _filterBySearch(
      _filterByCategory(allEntries, _selectedCategoryId),
      _searchController.text,
    );

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: isMobile
            ? _buildMobileLayout(
                context,
                ref,
                entriesAsync,
                categoriesAsync,
                previousData,
                allEntries,
                filteredEntries,
              )
            : _buildDesktopLayout(
                context,
                ref,
                entriesAsync,
                categoriesAsync,
                previousData,
                allEntries,
                filteredEntries,
              ),
      ),
    );
  }

  /// Mobile: tabs for Directory of Good and Activity feed. Uses IndexedStack
  /// and deferred tab switch so changing tabs doesn't run during the tap
  /// (avoids crashes on mobile web). Both tab contents stay mounted.
  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<DirectoryOfGoodSchema>> entriesAsync,
    AsyncValue<List<CategorySchema>> categoriesAsync,
    List<DirectoryOfGoodSchema>? previousData,
    List<DirectoryOfGoodSchema> allEntries,
    List<DirectoryOfGoodSchema> filteredEntries,
  ) {
    final isMobile = true;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activePick = _activeRandomPickInPool(filteredEntries);
    final visibleEntries = _entriesToShow(filteredEntries);

    return Column(
      children: [
        // Pill-style tab bar.
        Container(
          color: theme.colorScheme.surface,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceVariant : AppColors.silver,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _buildPillTab(
                  context,
                  0,
                  'Directory of Good',
                  Icons.menu_book_rounded,
                  isDark,
                ),
                _buildPillTab(
                  context,
                  1,
                  'Action',
                  Icons.dynamic_feed_rounded,
                  isDark,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: _selectedMobileTabIndex,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, isMobile, visibleEntries.length),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: _buildSearchField(context)),
                        const SizedBox(width: 12),
                        _buildRandomPickAction(context, pool: filteredEntries),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildCategoryFilter(context, categoriesAsync, allEntries),
                    const SizedBox(height: 10),
                    _buildRandomPickBanner(context, pick: activePick),
                    if (activePick != null) const SizedBox(height: 8),
                    const SizedBox(height: 16),
                    Expanded(
                      child: entriesAsync.when(
                        loading: () {
                          if (previousData != null && previousData.isNotEmpty) {
                            final prevFiltered = _filterBySearch(
                              _filterByCategory(
                                previousData,
                                _selectedCategoryId,
                              ),
                              _searchController.text,
                            );
                            final prevVisible = _entriesToShow(prevFiltered);
                            return _buildEntriesList(
                              context,
                              ref,
                              entries: prevVisible,
                              isMobile: isMobile,
                              compact: true,
                            );
                          }
                          return const _DirectorySkeletonGrid();
                        },
                        error: (err, _) => _buildError(context, ref, err),
                        data: (_) {
                          if (visibleEntries.isEmpty) {
                            return _buildEmpty(context);
                          }
                          return _buildEntriesList(
                            context,
                            ref,
                            entries: visibleEntries,
                            isMobile: isMobile,
                            compact: true,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeedHeader(context, isMobile),
                    const SizedBox(height: 16),
                    const Expanded(child: SocialActivityFeed()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Desktop: left = Directory of Good (multi-column grid, fills remaining space),
  /// right = Action (fixed 360px sidebar).
  Widget _buildDesktopLayout(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<DirectoryOfGoodSchema>> entriesAsync,
    AsyncValue<List<CategorySchema>> categoriesAsync,
    List<DirectoryOfGoodSchema>? previousData,
    List<DirectoryOfGoodSchema> allEntries,
    List<DirectoryOfGoodSchema> filteredEntries,
  ) {
    final isMobile = false;
    final activePick = _activeRandomPickInPool(filteredEntries);
    final visibleEntries = _entriesToShow(filteredEntries);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, isMobile, visibleEntries.length),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: _buildSearchField(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCategoryFilter(
                        context,
                        categoriesAsync,
                        allEntries,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildRandomPickAction(context, pool: filteredEntries),
                  ],
                ),
                const SizedBox(height: 10),
                _buildRandomPickBanner(context, pick: activePick),
                if (activePick != null) const SizedBox(height: 10),
                const SizedBox(height: 20),
                Expanded(
                  child: entriesAsync.when(
                    loading: () {
                      if (previousData != null && previousData.isNotEmpty) {
                        final prevFiltered = _filterBySearch(
                          _filterByCategory(previousData, _selectedCategoryId),
                          _searchController.text,
                        );
                        final prevVisible = _entriesToShow(prevFiltered);
                        return _buildEntriesList(
                          context,
                          ref,
                          entries: prevVisible,
                          isMobile: isMobile,
                          compact: true,
                        );
                      }
                      return const _DirectorySkeletonGrid();
                    },
                    error: (err, _) => _buildError(context, ref, err),
                    data: (_) {
                      if (visibleEntries.isEmpty) return _buildEmpty(context);
                      return _buildEntriesList(
                        context,
                        ref,
                        entries: visibleEntries,
                        isMobile: isMobile,
                        compact: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: 360,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeedHeader(context, isMobile),
                const SizedBox(height: 16),
                const Expanded(child: SocialActivityFeed()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillTab(
    BuildContext context,
    int index,
    String label,
    IconData icon,
    bool isDark,
  ) {
    final isSelected = _selectedMobileTabIndex == index;
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: () => scheduleAfterTap(context, () {
          if (mounted) setState(() => _selectedMobileTabIndex = index);
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.darkBackground : AppColors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withAlpha(120),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withAlpha(120),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedHeader(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);
    const actionAccent = AppColors.warningOrange;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: actionAccent.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.dynamic_feed_rounded,
            color: actionAccent,
            size: isMobile ? 28 : 36,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Action',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Recent community activity',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(180),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Search entries...',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear_rounded),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        isDense: true,
      ),
      style: theme.textTheme.bodyMedium,
    );
  }

  Widget _buildCategoryFilter(
    BuildContext context,
    AsyncValue<List<CategorySchema>> categoriesAsync,
    List<DirectoryOfGoodSchema> allEntries,
  ) {
    final theme = Theme.of(context);
    final isMobile = AppConstants.isMobile(context);

    return categoriesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (categories) {
        final sorted = [...categories]
          ..sort((a, b) => a.name.compareTo(b.name));

        final chips = <Widget>[
          CategoryChip(
            label: 'All',
            compact: true,
            selected: _selectedCategoryId == null,
            onTap: () => setState(() => _selectedCategoryId = null),
            colorOverride: theme.colorScheme.primary,
          ),
          ...sorted.map((category) {
            final isSelected = _selectedCategoryId == category.id;
            return CategoryChip(
              categoryId: category.id,
              compact: true,
              selected: isSelected,
              onTap: () => setState(() => _selectedCategoryId = category.id),
            );
          }),
        ];

        if (isMobile) {
          // Mobile: single scrollable row.
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: chips
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: c,
                    ),
                  )
                  .toList(),
            ),
          );
        }

        // Desktop: wrap onto as many lines as needed — no clipping.
        return Wrap(spacing: 8, runSpacing: 6, children: chips);
      },
    );
  }

  void _showAddEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => const _AddDirectoryOfGoodEntryDialog(),
    );
  }

  void _showDirectoryOfGoodInfo(BuildContext context) {
    const directoryAccent = AppColors.warningOrange;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.menu_book_rounded, color: directoryAccent),
            const SizedBox(width: 10),
            const Text('Directory of Good'),
          ],
        ),
        content: const Text(
          'A curated directory of people, groups, and projects doing good work and taking real world action. '
          'Use it to discover collaborators, learn what they focus on, and check out their websites or social media.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile, int count) {
    final theme = Theme.of(context);
    final isAdmin = ref.watch(isCurrentUserAdminProvider);
    const directoryAccent = AppColors.warningOrange;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: directoryAccent.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.menu_book_rounded,
            color: directoryAccent,
            size: isMobile ? 28 : 36,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'Directory of Good',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Tooltip(
                    message: 'What is the Directory of Good?',
                    child: InkWell(
                      onTap: () => _showDirectoryOfGoodInfo(context),
                      borderRadius: BorderRadius.circular(999),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: isMobile ? 18 : 20,
                          color: directoryAccent.withAlpha(210),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                count == 1 ? '1 entry' : '$count entries',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(180),
                ),
              ),
            ],
          ),
        ),
        if (isAdmin) ...[
          const SizedBox(width: 16),
          FilledButton.icon(
            onPressed: _showAddEntryDialog,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add entry'),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ],
    );
  }

  static const double _desktopCardMaxWidth = 720;
  static const double _twoColumnSpacing = 6.0;
  static const double _rowSpacing = 4.0;

  /// Stable key so list slots don't reuse the wrong entry (and web image views)
  /// after search/filter reorders the list.
  static Key _directoryEntryKey(DirectoryOfGoodSchema e) =>
      ValueKey<String>('directory-of-good-${e.id ?? e.name}');

  Widget _buildEntriesList(
    BuildContext context,
    WidgetRef ref, {
    required List<DirectoryOfGoodSchema> entries,
    required bool isMobile,
    bool compact = false,
  }) {
    Widget listView;
    if (compact) {
      final featured = entries.where((e) => e.featured).toList();
      final rest = entries.where((e) => !e.featured).toList();
      listView = LayoutBuilder(
        builder: (context, constraints) {
          const double targetCardWidth = 240.0;
          const double gap = _twoColumnSpacing;
          final cols = max(
            2,
            ((constraints.maxWidth + gap) / (targetCardWidth + gap)).floor(),
          );
          final cardWidth = (constraints.maxWidth - gap * (cols - 1)) / cols;
          final theme = Theme.of(context);

          Widget buildRow(List<DirectoryOfGoodSchema> group, int rowIndex) {
            final start = rowIndex * cols;
            final end = (start + cols).clamp(0, group.length);
            final rowItems = group.sublist(start, end);
            return Padding(
              padding: const EdgeInsets.only(bottom: _rowSpacing),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < rowItems.length; i++) ...[
                    if (i > 0) const SizedBox(width: gap),
                    SizedBox(
                      width: cardWidth,
                      child: DirectoryOfGoodEntryCard(
                        key: _directoryEntryKey(rowItems[i]),
                        entry: rowItems[i],
                        isMobile: isMobile,
                        compact: true,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          final featuredRowCount = (featured.length + cols - 1) ~/ cols;
          final restRowCount = (rest.length + cols - 1) ~/ cols;

          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (featured.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'Featured',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 6)),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, rowIndex) => buildRow(featured, rowIndex),
                    childCount: featuredRowCount,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
              ],
              if (restRowCount > 0)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, rowIndex) => buildRow(rest, rowIndex),
                    childCount: restRowCount,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      );
    } else {
      final featuredFirst = [
        ...entries.where((e) => e.featured),
        ...entries.where((e) => !e.featured),
      ];
      listView = ListView.separated(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: featuredFirst.length,
        separatorBuilder: (_, _) => SizedBox(height: isMobile ? 12 : 16),
        itemBuilder: (context, idx) {
          final entry = featuredFirst[idx];
          return DirectoryOfGoodEntryCard(
            key: _directoryEntryKey(entry),
            entry: entry,
            isMobile: isMobile,
            compact: compact,
          );
        },
      );
    }

    final child = RefreshIndicator(
      onRefresh: () async {
        await ref.read(directoryOfGoodEntriesProvider.notifier).refresh();
      },
      child: listView,
    );

    if (isMobile || compact) return child;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _desktopCardMaxWidth),
        child: child,
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object err) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.errorRed.withAlpha(200),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load directory of good',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              err.toString(),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.errorRed),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                ref.read(directoryOfGoodEntriesProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.lightBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.volunteer_activism_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No entries yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(180),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Directory of good entries will appear here.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(140),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Skeleton loading
// ---------------------------------------------------------------------------

class _DirectorySkeletonGrid extends StatefulWidget {
  const _DirectorySkeletonGrid();

  @override
  State<_DirectorySkeletonGrid> createState() => _DirectorySkeletonGridState();
}

class _DirectorySkeletonGridState extends State<_DirectorySkeletonGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(
      begin: 0.4,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const double targetCardWidth = 240.0;
    const double gap = _SocialScreenState._twoColumnSpacing;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = max(
          2,
          ((constraints.maxWidth + gap) / (targetCardWidth + gap)).floor(),
        );
        final cardWidth = (constraints.maxWidth - gap * (cols - 1)) / cols;
        // Enough skeletons to fill two viewport heights without over-building.
        final itemCount = cols * 6;
        final rowCount = (itemCount + cols - 1) ~/ cols;

        return AnimatedBuilder(
          animation: _opacity,
          builder: (context, _) => ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rowCount,
            itemBuilder: (_, rowIndex) {
              final start = rowIndex * cols;
              final end = (start + cols).clamp(0, itemCount);
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: _SocialScreenState._rowSpacing,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = start; i < end; i++) ...[
                      if (i > start) const SizedBox(width: gap),
                      Opacity(
                        opacity: _opacity.value,
                        child: SizedBox(
                          width: cardWidth,
                          child: _SkeletonCard(isDark: isDark),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final bool isDark;

  const _SkeletonCard({required this.isDark});

  Widget _box({
    double? width,
    required double height,
    double radius = 4,
    bool expand = false,
  }) {
    final color = isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE4E4E4);
    final box = Container(
      width: expand ? double.infinity : width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    return expand ? box : box;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(isDark ? 50 : 12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header band — matches the orange gradient header in real cards.
          Container(
            height: 64,
            color: isDark
                ? const Color(0xFF3D1A00)
                : const Color(0xFFFFA040).withAlpha(50),
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 11,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(100),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      FractionallySizedBox(
                        widthFactor: 0.55,
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(60),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _box(width: 72, height: 20, radius: 10), // category chip
                const SizedBox(height: 6),
                _box(expand: true, height: 10),
                const SizedBox(height: 4),
                FractionallySizedBox(
                  widthFactor: 0.65,
                  child: _box(expand: true, height: 10),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _box(expand: true, height: 10)),
                    const SizedBox(width: 8),
                    _box(width: 14, height: 14),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _AddDirectoryOfGoodEntryDialog extends ConsumerStatefulWidget {
  const _AddDirectoryOfGoodEntryDialog();

  @override
  ConsumerState<_AddDirectoryOfGoodEntryDialog> createState() =>
      _AddDirectoryOfGoodEntryDialogState();
}

class _AddDirectoryOfGoodEntryDialogState
    extends ConsumerState<_AddDirectoryOfGoodEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _focusController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _websiteController = TextEditingController();
  final _youtubeController = TextEditingController();
  final _instagramController = TextEditingController();
  final _tiktokController = TextEditingController();

  String? _selectedCategoryId;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _focusController.dispose();
    _imageUrlController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _websiteController.dispose();
    _youtubeController.dispose();
    _instagramController.dispose();
    _tiktokController.dispose();
    super.dispose();
  }

  static String? _trimOrNull(String? s) {
    final t = s?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = AppConstants.isMobile(context);
    final categoriesAsync = ref.watch(categoriesProvider);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.add_circle_outline, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          const Text('Add Directory of Good Entry'),
        ],
      ),
      content: SizedBox(
        width: isMobile ? double.maxFinite : 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Organization or initiative name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter a name'
                      : null,
                  enabled: !_isSaving,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _focusController,
                  decoration: const InputDecoration(
                    labelText: 'Focus',
                    hintText: 'What they do / mission',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  enabled: !_isSaving,
                ),
                const SizedBox(height: 16),
                categoriesAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (_, _) => Text(
                    'Failed to load categories',
                    style: TextStyle(color: AppColors.errorRed),
                  ),
                  data: (categories) {
                    return DropdownButtonFormField<String>(
                      initialValue: _selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('None'),
                        ),
                        ...categories.map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          ),
                        ),
                      ],
                      onChanged: _isSaving
                          ? null
                          : (v) => setState(() => _selectedCategoryId = v),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    hintText: 'https://...',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !_isSaving,
                ),
                const SizedBox(height: 16),
                Text(
                  'Location',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(),
                        ),
                        enabled: !_isSaving,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        decoration: const InputDecoration(
                          labelText: 'State',
                          border: OutlineInputBorder(),
                        ),
                        enabled: !_isSaving,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !_isSaving,
                ),
                const SizedBox(height: 20),
                Text(
                  'Social links',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _websiteController,
                  decoration: const InputDecoration(
                    labelText: 'Website',
                    hintText: 'URL or leave blank',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !_isSaving,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _youtubeController,
                  decoration: const InputDecoration(
                    labelText: 'YouTube',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !_isSaving,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _instagramController,
                  decoration: const InputDecoration(
                    labelText: 'Instagram',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !_isSaving,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _tiktokController,
                  decoration: const InputDecoration(
                    labelText: 'TikTok',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !_isSaving,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : _createEntry,
          icon: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check_rounded),
          label: Text(_isSaving ? 'Creating...' : 'Create'),
          style: FilledButton.styleFrom(backgroundColor: AppColors.primaryBlue),
        ),
      ],
    );
  }

  Future<void> _createEntry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final location =
          (_cityController.text.trim().isEmpty &&
              _stateController.text.trim().isEmpty &&
              _countryController.text.trim().isEmpty)
          ? null
          : LocationSchema(
              city: _trimOrNull(_cityController.text),
              state: _trimOrNull(_stateController.text),
              country: _trimOrNull(_countryController.text),
            );

      final website = _trimOrNull(_websiteController.text);
      final youtube = _trimOrNull(_youtubeController.text);
      final instagram = _trimOrNull(_instagramController.text);
      final tiktok = _trimOrNull(_tiktokController.text);
      final socialLinks =
          (website == null &&
              youtube == null &&
              instagram == null &&
              tiktok == null)
          ? null
          : SocialLinksSchema(
              website: website,
              youtube: youtube,
              instagram: instagram,
              tiktok: tiktok,
            );

      final create = DirectoryOfGoodCreate(
        name: _nameController.text.trim(),
        focus: _trimOrNull(_focusController.text),
        categoryIds: _selectedCategoryId != null ? [_selectedCategoryId!] : [],
        imageUrl: _trimOrNull(_imageUrlController.text),
        location: location,
        socialLinks: socialLinks,
      );

      final service = DirectoryOfGoodService();
      await service.createEntry(create);

      ref.invalidate(directoryOfGoodEntriesProvider);

      if (!mounted) return;
      navigator.pop();
      messenger.showSnackBar(
        CustomSnackBar.success('Directory of good entry created'),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      messenger.showSnackBar(
        CustomSnackBar.error('Failed to create entry: $e'),
      );
    }
  }
}
