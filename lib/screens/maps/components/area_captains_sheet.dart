import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/models/map_area.dart';
import 'package:collective_action_frontend/providers/hotspot_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/user_service.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:collective_action_frontend/utils/map_area_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// Sheet listing map areas and their captains (multiple per area).
class AreaCaptainsSheet extends ConsumerWidget {
  const AreaCaptainsSheet({
    super.key,
    required this.campaignId,
  });

  final String campaignId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areasAsync = ref.watch(mapAreasForCampaignProvider(campaignId));
    final captainsAsync = ref.watch(areaCaptainsForCampaignProvider(campaignId));
    final currentUser = ref.watch(currentUserProvider).value;
    final isAdmin = UserService.isAdmin(currentUser);

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return PointerInterceptor(
          child: Material(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.military_tech_outlined),
                      const SizedBox(width: 8),
                      Text(
                        'Area Captains',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: areasAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error: $e')),
                    data: (areas) {
                      final captains = captainsAsync.value ?? const [];
                      final grouped = groupCaptainsByAreaId(captains);
                      final sorted = [...areas]..sort((a, b) => a.name.compareTo(b.name));

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: sorted.length,
                        padding: const EdgeInsets.only(bottom: 24),
                        itemBuilder: (context, index) {
                          final area = sorted[index];
                          final areaCaptains = grouped[area.id] ?? const [];
                          final isCaptain = isCaptainOfArea(
                            captains,
                            currentUser?.id,
                            area.id,
                          );
                          final canAddCaptain = isAdmin || isCaptain;

                          return _AreaCaptainTile(
                            area: area,
                            assignments: areaCaptains,
                            currentUserId: currentUser?.id,
                            isAdmin: isAdmin,
                            canAddCaptain: canAddCaptain,
                            onAddCaptain: !canAddCaptain || currentUser == null
                                ? null
                                : () => _promptAndAssignCaptain(
                                      context,
                                      ref,
                                      area,
                                      currentUser,
                                    ),
                            onRemove: (assignment) => _removeCaptain(
                              context,
                              ref,
                              assignment,
                              currentUser,
                              isAdmin,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _assignCaptain(
    BuildContext context,
    WidgetRef ref,
    MapAreaModel area,
    String captainUserId,
    String actingUserId,
  ) async {
    try {
      await ref.read(hotspotServiceProvider).assignCaptain(
            mapAreaId: area.id,
            captainUserId: captainUserId,
            actingUserId: actingUserId,
          );
      ref.invalidate(areaCaptainsForCampaignProvider(campaignId));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.success('Captain added for ${area.name}'),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.error('Failed to assign captain: $e'),
        );
      }
    }
  }

  Future<void> _promptAndAssignCaptain(
    BuildContext context,
    WidgetRef ref,
    MapAreaModel area,
    UserSchema actingUser,
  ) async {
    final newId = await showDialog<String>(
      context: context,
      builder: (c) => _CaptainUserIdDialog(
        title: 'Add Captain for ${area.name}',
        confirmLabel: 'Add',
      ),
    );
    if (newId == null || !context.mounted) return;
    await _assignCaptain(context, ref, area, newId, actingUser.id!);
  }

  Future<void> _removeCaptain(
    BuildContext context,
    WidgetRef ref,
    AreaCaptainModel assignment,
    UserSchema? currentUser,
    bool isAdmin,
  ) async {
    if (currentUser?.id == null) return;
    try {
      await ref.read(hotspotServiceProvider).removeCaptain(
            assignmentId: assignment.id,
            actingUserId: currentUser!.id!,
          );
      ref.invalidate(areaCaptainsForCampaignProvider(campaignId));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.success('Captain removed'),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.error('Failed to remove captain: $e'),
        );
      }
    }
  }
}

class _AreaCaptainTile extends StatelessWidget {
  const _AreaCaptainTile({
    required this.area,
    required this.assignments,
    required this.currentUserId,
    required this.isAdmin,
    required this.canAddCaptain,
    required this.onRemove,
    this.onAddCaptain,
  });

  final MapAreaModel area;
  final List<AreaCaptainModel> assignments;
  final String? currentUserId;
  final bool isAdmin;
  final bool canAddCaptain;
  final VoidCallback? onAddCaptain;
  final void Function(AreaCaptainModel assignment) onRemove;

  @override
  Widget build(BuildContext context) {
    final isCaptain = assignments.any((a) => a.captainUserId == currentUserId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: isCaptain
                      ? const Color(0xFFFF6D00)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    isCaptain ? Icons.military_tech : Icons.location_city,
                    color: isCaptain ? Colors.white : null,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(areaDisplayName(area), style: Theme.of(context).textTheme.titleSmall),
                      Text(
                        areaTypeLabel(area),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (canAddCaptain && onAddCaptain != null)
                  TextButton(onPressed: onAddCaptain, child: const Text('Add')),
              ],
            ),
            if (assignments.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  'No captains assigned',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
              )
            else
              ...assignments.map(
                (assignment) => _CaptainRow(
                  assignment: assignment,
                  canRemove: isAdmin ||
                      assignment.captainUserId == currentUserId ||
                      isCaptain,
                  onRemove: () => onRemove(assignment),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CaptainRow extends StatelessWidget {
  const _CaptainRow({
    required this.assignment,
    required this.canRemove,
    required this.onRemove,
  });

  final AreaCaptainModel assignment;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserSchema?>(
      future: UserService().fetchUserByUserID(userId: assignment.captainUserId),
      builder: (context, snapshot) {
        final name = snapshot.data?.name ??
            snapshot.data?.email ??
            assignment.captainUserId;

        return Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              UserAvatar(
                userId: assignment.captainUserId,
                radius: 14,
                showProfileOnTap: true,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(name, style: Theme.of(context).textTheme.bodyMedium)),
              if (canRemove)
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  tooltip: 'Remove captain',
                  onPressed: onRemove,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CaptainUserIdDialog extends StatefulWidget {
  const _CaptainUserIdDialog({
    required this.title,
    this.confirmLabel = 'Confirm',
  });

  final String title;
  final String confirmLabel;

  @override
  State<_CaptainUserIdDialog> createState() => _CaptainUserIdDialogState();
}

class _CaptainUserIdDialogState extends State<_CaptainUserIdDialog> {
  final _controller = TextEditingController();
  String? _lookedUpName;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _lookup() async {
    final id = _controller.text.trim();
    if (id.isEmpty) return;
    try {
      final user = await UserService().fetchUserByUserID(userId: id);
      if (mounted) {
        setState(() => _lookedUpName = user?.name ?? user?.email ?? 'Not found');
      }
    } catch (_) {
      if (mounted) setState(() => _lookedUpName = 'User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Captain user ID',
            ),
          ),
          if (_lookedUpName != null) ...[
            const SizedBox(height: 8),
            Text(_lookedUpName!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(onPressed: _lookup, child: const Text('Look up')),
        FilledButton(
          onPressed: () {
            final id = _controller.text.trim();
            if (id.isNotEmpty) Navigator.pop(context, id);
          },
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}
