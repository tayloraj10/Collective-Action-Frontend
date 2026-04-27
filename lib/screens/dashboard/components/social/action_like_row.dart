import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/actions_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Like / unlike control for a feed action.
class ActionLikeRow extends ConsumerStatefulWidget {
  final ActionSchema action;
  final bool isMobile;
  final Color? iconColor;

  const ActionLikeRow({
    super.key,
    required this.action,
    required this.isMobile,
    this.iconColor,
  });

  @override
  ConsumerState<ActionLikeRow> createState() => _ActionLikeRowState();
}

class _ActionLikeRowState extends ConsumerState<ActionLikeRow> {
  bool _busy = false;
  late bool _likedByMe;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _likedByMe = widget.action.likedByMe;
    _likeCount = widget.action.likeCount;
  }

  @override
  void didUpdateWidget(covariant ActionLikeRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.action.id != widget.action.id) {
      _likedByMe = widget.action.likedByMe;
      _likeCount = widget.action.likeCount;
    }
  }

  Future<void> _toggle() async {
    final user = ref.read(currentUserProvider).value;
    if (user?.id == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar.info('Sign in to like actions'));
      return;
    }
    if (_busy) return;
    setState(() => _busy = true);
    final uid = user!.id!;
    final previousLiked = _likedByMe;
    final previousCount = _likeCount;
    setState(() {
      _likedByMe = !_likedByMe;
      _likeCount = _likedByMe ? _likeCount + 1 : (_likeCount > 0 ? _likeCount - 1 : 0);
    });
    try {
      final updated = _likedByMe
          ? await ActionsService().addActionLike(widget.action.id, uid)
          : await ActionsService().removeActionLike(widget.action.id, uid);
      if (updated != null && mounted) {
        setState(() {
          _likedByMe = updated.likedByMe;
          _likeCount = updated.likeCount;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _likedByMe = previousLiked;
          _likeCount = previousCount;
        });
      }
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar.error("Couldn't update like"));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.iconColor ?? theme.colorScheme.primary;
    final size = widget.isMobile ? 16.0 : 17.0;
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _busy ? null : _toggle,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _busy
                      ? SizedBox(
                          width: size,
                          height: size,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: color,
                          ),
                        )
                      : Icon(
                          _likedByMe
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: size,
                          color: _likedByMe
                              ? Colors.pinkAccent
                              : color.withAlpha(200),
                        ),
                  const SizedBox(width: 3),
                  Text(
                    '$_likeCount',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(180),
                      fontSize: widget.isMobile ? 10 : 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
