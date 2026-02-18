import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/providers/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays project steps in order, connected by a timeline.
/// Completed steps use a smaller footprint and are collapsible (tap to expand).
class ProjectStepsSection extends ConsumerStatefulWidget {
  final List<ProjectStepSchema> steps;
  final bool isMobile;

  const ProjectStepsSection({
    super.key,
    required this.steps,
    this.isMobile = true,
  });

  @override
  ConsumerState<ProjectStepsSection> createState() =>
      _ProjectStepsSectionState();
}

class _ProjectStepsSectionState extends ConsumerState<ProjectStepsSection> {
  /// Indices (in sorted list) of completed steps that are expanded.
  final Set<int> _expandedCompletedIndices = {};

  @override
  Widget build(BuildContext context) {
    if (widget.steps.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sorted = List<ProjectStepSchema>.from(widget.steps)
      ..sort((a, b) => a.order.compareTo(b.order));
    final completedCount = sorted.where((s) => s.completed).length;

    // Load statuses for status badge display
    final statusesAsync = ref.watch(statusesProvider);
    final statuses = statusesAsync.asData?.value ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.format_list_numbered_rounded,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Steps',
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
                '$completedCount / ${sorted.length}',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...sorted.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isLast = index == sorted.length - 1;
          final isCompact =
              step.completed && !_expandedCompletedIndices.contains(index);

          // Look up status by ID
          StatusSchema? status;
          if (step.statusId != null) {
            status = statuses.cast<StatusSchema?>().firstWhere(
              (s) => s?.id == step.statusId,
              orElse: () => null,
            );
          }

          return _StepTile(
            step: step,
            status: status,
            stepNumber: index + 1,
            isLast: isLast,
            isMobile: widget.isMobile,
            isDark: isDark,
            isCompact: isCompact,
            onToggleExpand: step.completed
                ? () => setState(() {
                    if (_expandedCompletedIndices.contains(index)) {
                      _expandedCompletedIndices.remove(index);
                    } else {
                      _expandedCompletedIndices.add(index);
                    }
                  })
                : null,
          );
        }),
      ],
    );
  }
}

class _StepTile extends StatelessWidget {
  final ProjectStepSchema step;
  final StatusSchema? status;
  final int stepNumber;
  final bool isLast;
  final bool isMobile;
  final bool isDark;
  final bool isCompact;
  final VoidCallback? onToggleExpand;

  const _StepTile({
    required this.step,
    this.status,
    required this.stepNumber,
    required this.isLast,
    required this.isMobile,
    required this.isDark,
    this.isCompact = false,
    this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = isCompact
        ? _buildCompactContent(theme)
        : _buildFullContent(theme);

    final body = onToggleExpand != null && isCompact
        ? Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggleExpand,
              borderRadius: BorderRadius.circular(8),
              child: content,
            ),
          )
        : content;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: step.completed
                      ? AppColors.successGreen.withAlpha(isDark ? 60 : 50)
                      : theme.colorScheme.primary.withAlpha(isDark ? 50 : 35),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: step.completed
                        ? AppColors.successGreen
                        : theme.colorScheme.primary.withAlpha(180),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: step.completed
                    ? Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: AppColors.successGreen,
                      )
                    : Text(
                        '$stepNumber',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withAlpha(80),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: body,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactContent(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              step.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.lineThrough,
                color: theme.colorScheme.onSurface.withAlpha(150),
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.expand_more_rounded,
            size: 20,
            color: theme.colorScheme.onSurface.withAlpha(120),
          ),
        ],
      ),
    );
  }

  Widget _buildFullContent(ThemeData theme) {
    final hasExpandToggle = step.completed && onToggleExpand != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                step.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  decoration: step.completed
                      ? TextDecoration.lineThrough
                      : null,
                  color: step.completed
                      ? theme.colorScheme.onSurface.withAlpha(150)
                      : theme.colorScheme.onSurface,
                ),
                maxLines: null,
                overflow: TextOverflow.visible,
              ),
            ),
            if (status != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(
                    status!.name,
                    theme,
                  ).withAlpha(isDark ? 50 : 35),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status!.name.value,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _statusColor(status!.name, theme),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
            if (hasExpandToggle) ...[
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.expand_less_rounded, size: 20),
                onPressed: onToggleExpand,
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(28, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ],
        ),
        if (step.description != null && step.description!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            step.description!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(180),
              height: 1.4,
            ),
            maxLines: null,
            overflow: TextOverflow.visible,
          ),
        ],
      ],
    );
  }

  static Color _statusColor(StatusValuesEnum statusName, ThemeData theme) =>
      stepStatusColor(statusName.value, theme);
}
