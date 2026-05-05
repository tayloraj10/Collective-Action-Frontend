import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/components/category_chip.dart';
import 'package:collective_action_frontend/providers/connection_provider.dart';
import 'package:collective_action_frontend/providers/directory_of_good_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:collective_action_frontend/utils/external_network_image.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kMapColor = Color(0xFF16A34A);
const _kInitColor = Color(0xFF3B82F6);

/// Shared detail panel used by all three network views.
/// Pass [entityId] + [entityType] to display. Pass null to close.
class EntityDetailPanel extends ConsumerWidget {
  const EntityDetailPanel({
    super.key,
    required this.entityId,
    required this.entityType,
    required this.dogSummaries,
    required this.initSummaries,
    required this.allDogs,
    required this.allInits,
    required this.onClose,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(18)),
  });

  final String entityId;
  final String entityType; // 'directory_of_good' | 'initiative'
  final Map<String, ConnectionSummarySchema> dogSummaries;
  final Map<String, ConnectionSummarySchema> initSummaries;
  final List<DirectoryOfGoodSchema> allDogs;
  final List<InitiativeSchema> allInits;
  final VoidCallback onClose;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final bodyMaxHeight = (screenHeight * 0.62).clamp(260.0, 560.0).toDouble();
    final myConns = ref.watch(myConnectionsProvider).value ?? [];
    final currentUser = ref.watch(currentUserProvider).value;
    final myDog = ref
        .watch(directoryOfGoodEntriesByUserProvider)
        .value
        ?.firstOrNull;

    final isDog = entityType == 'directory_of_good';
    final dog = isDog
        ? allDogs.firstWhere(
            (d) => (d.id ?? d.name) == entityId,
            orElse: () => DirectoryOfGoodSchema(name: ''),
          )
        : null;
    final init = !isDog
        ? allInits.firstWhere(
            (i) => i.id == entityId,
            orElse: () => InitiativeSchema(
              id: entityId,
              title: '',
              action: '',
              createdBy: '',
            ),
          )
        : null;

    if (dog?.name.isEmpty == true && init?.title.isEmpty == true) {
      return const SizedBox.shrink();
    }

    final summary = isDog ? dogSummaries[entityId] : initSummaries[entityId];
    final accentColor = isDog ? _kMapColor : _kInitColor;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: borderRadius,
        border: Border.all(color: theme.dividerColor.withAlpha(70)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(-4, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withAlpha(34),
                  theme.colorScheme.surface.withAlpha(0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
            child: Row(
              children: [
                Icon(
                  isDog ? Icons.people_outline : Icons.trending_up,
                  size: 15,
                  color: accentColor,
                ),
                const SizedBox(width: 7),
                Text(
                  isDog ? 'Organization' : 'Initiative',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: onClose,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: bodyMaxHeight),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: isDog
                  ? _DogDetail(
                      dog: dog!,
                      summary: summary,
                      myConns: myConns,
                      currentUser: currentUser,
                      myDog: myDog,
                      allInits: allInits,
                      initSummaries: initSummaries,
                      accentColor: accentColor,
                    )
                  : _InitDetail(
                      init: init!,
                      summary: summary,
                      myConns: myConns,
                      currentUser: currentUser,
                      myDog: myDog,
                      allDogs: allDogs,
                      accentColor: accentColor,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── DoG detail ─────────────────────────────────────────────────────────────

class _DogDetail extends ConsumerWidget {
  const _DogDetail({
    required this.dog,
    required this.summary,
    required this.myConns,
    required this.currentUser,
    required this.myDog,
    required this.allInits,
    required this.initSummaries,
    required this.accentColor,
  });

  final DirectoryOfGoodSchema dog;
  final ConnectionSummarySchema? summary;
  final List<ConnectionWithUserSchema> myConns;
  final UserSchema? currentUser;
  final DirectoryOfGoodSchema? myDog;
  final List<InitiativeSchema> allInits;
  final Map<String, ConnectionSummarySchema> initSummaries;
  final Color accentColor;

  String get _entityId => dog.id ?? dog.name;

  bool get _isFollowing => myConns.any(
    (c) =>
        c.toType == 'directory_of_good' &&
        c.toId == _entityId &&
        c.fromType == 'user',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final imageUrl = dog.imageUrl?.trim();
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    final loc = dog.location;
    final locStr = [
      loc?.city,
      loc?.state,
      loc?.country,
    ].whereType<String>().where((s) => s.isNotEmpty).join(', ');

    // Initiatives this org has connected to.
    final connectedInits = allInits
        .where((i) => initSummaries[i.id]?.orgIds.contains(_entityId) ?? false)
        .toList();
    final userConnectionsAsync = ref.watch(
      entityConnectionsProvider(
        EntityConnectionsQuery(toType: 'directory_of_good', toId: _entityId),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withAlpha(20),
              ),
              child: ClipOval(
                child: hasImage
                    ? ExternalOrDataImage(
                        url: imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        preferHtmlElementOnWeb: false,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Text(
                            dog.name.isNotEmpty
                                ? dog.name[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          dog.name.isNotEmpty ? dog.name[0].toUpperCase() : '?',
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dog.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (locStr.isNotEmpty)
                    Text(
                      locStr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(130),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _MiniStatCard(
              value: '${summary?.userCount ?? 0}',
              label: 'Connections',
              color: accentColor,
            ),
            if (connectedInits.isNotEmpty)
              _MiniStatCard(
                value: '${connectedInits.length}',
                label: 'Initiatives',
                color: _kInitColor,
              ),
          ],
        ),
        _ConnectedPeopleSection(
          title: 'Connected People',
          connectionsAsync: userConnectionsAsync,
        ),
        const SizedBox(height: 14),
        if (currentUser != null)
          _FollowButton(
            isFollowing: _isFollowing,
            accentColor: accentColor,
            onTap: () => _toggleFollow(context, ref),
          )
        else
          OutlinedButton.icon(
            icon: const Icon(Icons.login, size: 15),
            label: const Text('Sign in to connect'),
            onPressed: () => safeGo(context, '/login'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
            ),
          ),
        if (dog.userId != null && dog.userId!.isNotEmpty) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => safeGo(context, '/contributions/${dog.userId!}'),
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 0),
              padding: const EdgeInsets.symmetric(vertical: 6),
            ),
            child: const Text('View contributions'),
          ),
        ],
        if (dog.focus?.isNotEmpty == true)
          _PanelSection(
            title: 'About',
            child: Text(
              dog.focus!,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
            ),
          ),
        if (dog.categoryIds.isNotEmpty)
          _PanelSection(
            title: 'Categories',
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: dog.categoryIds
                  .map((id) => CategoryChip(categoryId: id, compact: true))
                  .toList(),
            ),
          ),
        if (dog.socialLinks != null)
          _PanelSection(
            title: 'Links',
            child: _SocialIconRow(links: dog.socialLinks!),
          ),
        if (connectedInits.isNotEmpty)
          _PanelSection(
            title: 'Connected Initiatives',
            child: Column(
              children: connectedInits
                  .map(
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.trending_up,
                            size: 13,
                            color: _kInitColor,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              i.title,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _kInitColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  Future<void> _toggleFollow(BuildContext context, WidgetRef ref) async {
    if (currentUser?.id == null) return;
    final notifier = ref.read(myConnectionsProvider.notifier);
    try {
      if (_isFollowing) {
        await notifier.disconnect('directory_of_good', _entityId);
      } else {
        await notifier.connect(
          fromType: 'user',
          fromId: currentUser!.id!,
          toType: 'directory_of_good',
          toId: _entityId,
        );
      }
      ref.invalidate(connectionSummaryProvider('directory_of_good'));
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to update')));
      }
    }
  }
}

// ── Initiative detail ──────────────────────────────────────────────────────

class _InitDetail extends ConsumerWidget {
  const _InitDetail({
    required this.init,
    required this.summary,
    required this.myConns,
    required this.currentUser,
    required this.myDog,
    required this.allDogs,
    required this.accentColor,
  });

  final InitiativeSchema init;
  final ConnectionSummarySchema? summary;
  final List<ConnectionWithUserSchema> myConns;
  final UserSchema? currentUser;
  final DirectoryOfGoodSchema? myDog;
  final List<DirectoryOfGoodSchema> allDogs;
  final Color accentColor;

  bool get _isContributing => myConns.any(
    (c) =>
        c.toType == 'initiative' && c.toId == init.id && c.fromType == 'user',
  );

  bool get _isOrgContributing =>
      myDog != null &&
      myConns.any(
        (c) =>
            c.toType == 'initiative' &&
            c.toId == init.id &&
            c.fromType == 'directory_of_good',
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isAdmin = ref.watch(isCurrentUserAdminProvider);
    final progress = (init.goal ?? 0) > 0
        ? ((init.complete ?? 0) / init.goal!).clamp(0.0, 1.0)
        : null;

    // Orgs connected to this initiative
    final connectedOrgIds = summary?.orgIds ?? [];
    final connectedOrgs = allDogs
        .where((d) => connectedOrgIds.contains(d.id ?? d.name))
        .toList();
    final userConnectionsAsync = ref.watch(
      entityConnectionsProvider(
        EntityConnectionsQuery(toType: 'initiative', toId: init.id),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accentColor.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: accentColor.withAlpha(60)),
              ),
              child: const Icon(Icons.trending_up, color: _kInitColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                init.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _MiniStatCard(
              value: '${summary?.userCount ?? 0}',
              label: 'Contributors',
              color: accentColor,
            ),
            if (connectedOrgs.isNotEmpty)
              _MiniStatCard(
                value: '${connectedOrgs.length}',
                label: 'Organizations',
                color: _kMapColor,
              ),
            if (progress != null)
              _MiniStatCard(
                value: '${(progress * 100).toStringAsFixed(0)}%',
                label: 'Complete',
                color: accentColor,
              ),
          ],
        ),
        _ConnectedPeopleSection(
          title: 'Connected People',
          connectionsAsync: userConnectionsAsync,
        ),
        if (progress != null) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: accentColor.withAlpha(25),
              valueColor: AlwaysStoppedAnimation(accentColor),
            ),
          ),
        ],
        const SizedBox(height: 10),
        if (currentUser != null) ...[
          _FollowButton(
            isFollowing: _isContributing,
            accentColor: accentColor,
            label: _isContributing ? 'Taking part' : 'Take part',
            activeLabel: 'Taking part',
            icon: Icons.trending_up,
            onTap: () => _toggleContribute(
              context,
              ref,
              fromType: 'user',
              fromId: currentUser!.id!,
            ),
          ),
          if (myDog != null && isAdmin) ...[
            const SizedBox(height: 8),
            _FollowButton(
              isFollowing: _isOrgContributing,
              accentColor: _kMapColor,
              label: 'Connect ${myDog!.name}',
              activeLabel: '${myDog!.name} connected',
              icon: Icons.people_outline,
              onTap: () => _toggleContribute(
                context,
                ref,
                fromType: 'directory_of_good',
                fromId: myDog!.id ?? myDog!.name,
              ),
            ),
          ],
          if (isAdmin) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.add_link, size: 15),
              label: const Text('Admin: Link organization'),
              onPressed: () => _showAdminOrgPicker(context, ref, connectedOrgs),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 38),
              ),
            ),
          ],
        ] else ...[
          OutlinedButton.icon(
            icon: const Icon(Icons.login, size: 15),
            label: const Text('Sign in to contribute'),
            onPressed: () => safeGo(context, '/login'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
            ),
          ),
        ],
        if (connectedOrgs.isNotEmpty)
          _PanelSection(
            title: 'Organizations Contributing',
            child: _ConnectedOrgsSection(
              organizations: connectedOrgs,
              isAdmin: isAdmin,
              onRemove: (d) => _toggleContribute(
                context,
                ref,
                fromType: 'directory_of_good',
                fromId: d.id ?? d.name,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _showAdminOrgPicker(
    BuildContext context,
    WidgetRef ref,
    List<DirectoryOfGoodSchema> connectedOrgs,
  ) async {
    final connectedIds = connectedOrgs.map((d) => d.id ?? d.name).toSet();
    final availableOrgs =
        allDogs.where((d) => !connectedIds.contains(d.id ?? d.name)).toList()
          ..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );

    if (availableOrgs.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All organizations are already linked')),
        );
      }
      return;
    }

    final selectedOrgId = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Link organization to initiative'),
        content: SizedBox(
          width: 360,
          height: 320,
          child: ListView.separated(
            primary: false,
            itemCount: availableOrgs.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final org = availableOrgs[index];
              final orgId = org.id ?? org.name;
              return ListTile(
                dense: true,
                leading: const Icon(Icons.people_outline, size: 18),
                title: Text(
                  org.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Navigator.of(dialogContext).pop(orgId),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selectedOrgId == null || selectedOrgId.isEmpty) return;
    if (!context.mounted) return;
    await _toggleContribute(
      context,
      ref,
      fromType: 'directory_of_good',
      fromId: selectedOrgId,
    );
  }

  Future<void> _toggleContribute(
    BuildContext context,
    WidgetRef ref, {
    required String fromType,
    required String fromId,
  }) async {
    final notifier = ref.read(myConnectionsProvider.notifier);
    final isConnected =
        ref
            .read(myConnectionsProvider)
            .value
            ?.any(
              (c) =>
                  c.toType == 'initiative' &&
                  c.toId == init.id &&
                  c.fromType == fromType &&
                  c.fromId == fromId,
            ) ??
        false;
    try {
      if (isConnected) {
        await notifier.disconnect(
          'initiative',
          init.id,
          fromType: fromType,
          fromId: fromId,
        );
      } else {
        await notifier.connect(
          fromType: fromType,
          fromId: fromId,
          toType: 'initiative',
          toId: init.id,
        );
      }
      ref.invalidate(connectionSummaryProvider('initiative'));
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to update')));
      }
    }
  }
}

// ── Shared small widgets ───────────────────────────────────────────────────

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
    decoration: BoxDecoration(
      color: color.withAlpha(14),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withAlpha(45)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(160),
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _ConnectedPeopleSection extends StatelessWidget {
  const _ConnectedPeopleSection({
    required this.title,
    required this.connectionsAsync,
  });

  final String title;
  final AsyncValue<List<ConnectionWithUserSchema>> connectionsAsync;

  @override
  Widget build(BuildContext context) {
    return connectionsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 12),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, _) => _PanelSection(
        title: title,
        child: Text(
          'Failed to load connected people',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
      data: (connections) {
        const maxVisible = 8;
        final usersById = <String, ConnectionWithUserSchema>{};
        for (final c in connections) {
          if (c.fromType != 'user') continue;
          final userId = (c.user?.id ?? c.fromId).trim();
          if (userId.isEmpty) continue;
          final existing = usersById[userId];
          if (existing == null || c.createdAt.isAfter(existing.createdAt)) {
            usersById[userId] = c;
          }
        }
        final users = usersById.values.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        if (users.isEmpty) {
          return _PanelSection(
            title: title,
            child: Text(
              'No people connected yet',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        }

        final preview = users.take(maxVisible).toList();
        final overflow = (users.length - preview.length).clamp(0, 9999);
        return _PanelSection(
          title: '$title (${users.length})',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 46,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: preview.length + (overflow > 0 ? 1 : 0),
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    if (index < preview.length) {
                      final userId =
                          (preview[index].user?.id ?? preview[index].fromId)
                              .trim();
                      return UserAvatar(
                        userId: userId.isNotEmpty ? userId : null,
                        radius: 16,
                        showProfileOnTap: userId.isNotEmpty,
                        enableHero: false,
                      );
                    }
                    return Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha(25),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(140),
                        ),
                      ),
                      child: Text(
                        '+$overflow',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (users.length > preview.length)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: TextButton(
                    onPressed: () => _showAllUsersDialog(context, users),
                    child: Text('View all ${users.length}'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAllUsersDialog(
    BuildContext context,
    List<ConnectionWithUserSchema> users,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Connected People (${users.length})'),
        content: SizedBox(
          width: 420,
          height: 420,
          child: ListView.separated(
            itemCount: users.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) =>
                _ConnectedUserRow(connection: users[index]),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _ConnectedUserRow extends StatelessWidget {
  const _ConnectedUserRow({required this.connection});

  final ConnectionWithUserSchema connection;

  @override
  Widget build(BuildContext context) {
    final userId = (connection.user?.id ?? connection.fromId).trim();
    final displayName = connection.user?.name?.trim().isNotEmpty == true
        ? connection.user!.name!.trim()
        : 'User';

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: UserAvatar(
        userId: userId.isNotEmpty ? userId : null,
        radius: 12,
        showProfileOnTap: userId.isNotEmpty,
        enableHero: false,
      ),
      title: Text(displayName, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class _ConnectedOrgsSection extends StatelessWidget {
  const _ConnectedOrgsSection({
    required this.organizations,
    required this.isAdmin,
    required this.onRemove,
  });

  final List<DirectoryOfGoodSchema> organizations;
  final bool isAdmin;
  final ValueChanged<DirectoryOfGoodSchema> onRemove;

  @override
  Widget build(BuildContext context) {
    const maxVisible = 6;
    final preview = organizations.take(maxVisible).toList();
    final overflow = (organizations.length - preview.length).clamp(0, 9999);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...preview.map(
              (d) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: _kMapColor.withAlpha(16),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: _kMapColor.withAlpha(120)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: _kMapColor.withAlpha(35),
                      child: Text(
                        d.name.isNotEmpty ? d.name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 9,
                          color: _kMapColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 130),
                      child: Text(
                        d.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _kMapColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (isAdmin) ...[
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => onRemove(d),
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: _kMapColor.withAlpha(220),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (overflow > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(18),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withAlpha(120),
                  ),
                ),
                child: Text(
                  '+$overflow more',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
        if (overflow > 0)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Showing ${preview.length} of ${organizations.length}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
              ),
            ),
          ),
      ],
    );
  }
}

class _PanelSection extends StatelessWidget {
  const _PanelSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        child,
      ],
    ),
  );
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({
    required this.isFollowing,
    required this.accentColor,
    required this.onTap,
    this.label = 'Connect',
    this.activeLabel = 'Connected',
    this.icon = Icons.add,
  });

  final bool isFollowing;
  final Color accentColor;
  final VoidCallback onTap;
  final String label;
  final String activeLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isFollowing ? accentColor : accentColor.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isFollowing ? accentColor : accentColor.withAlpha(60),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFollowing ? Icons.check : icon,
            size: 15,
            color: isFollowing ? Colors.white : accentColor,
          ),
          const SizedBox(width: 6),
          Text(
            isFollowing ? activeLabel : label,
            style: TextStyle(
              color: isFollowing ? Colors.white : accentColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ),
  );
}

class _SocialIconRow extends StatelessWidget {
  const _SocialIconRow({required this.links});
  final SocialLinksSchema links;

  static String _normalizeToHttpsUrl(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';
    final uri = Uri.tryParse(trimmed);
    if (uri != null && uri.hasScheme) return trimmed;
    if (trimmed.startsWith('//')) return 'https:$trimmed';
    return 'https://$trimmed';
  }

  static String _profileUrl(String basePath, String handle) {
    final normalizedHandle = handle.trim().replaceFirst(RegExp(r'^@+'), '');
    if (normalizedHandle.isEmpty) return '';
    final normalizedBase = basePath.trim().replaceAll(RegExp(r'/+$'), '');
    final separator = normalizedBase.endsWith('@') ? '' : '/';
    return 'https://$normalizedBase$separator$normalizedHandle';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = <(IconData, String, String, Color)>[];
    if (links.instagram?.isNotEmpty == true) {
      final instagramUrl = _profileUrl('instagram.com', links.instagram!);
      if (instagramUrl.isNotEmpty) {
        items.add((
          Icons.camera_alt_outlined,
          'Instagram',
          instagramUrl,
          const Color(0xFFE1306C),
        ));
      }
    }
    if (links.tiktok?.isNotEmpty == true) {
      final tiktokUrl = _profileUrl('tiktok.com/@', links.tiktok!);
      if (tiktokUrl.isNotEmpty) {
        items.add((
          Icons.music_note_outlined,
          'TikTok',
          tiktokUrl,
          isDark ? Colors.white : Colors.black87,
        ));
      }
    }
    if (links.youtube?.isNotEmpty == true) {
      final youtubeUrl = _profileUrl('youtube.com/@', links.youtube!);
      if (youtubeUrl.isNotEmpty) {
        items.add((
          Icons.smart_display_outlined,
          'YouTube',
          youtubeUrl,
          const Color(0xFFFF0000),
        ));
      }
    }
    if (links.website?.isNotEmpty == true) {
      final websiteUrl = _normalizeToHttpsUrl(links.website!);
      if (websiteUrl.isNotEmpty) {
        items.add((
          Icons.language_outlined,
          'Website',
          websiteUrl,
          const Color(0xFF3B82F6),
        ));
      }
    }
    if (items.isEmpty) {
      return Text(
        'No links added',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (item) => Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => AppConstants.openUrl(item.$3),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: item.$4.withAlpha(isDark ? 36 : 24),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: item.$4.withAlpha(isDark ? 120 : 90),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: item.$4.withAlpha(isDark ? 40 : 24),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.$1, size: 14, color: item.$4),
                      const SizedBox(width: 6),
                      Text(
                        item.$2,
                        style: TextStyle(
                          color: item.$4,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
