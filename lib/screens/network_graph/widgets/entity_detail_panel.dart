import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/components/category_chip.dart';
import 'package:collective_action_frontend/providers/connection_provider.dart';
import 'package:collective_action_frontend/providers/directory_of_good_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/utils/external_network_image.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kMapColor  = Color(0xFF16A34A);
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
  });

  final String entityId;
  final String entityType; // 'directory_of_good' | 'initiative'
  final Map<String, ConnectionSummarySchema> dogSummaries;
  final Map<String, ConnectionSummarySchema> initSummaries;
  final List<DirectoryOfGoodSchema> allDogs;
  final List<InitiativeSchema> allInits;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final myConns = ref.watch(myConnectionsProvider).value ?? [];
    final currentUser = ref.watch(currentUserProvider).value;
    final myDog = ref.watch(directoryOfGoodEntriesByUserProvider).value?.firstOrNull;

    final isDog = entityType == 'directory_of_good';
    final dog = isDog
        ? allDogs.firstWhere((d) => (d.id ?? d.name) == entityId,
            orElse: () => DirectoryOfGoodSchema(name: ''))
        : null;
    final init = !isDog
        ? allInits.firstWhere((i) => i.id == entityId,
            orElse: () => InitiativeSchema(
                id: entityId, title: '', action: '', createdBy: ''))
        : null;

    if (dog?.name.isEmpty == true && init?.title.isEmpty == true) {
      return const SizedBox.shrink();
    }

    final summary = isDog ? dogSummaries[entityId] : initSummaries[entityId];
    final accentColor = isDog ? _kMapColor : _kInitColor;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          left: BorderSide(
              color: theme.dividerColor.withAlpha(80)),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 16,
              offset: const Offset(-4, 0)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            color: accentColor.withAlpha(12),
            padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
            child: Row(
              children: [
                Icon(isDog ? Icons.people_outline : Icons.trending_up,
                    size: 15, color: accentColor),
                const SizedBox(width: 7),
                Text(
                  isDog ? 'Organization' : 'Initiative',
                  style: TextStyle(
                      color: accentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5),
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
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

  bool get _isFollowing => myConns.any((c) =>
      c.toType == 'directory_of_good' &&
      c.toId == _entityId &&
      c.fromType == 'user');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final imageUrl = dog.imageUrl?.trim();
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    final loc = dog.location;
    final locStr = [loc?.city, loc?.state, loc?.country]
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .join(', ');

    // Initiatives this org has connected to.
    final connectedInits = allInits
        .where((i) => initSummaries[i.id]?.orgIds.contains(_entityId) ?? false)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image + name
        Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withAlpha(20),
              ),
              child: ClipOval(
                child: hasImage
                    ? ExternalOrDataImage(
                        url: imageUrl,
                        width: 52, height: 52,
                        fit: BoxFit.cover)
                    : Center(
                        child: Text(
                          dog.name.isNotEmpty
                              ? dog.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                              color: accentColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dog.name,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  if (locStr.isNotEmpty)
                    Text(locStr,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withAlpha(120))),
                ],
              ),
            ),
          ],
        ),

        // Stats row
        if (summary != null && summary!.totalCount > 0) ...[
          const SizedBox(height: 12),
          Row(children: [
            _StatBadge('${summary!.userCount}', 'followers', accentColor),
            if (connectedInits.isNotEmpty) ...[
              const SizedBox(width: 8),
              _StatBadge('${connectedInits.length}',
                  'initiatives', _kInitColor),
            ],
          ]),
        ],

        // Focus
        if (dog.focus != null && dog.focus!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(dog.focus!,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.5)),
        ],

        // Categories
        if (dog.categoryIds.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 6, runSpacing: 4,
            children: dog.categoryIds
                .map((id) => CategoryChip(
                    categoryId: id, compact: true))
                .toList(),
          ),
        ],

        // Connected initiatives
        if (connectedInits.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text('CONTRIBUTING TO',
              style: theme.textTheme.labelSmall?.copyWith(
                  color: _kInitColor,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          ...connectedInits.map((i) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(children: [
                  const Icon(Icons.trending_up,
                      size: 12, color: _kInitColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(i.title,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: _kInitColor)),
                  ),
                ]),
              )),
        ],

        // Social links
        if (dog.socialLinks != null) ...[
          const SizedBox(height: 12),
          _SocialRow(links: dog.socialLinks!),
        ],

        const SizedBox(height: 16),

        // Action buttons
        if (currentUser != null) ...[
          _FollowButton(
            isFollowing: _isFollowing,
            accentColor: accentColor,
            onTap: () => _toggleFollow(context, ref),
          ),
        ] else ...[
          OutlinedButton.icon(
            icon: const Icon(Icons.login, size: 15),
            label: const Text('Sign in to follow'),
            onPressed: () => safeGo(context, '/login'),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 38)),
          ),
        ],

        // View full profile
        const SizedBox(height: 8),
        TextButton(
          onPressed: () =>
              safeGo(context, '/contributions/${currentUser?.id ?? ""}'),
          style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 0),
              padding: const EdgeInsets.symmetric(vertical: 6)),
          child: const Text('View contributions'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update')),
        );
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

  bool get _isContributing => myConns.any((c) =>
      c.toType == 'initiative' &&
      c.toId == init.id &&
      c.fromType == 'user');

  bool get _isOrgContributing =>
      myDog != null &&
      myConns.any((c) =>
          c.toType == 'initiative' &&
          c.toId == init.id &&
          c.fromType == 'directory_of_good');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final progress = (init.goal ?? 0) > 0
        ? ((init.complete ?? 0) / init.goal!).clamp(0.0, 1.0)
        : null;

    // Orgs connected to this initiative
    final connectedOrgIds = summary?.orgIds ?? [];
    final connectedOrgs = allDogs
        .where((d) => connectedOrgIds.contains(d.id ?? d.name))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(init.title,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(init.action,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurface.withAlpha(160),
                    height: 1.4)),

        // Stats
        if (summary != null && summary!.totalCount > 0) ...[
          const SizedBox(height: 12),
          Row(children: [
            _StatBadge(
                '${summary!.userCount}', 'contributors', accentColor),
            if (connectedOrgs.isNotEmpty) ...[
              const SizedBox(width: 8),
              _StatBadge(
                  '${connectedOrgs.length}', 'orgs', _kMapColor),
            ],
          ]),
        ],

        // Progress
        if (progress != null) ...[
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${init.complete ?? 0} / ${init.goal}',
                  style: theme.textTheme.labelSmall?.copyWith(
                      color: accentColor, fontWeight: FontWeight.w600)),
              Text('${(progress * 100).toStringAsFixed(0)}%',
                  style: theme.textTheme.labelSmall?.copyWith(
                      color: accentColor)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: accentColor.withAlpha(25),
              valueColor: AlwaysStoppedAnimation(accentColor),
            ),
          ),
        ],

        // Connected orgs
        if (connectedOrgs.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text('ORGANIZATIONS CONTRIBUTING',
              style: theme.textTheme.labelSmall?.copyWith(
                  color: _kMapColor,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6, runSpacing: 4,
            children: connectedOrgs
                .map((d) => Chip(
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      avatar: CircleAvatar(
                          backgroundColor:
                              _kMapColor.withAlpha(30),
                          child: Text(
                              d.name.isNotEmpty
                                  ? d.name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                  fontSize: 9,
                                  color: _kMapColor))),
                      label: Text(d.name,
                          style: const TextStyle(fontSize: 11)),
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.symmetric(
                          horizontal: 6),
                    ))
                .toList(),
          ),
        ],

        const SizedBox(height: 16),

        // Action buttons
        if (currentUser != null) ...[
          _FollowButton(
            isFollowing: _isContributing,
            accentColor: accentColor,
            label: _isContributing ? 'Contributing' : 'Contribute',
            activeLabel: 'Contributing',
            icon: Icons.trending_up,
            onTap: () => _toggleContribute(context, ref,
                fromType: 'user', fromId: currentUser!.id!),
          ),
          if (myDog != null) ...[
            const SizedBox(height: 8),
            _FollowButton(
              isFollowing: _isOrgContributing,
              accentColor: _kMapColor,
              label: 'Connect ${myDog!.name}',
              activeLabel: '${myDog!.name} connected',
              icon: Icons.people_outline,
              onTap: () => _toggleContribute(context, ref,
                  fromType: 'directory_of_good',
                  fromId: myDog!.id ?? myDog!.name),
            ),
          ],
        ] else ...[
          OutlinedButton.icon(
            icon: const Icon(Icons.login, size: 15),
            label: const Text('Sign in to contribute'),
            onPressed: () => safeGo(context, '/login'),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 38)),
          ),
        ],
      ],
    );
  }

  Future<void> _toggleContribute(
    BuildContext context,
    WidgetRef ref, {
    required String fromType,
    required String fromId,
  }) async {
    final notifier = ref.read(myConnectionsProvider.notifier);
    final isConnected = ref
        .read(myConnectionsProvider)
        .value
        ?.any((c) =>
            c.toType == 'initiative' &&
            c.toId == init.id &&
            c.fromType == fromType) ??
        false;
    try {
      if (isConnected) {
        await notifier.disconnect('initiative', init.id);
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update')),
        );
      }
    }
  }
}

// ── Shared small widgets ───────────────────────────────────────────────────

class _StatBadge extends StatelessWidget {
  const _StatBadge(this.value, this.label, this.color);
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF8B949E), fontSize: 11)),
        ]),
      );
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({
    required this.isFollowing,
    required this.accentColor,
    required this.onTap,
    this.label = 'Follow',
    this.activeLabel = 'Following',
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
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isFollowing ? accentColor : accentColor.withAlpha(15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: isFollowing
                    ? accentColor
                    : accentColor.withAlpha(60)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isFollowing ? Icons.check : icon,
                  size: 15,
                  color: isFollowing ? Colors.white : accentColor),
              const SizedBox(width: 6),
              Text(
                isFollowing ? activeLabel : label,
                style: TextStyle(
                    color: isFollowing ? Colors.white : accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
            ],
          ),
        ),
      );
}

class _SocialRow extends StatelessWidget {
  const _SocialRow({required this.links});
  final SocialLinksSchema links;

  @override
  Widget build(BuildContext context) {
    final items = <(String, String)>[];
    if (links.instagram?.isNotEmpty == true) {
      items.add(('instagram.com/${links.instagram}', 'Instagram'));
    }
    if (links.tiktok?.isNotEmpty == true) {
      items.add(('tiktok.com/@${links.tiktok}', 'TikTok'));
    }
    if (links.youtube?.isNotEmpty == true) {
      items.add(('youtube.com/@${links.youtube}', 'YouTube'));
    }
    if (links.website?.isNotEmpty == true) {
      items.add((links.website!, 'Website'));
    }
    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: items
          .map((item) => GestureDetector(
                onTap: () => AppConstants.openUrl(item.$1),
                child: Text(item.$2,
                    style: const TextStyle(
                        color: Color(0xFF58A6FF),
                        fontSize: 12,
                        decoration: TextDecoration.underline)),
              ))
          .toList(),
    );
  }
}
