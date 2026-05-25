import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/providers/hotspot_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:collective_action_frontend/services/hotspot_service.dart';
import 'package:collective_action_frontend/services/user_service.dart';
import 'package:collective_action_frontend/utils/map_area_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

const _hotspotAccent = Color(0xFFFF6D00);

/// View and manage a cleanup hotspot (edit, deactivate, manage captains).
class HotspotInfoDialog extends ConsumerStatefulWidget {
  const HotspotInfoDialog({
    super.key,
    required this.hotspot,
    required this.campaignId,
    required this.captains,
  });

  final MapHotspotSchema hotspot;
  final String campaignId;
  final List<AreaCaptainSchema> captains;

  @override
  ConsumerState<HotspotInfoDialog> createState() => _HotspotInfoDialogState();
}

class _HotspotInfoDialogState extends ConsumerState<HotspotInfoDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.hotspot.title);
    _descriptionController = TextEditingController(
      text: widget.hotspot.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _canManage {
    final user = ref.read(currentUserProvider).value;
    return canManageAreaHotspots(
      isAdmin: UserService.isAdmin(user),
      captains: widget.captains,
      userId: user?.id,
      mapAreaId: widget.hotspot.mapAreaId,
    );
  }

  bool get _isCurrentCaptain {
    final user = ref.read(currentUserProvider).value;
    return isCaptainOfArea(widget.captains, user?.id, widget.hotspot.mapAreaId);
  }

  List<AreaCaptainSchema> get _areaCaptains {
    final list = captainsForArea(widget.captains, widget.hotspot.mapAreaId);
    return [...list]..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  AreaCaptainSchema? get _mainCaptainAssignment =>
      _areaCaptains.isEmpty ? null : _areaCaptains.first;

  bool get _canManageCaptains {
    final user = ref.read(currentUserProvider).value;
    return UserService.isAdmin(user) || _isCurrentCaptain;
  }

  Future<void> _save() async {
    final user = ref.read(currentUserProvider).value;
    if (user?.id == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(hotspotServiceProvider).updateHotspot(
            hotspotId: widget.hotspot.id,
            actingUserId: user!.id!,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
          );
      if (mounted) {
        ref.invalidate(mapHotspotsForCampaignProvider(widget.campaignId));
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.error('Failed to update hotspot: $e'),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _deactivate() async {
    final user = ref.read(currentUserProvider).value;
    if (user?.id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Remove hotspot?'),
        content: const Text(
          'This hotspot will be hidden from the map. You can add a new one later.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Remove')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _saving = true);
    try {
      await ref.read(hotspotServiceProvider).deleteHotspot(
            hotspotId: widget.hotspot.id,
            actingUserId: user!.id!,
          );
      if (mounted) {
        ref.invalidate(mapHotspotsForCampaignProvider(widget.campaignId));
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.error('Failed to remove hotspot: $e'),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _addCaptain() async {
    final user = ref.read(currentUserProvider).value;
    if (user?.id == null) return;

    final newCaptainId = await showDialog<String>(
      context: context,
      builder: (c) => _CaptainUserIdDialog(areaName: hotspotAreaName(widget.hotspot)),
    );
    if (newCaptainId == null || !mounted) return;

    setState(() => _saving = true);
    try {
      await ref.read(hotspotServiceProvider).assignCaptain(
            mapAreaId: widget.hotspot.mapAreaId,
            captainUserId: newCaptainId,
            actingUserId: user!.id!,
          );
      if (mounted) {
        ref.invalidate(areaCaptainsForCampaignProvider(widget.campaignId));
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.success('Captain added for ${hotspotAreaName(widget.hotspot)}'),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.error('Failed to add captain: $e'),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _removeCaptain(AreaCaptainSchema assignment) async {
    final user = ref.read(currentUserProvider).value;
    if (user?.id == null) return;

    setState(() => _saving = true);
    try {
      await ref.read(hotspotServiceProvider).removeCaptain(
            assignmentId: assignment.id,
            actingUserId: user!.id!,
          );
      if (mounted) {
        ref.invalidate(areaCaptainsForCampaignProvider(widget.campaignId));
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.success('Captain removed'),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.error('Failed to remove captain: $e'),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final area = widget.hotspot.area;
    final currentUser = ref.read(currentUserProvider).value;
    final currentUserId = currentUser?.id;
    final mainCaptainId = _mainCaptainAssignment?.id;
    final description = widget.hotspot.description?.trim();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceVariant = isDark
        ? theme.colorScheme.surfaceContainerHighest
        : theme.colorScheme.surfaceContainerLow;
    final size = MediaQuery.sizeOf(context);
    final maxW = (size.width * 0.95).clamp(320.0, 420.0);
    final maxH = (size.height * 0.78).clamp(320.0, 560.0);
    final areaLabel = area != null
        ? '${areaDisplayName(area)} (${areaTypeLabel(area)})'
        : hotspotAreaName(widget.hotspot);

    return Dialog(
      elevation: 8,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: PointerInterceptor(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxW,
            maxHeight: maxH,
            minWidth: 320,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Material(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _HotspotHeader(title: widget.hotspot.title),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _MetaChip(
                                icon: Icons.location_city_outlined,
                                label: areaLabel,
                                accentColor: _hotspotAccent,
                              ),
                              _MetaChip(
                                icon: Icons.radio_button_unchecked,
                                label: hotspotRadiusDescription,
                                accentColor: _hotspotAccent,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _SectionCard(
                            surfaceVariant: surfaceVariant,
                            accentColor: _hotspotAccent,
                            icon: Icons.groups_outlined,
                            title: 'Captains',
                            trailing: _canManageCaptains
                                ? TextButton.icon(
                                    onPressed: _saving ? null : _addCaptain,
                                    icon: const Icon(Icons.person_add_outlined, size: 18),
                                    label: const Text('Add co-captain'),
                                  )
                                : null,
                            children: [
                              if (_areaCaptains.isEmpty)
                                Text(
                                  'No captains assigned',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.65),
                                  ),
                                )
                              else
                                ..._areaCaptains.map(
                                  (assignment) => _CaptainRow(
                                    assignment: assignment,
                                    isMainCaptain: assignment.id == mainCaptainId,
                                    canRemove: assignment.id != mainCaptainId &&
                                        (UserService.isAdmin(currentUser) ||
                                            assignment.captainUserId ==
                                                currentUserId ||
                                            _isCurrentCaptain),
                                    onRemove: () => _removeCaptain(assignment),
                                  ),
                                ),
                            ],
                          ),
                          if (_canManage) ...[
                            const SizedBox(height: 14),
                            _SectionCard(
                              surfaceVariant: surfaceVariant,
                              accentColor: _hotspotAccent,
                              icon: Icons.edit_outlined,
                              title: 'Edit hotspot',
                              children: [
                                TextField(
                                  controller: _titleController,
                                  decoration: const InputDecoration(
                                    labelText: 'Hotspot name',
                                    isDense: true,
                                  ),
                                  textCapitalization: TextCapitalization.sentences,
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(
                                    labelText: 'Details (optional)',
                                    isDense: true,
                                  ),
                                  maxLines: 3,
                                  textCapitalization: TextCapitalization.sentences,
                                ),
                              ],
                            ),
                          ] else if (description != null && description.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            _SectionCard(
                              surfaceVariant: surfaceVariant,
                              accentColor: _hotspotAccent,
                              icon: Icons.notes_outlined,
                              title: 'Details',
                              children: [
                                Text(
                                  description,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  _HotspotFooter(
                    saving: _saving,
                    canManage: _canManage,
                    onRemove: _deactivate,
                    onClose: () => Navigator.of(context).pop(false),
                    onSave: _save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HotspotHeader extends StatelessWidget {
  const _HotspotHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _hotspotAccent,
            Color(0xFFE65100),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HotspotFooter extends StatelessWidget {
  const _HotspotFooter({
    required this.saving,
    required this.canManage,
    required this.onRemove,
    required this.onClose,
    required this.onSave,
  });

  final bool saving;
  final bool canManage;
  final VoidCallback onRemove;
  final VoidCallback onClose;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 10,
        runSpacing: 8,
        children: [
          if (canManage)
            OutlinedButton.icon(
              onPressed: saving ? null : onRemove,
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Remove'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error),
              ),
            ),
          TextButton(onPressed: saving ? null : onClose, child: const Text('Close')),
          if (canManage)
            FilledButton.icon(
              onPressed: saving ? null : onSave,
              icon: saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined, size: 18),
              label: const Text('Save'),
              style: FilledButton.styleFrom(
                backgroundColor: _hotspotAccent,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: accentColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.surfaceVariant,
    required this.accentColor,
    required this.icon,
    required this.title,
    required this.children,
    this.trailing,
  });

  final Color surfaceVariant;
  final Color accentColor;
  final IconData icon;
  final String title;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceVariant.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _CaptainRow extends ConsumerWidget {
  const _CaptainRow({
    required this.assignment,
    required this.isMainCaptain,
    required this.canRemove,
    required this.onRemove,
  });

  final AreaCaptainSchema assignment;
  final bool isMainCaptain;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(userProvider(assignment.captainUserId));
    final name = userAsync.whenOrNull(
          data: (user) => user?.name ?? user?.email,
        ) ??
        assignment.captainUserId;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(10),
        border: isMainCaptain
            ? Border.all(color: _hotspotAccent.withValues(alpha: 0.45))
            : Border.all(color: theme.dividerColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          UserAvatar(
            userId: assignment.captainUserId,
            radius: 18,
            accentColorOverride: isMainCaptain ? _hotspotAccent : AppColors.lightBlue,
            showProfileOnTap: true,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isMainCaptain)
                  Text(
                    'Main captain',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _hotspotAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          if (isMainCaptain)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _hotspotAccent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.military_tech,
                size: 16,
                color: _hotspotAccent,
              ),
            ),
          if (canRemove)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              tooltip: 'Remove co-captain',
              visualDensity: VisualDensity.compact,
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}

class _CaptainUserIdDialog extends StatefulWidget {
  const _CaptainUserIdDialog({required this.areaName});

  final String areaName;

  @override
  State<_CaptainUserIdDialog> createState() => _CaptainUserIdDialogState();
}

class _CaptainUserIdDialogState extends State<_CaptainUserIdDialog> {
  final _userIdController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Co-Captain for ${widget.areaName}'),
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter the user ID of the co-captain to add.'),
            const SizedBox(height: 12),
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'User ID',
                hintText: 'Paste user UUID',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final id = _userIdController.text.trim();
            if (id.isNotEmpty) Navigator.pop(context, id);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
