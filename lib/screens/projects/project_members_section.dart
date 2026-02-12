import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:collective_action_frontend/screens/user/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Compact summary of member counts for use in cards/lists.
/// Does not resolve user names; use [ProjectMembersAvatars] for avatars.
class ProjectMembersSummary extends StatelessWidget {
  final MemberIdsByRole? members;
  final bool isMobile;
  final Color? accentColor;

  const ProjectMembersSummary({
    super.key,
    required this.members,
    this.isMobile = true,
    this.accentColor,
  });

  static int totalCount(MemberIdsByRole? m) {
    if (m == null) return 0;
    return m.owners.length + m.developers.length + m.members.length;
  }

  static bool hasMembers(MemberIdsByRole? m) => totalCount(m) > 0;

  @override
  Widget build(BuildContext context) {
    if (members == null || !hasMembers(members)) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = accentColor ?? Theme.of(context).colorScheme.primary;
    final parts = <String>[];
    if (members!.owners.isNotEmpty) {
      parts.add(
        '${members!.owners.length} owner${members!.owners.length == 1 ? '' : 's'}',
      );
    }
    if (members!.developers.isNotEmpty) {
      parts.add(
        '${members!.developers.length} developer${members!.developers.length == 1 ? '' : 's'}',
      );
    }
    if (members!.members.isNotEmpty) {
      parts.add(
        '${members!.members.length} member${members!.members.length == 1 ? '' : 's'}',
      );
    }
    if (parts.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withAlpha(isDark ? 35 : 25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_rounded, size: 14, color: accent),
          const SizedBox(width: 5),
          Text(
            parts.join(' · '),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: accent,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// Scrollable list of member avatars. Use on project detail or dialogs.
class ProjectMembersAvatars extends ConsumerWidget {
  final MemberIdsByRole? members;
  final double avatarSize;
  final Axis scrollDirection;

  const ProjectMembersAvatars({
    super.key,
    required this.members,
    this.avatarSize = 40,
    this.scrollDirection = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (members == null) return const SizedBox.shrink();

    final ids = [
      ...members!.owners,
      ...members!.developers,
      ...members!.members,
    ];
    if (ids.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: scrollDirection == Axis.horizontal ? avatarSize + 8 : null,
      width: scrollDirection == Axis.vertical ? avatarSize + 8 : null,
      child: ListView.separated(
        scrollDirection: scrollDirection,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: ids.length,
        separatorBuilder: (_, _) => scrollDirection == Axis.horizontal
            ? const SizedBox(width: 8)
            : const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final userId = ids[index];
          final userAsync = ref.watch(userProvider(userId));
          return userAsync.when(
            loading: () => SizedBox(
              width: avatarSize,
              height: avatarSize,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (_, _) => UserAvatar(
              userId: userId,
              radius: avatarSize / 2,
              showProfileOnTap: true,
            ),
            data: (user) {
              final name = user?.name ?? user?.email;
              final avatar = UserAvatar(
                userId: userId,
                radius: avatarSize / 2,
                showProfileOnTap: true,
              );
              if (name != null && name.isNotEmpty) {
                return Tooltip(message: name, child: avatar);
              }
              return avatar;
            },
          );
        },
      ),
    );
  }
}

/// Members grouped by role (Owners, Developers, Members) with avatar + name.
/// Use on project detail screen or dialog for a polished look.
class ProjectMembersByRole extends ConsumerWidget {
  final MemberIdsByRole? members;
  final double avatarSize;
  final Widget? trailing;

  const ProjectMembersByRole({
    super.key,
    required this.members,
    this.avatarSize = 40,
    this.trailing,
  });

  static int _totalCount(MemberIdsByRole? m) {
    if (m == null) return 0;
    return m.owners.length + m.developers.length + m.members.length;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final total = _totalCount(members);
    final hasMembers = members != null && total > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.people_rounded,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Team',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(isDark ? 60 : 40),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$total',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            if (trailing != null) ...[
              const Spacer(),
              trailing!,
            ],
          ],
        ),
        if (hasMembers) ...[
          const SizedBox(height: 14),
          if (members!.owners.isNotEmpty) ...[
          _RoleSection(
            label: 'Owners',
            count: members!.owners.length,
            color: AppColors.warningOrange,
            ids: members!.owners,
            avatarSize: avatarSize,
            isDark: isDark,
          ),
          const SizedBox(height: 14),
        ],
        if (members!.developers.isNotEmpty) ...[
          _RoleSection(
            label: 'Developers',
            count: members!.developers.length,
            color: AppColors.lightBlue,
            ids: members!.developers,
            avatarSize: avatarSize,
            isDark: isDark,
          ),
          const SizedBox(height: 14),
        ],
          if (members!.members.isNotEmpty)
            _RoleSection(
              label: 'Members',
              count: members!.members.length,
              color: theme.colorScheme.onSurface.withAlpha(isDark ? 160 : 140),
              ids: members!.members,
              avatarSize: avatarSize,
              isDark: isDark,
            ),
        ],
      ],
    );
  }
}

/// Max number of member chips shown per role before "Show more".
const int _kInitialVisiblePerRole = 8;

class _RoleSection extends StatefulWidget {
  final String label;
  final int count;
  final Color color;
  final List<String> ids;
  final double avatarSize;
  final bool isDark;

  const _RoleSection({
    required this.label,
    required this.count,
    required this.color,
    required this.ids,
    required this.avatarSize,
    required this.isDark,
  });

  @override
  State<_RoleSection> createState() => _RoleSectionState();
}

class _RoleSectionState extends State<_RoleSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ids = widget.ids;
    final isDark = widget.isDark;
    final initialCount = _kInitialVisiblePerRole;
    final hasMore = ids.length > initialCount;
    final visibleIds = (_expanded || !hasMore)
        ? ids
        : ids.take(initialCount).toList();
    final hiddenCount = ids.length - initialCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: widget.color,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '(${widget.count})',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface.withAlpha(150),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...visibleIds.map(
              (userId) => _MemberChip(
                userId: userId,
                avatarSize: widget.avatarSize,
                isDark: isDark,
              ),
            ),
            if (hasMore && !_expanded)
              _ShowMoreChip(
                count: hiddenCount,
                color: widget.color,
                isDark: isDark,
                onTap: () => setState(() => _expanded = true),
              ),
            if (hasMore && _expanded)
              _ShowLessChip(
                color: widget.color,
                isDark: isDark,
                onTap: () => setState(() => _expanded = false),
              ),
          ],
        ),
      ],
    );
  }
}

class _ShowMoreChip extends StatelessWidget {
  final int count;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _ShowMoreChip({
    required this.count,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: color.withAlpha(isDark ? 120 : 180),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.expand_more_rounded, size: 18, color: color),
              const SizedBox(width: 4),
              Text(
                'Show $count more',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShowLessChip extends StatelessWidget {
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _ShowLessChip({
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: color.withAlpha(isDark ? 120 : 180),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.expand_less_rounded, size: 18, color: color),
              const SizedBox(width: 4),
              Text(
                'Show less',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberChip extends ConsumerWidget {
  final String userId;
  final double avatarSize;
  final bool isDark;

  const _MemberChip({
    required this.userId,
    required this.avatarSize,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(userProvider(userId));

    return userAsync.when(
      loading: () => _buildChip(
        context,
        avatar: SizedBox(
          width: avatarSize,
          height: avatarSize,
          child: Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        name: '…',
        theme: theme,
      ),
      error: (_, _) => _buildChip(
        context,
        avatar: UserAvatar(
          userId: userId,
          radius: avatarSize / 2,
          showProfileOnTap: true,
        ),
        name: 'Unknown',
        theme: theme,
      ),
      data: (user) => _buildChip(
        context,
        avatar: UserAvatar(
          userId: userId,
          radius: avatarSize / 2,
          showProfileOnTap: true,
        ),
        name: user?.name ?? user?.email ?? 'Unknown',
        theme: theme,
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required Widget avatar,
    required String name,
    required ThemeData theme,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => ProfilePage.showProfileDialog(context, userId),
        borderRadius: BorderRadius.circular(avatarSize / 2 + 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.onSurface.withAlpha(20)
                : AppColors.silver.withAlpha(200),
            borderRadius: BorderRadius.circular(avatarSize / 2 + 8),
            // border: Border.all(
            //   color: isDark
            //       ? theme.colorScheme.onSurface.withAlpha(40)
            //       : AppColors.silverDark.withAlpha(150),
            // ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              avatar,
              SizedBox(width: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 160),
                child: Text(
                  name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
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
}
