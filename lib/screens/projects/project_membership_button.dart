import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/providers/project_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A button that allows the current user to join or leave a project.
/// Shows "Join Project" if not a member, "Leave Project" if already a member.
class ProjectMembershipButton extends ConsumerStatefulWidget {
  final ProjectSchema project;
  final bool isMobile;

  const ProjectMembershipButton({
    super.key,
    required this.project,
    this.isMobile = true,
  });

  @override
  ConsumerState<ProjectMembershipButton> createState() =>
      _ProjectMembershipButtonState();
}

class _ProjectMembershipButtonState
    extends ConsumerState<ProjectMembershipButton> {
  bool _isLoading = false;

  bool _isUserMember(String? userId) {
    if (userId == null) return false;
    final members = widget.project.members;
    if (members == null) return false;

    return members.owners.contains(userId) ||
        members.developers.contains(userId) ||
        members.members.contains(userId);
  }

  Future<void> _handleToggleMembership() async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null || currentUser.id == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to join a project'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final service = ref.read(projectsServiceProvider);
      final userId = currentUser.id!;
      final isMember = _isUserMember(userId);

      if (isMember) {
        // Remove user from project
        await service.removeMemberFromProject(
          widget.project.id,
          userId,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have left the project'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      } else {
        // Add user to project as a member
        await service.addMemberToProject(
          widget.project.id,
          AddProjectMemberSchema(
            userId: userId,
            role: AddProjectMemberSchemaRoleEnum.members,
          ),
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have joined the project'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }

      // Refresh the project data
      ref.invalidate(projectByIdProvider(widget.project.id));
      ref.invalidate(activeProjectsProvider);
      ref.invalidate(projectsByCreatorProvider);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update membership: $e'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentUser = ref.watch(currentUserProvider).value;
    final isLoggedIn = currentUser != null && currentUser.id != null;
    final isMember = _isUserMember(currentUser?.id);

    // If not logged in, show a disabled button with a tooltip
    if (!isLoggedIn) {
      return Tooltip(
        message: 'You must be logged in to join a project',
        child: FilledButton.icon(
          onPressed: null, // Disabled
          icon: Icon(
            Icons.group_add_rounded,
            size: widget.isMobile ? 18 : 20,
          ),
          label: Text(
            'Join Project',
            style: TextStyle(
              fontSize: widget.isMobile ? 13 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: FilledButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isMobile ? 16 : 20,
              vertical: widget.isMobile ? 10 : 12,
            ),
          ),
        ),
      );
    }

    return FilledButton.icon(
      onPressed: _isLoading ? null : _handleToggleMembership,
      icon: _isLoading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onPrimary,
              ),
            )
          : Icon(
              isMember ? Icons.exit_to_app_rounded : Icons.group_add_rounded,
              size: widget.isMobile ? 18 : 20,
            ),
      label: Text(
        isMember ? 'Leave Project' : 'Join Project',
        style: TextStyle(
          fontSize: widget.isMobile ? 13 : 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: isMember
            ? (isDark ? Colors.red.shade700 : Colors.red.shade600)
            : (isDark ? AppColors.lightBlue : theme.colorScheme.primary),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: widget.isMobile ? 16 : 20,
          vertical: widget.isMobile ? 10 : 12,
        ),
      ),
    );
  }
}
