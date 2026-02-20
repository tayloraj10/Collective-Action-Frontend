import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/category_chip.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/providers/config_provider.dart';
import 'package:collective_action_frontend/providers/directory_of_good_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/social/directory_of_good_entry_card.dart';
import 'package:collective_action_frontend/services/directory_of_good_service.dart';
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

  List<DirectoryOfGoodSchema> _filterByCategory(
    List<DirectoryOfGoodSchema> entries,
    String? categoryId,
  ) {
    if (categoryId == null) return entries;
    return entries
        .where((e) => e.categoryId != null && e.categoryId == categoryId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppConstants.isMobile(context);
    final entriesAsync = ref.watch(directoryOfGoodEntriesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final previousData = entriesAsync.asData?.value;
    final allEntries = entriesAsync.asData?.value ?? [];
    final filteredEntries = _filterByCategory(allEntries, _selectedCategoryId);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isMobile, filteredEntries.length),
              SizedBox(height: isMobile ? 16 : 20),
              _buildCategoryFilter(context, categoriesAsync, allEntries),
              SizedBox(height: isMobile ? 16 : 20),
              Expanded(
                child: entriesAsync.when(
                  loading: () {
                    if (previousData != null && previousData.isNotEmpty) {
                      final prevFiltered = _filterByCategory(
                        previousData,
                        _selectedCategoryId,
                      );
                      return _buildEntriesList(
                        context,
                        ref,
                        entries: prevFiltered,
                        isMobile: isMobile,
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (err, _) => _buildError(context, ref, err),
                  data: (entries) {
                    if (filteredEntries.isEmpty) {
                      return _buildEmpty(context);
                    }
                    return _buildEntriesList(
                      context,
                      ref,
                      entries: filteredEntries,
                      isMobile: isMobile,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(
    BuildContext context,
    AsyncValue<List<CategorySchema>> categoriesAsync,
    List<DirectoryOfGoodSchema> allEntries,
  ) {
    final theme = Theme.of(context);
    final categoryIdsInData = allEntries
        .map((e) => e.categoryId)
        .whereType<String>()
        .toSet();

    return categoriesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (categories) {
        final categoriesInData = categories
            .where((c) => c.id != null && categoryIdsInData.contains(c.id))
            .toList();
        final viewportWidth = MediaQuery.of(context).size.width;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: viewportWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CategoryChip(
                  label: 'All',
                  compact: false,
                  selected: _selectedCategoryId == null,
                  onTap: () => setState(() => _selectedCategoryId = null),
                  colorOverride: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                ...categoriesInData.map((category) {
                  final isSelected = _selectedCategoryId == category.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CategoryChip(
                      categoryId: category.id,
                      compact: false,
                      selected: isSelected,
                      onTap: () =>
                          setState(() => _selectedCategoryId = category.id),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => const _AddDirectoryOfGoodEntryDialog(),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile, int count) {
    final theme = Theme.of(context);
    final isAdmin = ref.watch(isCurrentUserAdminProvider);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.menu_book_rounded,
            color: theme.colorScheme.primary,
            size: isMobile ? 28 : 36,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Directory of Good',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
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

  Widget _buildEntriesList(
    BuildContext context,
    WidgetRef ref, {
    required List<DirectoryOfGoodSchema> entries,
    required bool isMobile,
  }) {
    final listView = ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: entries.length,
      separatorBuilder: (_, _) => SizedBox(height: isMobile ? 12 : 16),
      itemBuilder: (context, idx) {
        return DirectoryOfGoodEntryCard(
          entry: entries[idx],
          isMobile: isMobile,
        );
      },
    );

    final child = RefreshIndicator(
      onRefresh: () async {
        await ref.read(directoryOfGoodEntriesProvider.notifier).refresh();
      },
      child: listView,
    );

    if (isMobile) return child;
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
        categoryId: _selectedCategoryId,
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
