import 'package:collective_action_frontend/app/constants.dart';
import 'package:flutter/material.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';

// https://lh3.googleusercontent.com/a/ACg8ocIV2QeitcIYoPelMu0S8akx0uu-xt6UDExyBx38cnc2533VJ5JpQA=s96-c
// https://i.guim.co.uk/img/media/59c4e3f794184fec5ce5b56d2d856a9808fef52f/0_37_1600_960/master/1600.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=0c09500c89482620a8c98f4cf2ed8eb1

/// Accepts either a UserSchema (backend user) or a FirebaseUser (for fallback)
/// If both are null, shows generic avatar icon.
class UserAvatar extends ConsumerWidget {
  final String? userId;
  final double? radius;
  final bool? isMobileOverride;
  final double? borderWidth;
  final Color? accentColorOverride;
  final Color? cardColorOverride;
  final bool showTooltip;
  final bool enableHero;

  const UserAvatar({
    super.key,
    required this.userId,
    this.radius,
    this.isMobileOverride,
    this.borderWidth,
    this.accentColorOverride,
    this.cardColorOverride,
    this.showTooltip = false,
    this.enableHero = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = isMobileOverride ?? AppConstants.isMobile(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor =
        cardColorOverride ?? (isDark ? AppColors.darkSurface : AppColors.white);
    final accentColor = accentColorOverride ?? AppColors.lightBlue;

    if (userId == null) {
      // No userId, show question mark avatar
      Widget avatar = _questionMarkAvatar(
        accentColor,
        radius,
        isMobile,
        context,
      );
      if (showTooltip) {
        avatar = Tooltip(message: 'Anonymous', child: avatar);
      }
      return avatar;
    }

    final userAsync = ref.watch(databaseUserProvider(userId!));
    return userAsync.when(
      loading: () {
        Widget avatar = _avatarContainer(
          cardColor,
          accentColor,
          isMobile,
          radius: radius,
          isLoading: true,
        );
        if (showTooltip) {
          avatar = Tooltip(message: 'Anonymous', child: avatar);
        }
        return avatar;
      },
      error: (err, stack) {
        debugPrint('[UserAvatar] Error fetching user for userId=$userId: $err');
        Widget avatar = _questionMarkAvatar(
          accentColor,
          radius,
          isMobile,
          context,
        );
        if (showTooltip) {
          avatar = Tooltip(message: 'Anonymous', child: avatar);
        }
        return avatar;
      },
      data: (user) {
        final double avatarRadius = radius ?? (isMobile ? 14 : 16);
        // User does not exist
        if (user == null) {
          Widget avatar = _questionMarkAvatar(
            accentColor,
            radius,
            isMobile,
            context,
          );
          if (showTooltip) {
            avatar = Tooltip(message: 'Anonymous', child: avatar);
          }
          return avatar;
        }
        final hasName = user.name != null && user.name!.trim().isNotEmpty;
        final hasPhoto = user.photoUrl != null && user.photoUrl!.isNotEmpty;
        final firstLetter = hasName ? user.name!.trim()[0].toUpperCase() : null;
        // Case 1: user has photo and name
        if (hasPhoto && hasName) {
          Widget avatar = _avatarContainer(
            cardColor,
            accentColor,
            isMobile,
            radius: radius,
            photoUrl: user.photoUrl,
          );
          if (enableHero) {
            avatar = Hero(
              tag: 'user-avatar-$userId',
              child: SizedBox(
                width: avatarRadius * 2,
                height: avatarRadius * 2,
                child: avatar,
              ),
            );
            avatar = GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: const EdgeInsets.all(16),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                        Hero(
                          tag: 'user-avatar-$userId',
                          child: SizedBox(
                            width: 180,
                            height: 180,
                            child: ClipOval(
                              child: Image.network(
                                user.photoUrl!,
                                fit: BoxFit.cover,
                                width: 180,
                                height: 180,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: cardColor,
                                      width: 180,
                                      height: 180,
                                      child: Icon(
                                        Icons.error_outline,
                                        color: accentColor,
                                        size: 60,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: avatar,
            );
          }
          if (showTooltip) {
            avatar = Tooltip(message: user.name!, child: avatar);
          }
          return avatar;
        }
        // Case 2: user has photo and no name
        if (hasPhoto && !hasName) {
          Widget avatar = _avatarContainer(
            cardColor,
            accentColor,
            isMobile,
            radius: radius,
            photoUrl: user.photoUrl,
          );
          if (enableHero) {
            avatar = Hero(
              tag: 'user-avatar-$userId',
              child: SizedBox(
                width: avatarRadius * 2,
                height: avatarRadius * 2,
                child: avatar,
              ),
            );
            avatar = GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: const EdgeInsets.all(16),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                        Hero(
                          tag: 'user-avatar-$userId',
                          child: SizedBox(
                            width: 180,
                            height: 180,
                            child: ClipOval(
                              child: Image.network(
                                user.photoUrl!,
                                fit: BoxFit.cover,
                                width: 180,
                                height: 180,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: cardColor,
                                      width: 180,
                                      height: 180,
                                      child: Icon(
                                        Icons.error_outline,
                                        color: accentColor,
                                        size: 60,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: avatar,
            );
          }
          if (showTooltip) {
            avatar = Tooltip(message: 'Name Unknown', child: avatar);
          }
          return avatar;
        }
        // Case 3: user has no photo but has name
        if (!hasPhoto && hasName) {
          Widget avatar = Container(
            width: avatarRadius * 2,
            height: avatarRadius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cardColor, // uses correct dark/light color
              border: Border.all(color: accentColor, width: borderWidth ?? 1),
            ),
            alignment: Alignment.center,
            child: Text(
              firstLetter!,
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: avatarRadius * 1.15,
              ),
            ),
          );
          if (showTooltip) {
            avatar = Tooltip(message: user.name!, child: avatar);
          }
          return avatar;
        }
        // Case 4: user has no photo and no name
        if (!hasPhoto && !hasName) {
          Widget avatar = _avatarContainer(
            cardColor,
            accentColor,
            isMobile,
            radius: radius,
          );
          if (showTooltip) {
            avatar = Tooltip(message: 'Name Unknown', child: avatar);
          }
          return avatar;
        }
        // Fallback (should not hit)
        Widget avatar = _questionMarkAvatar(
          accentColor,
          radius,
          isMobile,
          context,
        );
        if (showTooltip) {
          avatar = Tooltip(message: 'Anonymous', child: avatar);
        }
        return avatar;
      },
    );
  }

  Widget _avatarContainer(
    Color cardColor,
    Color accentColor,
    bool isMobile, {
    double? radius,
    String? photoUrl,
    bool isLoading = false,
    bool isError = false,
  }) {
    final double avatarRadius = radius ?? (isMobile ? 14 : 16);
    return Container(
      width: avatarRadius * 2,
      height: avatarRadius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: cardColor,
        border: Border.all(color: accentColor, width: borderWidth ?? 1),
      ),
      alignment: Alignment.center,
      child: isLoading
          ? SizedBox(
              width: avatarRadius * 1.2,
              height: avatarRadius * 1.2,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : isError
          ? Icon(
              Icons.error_outline,
              color: accentColor,
              size: avatarRadius * 1.15,
            )
          : (photoUrl == null || photoUrl.isEmpty)
          ? Icon(
              Icons.person_rounded,
              color: accentColor,
              size: avatarRadius * 1.15,
            )
          : CircleAvatar(
              radius: avatarRadius,
              backgroundColor: cardColor,
              backgroundImage: NetworkImage(photoUrl),
            ),
    );
  }

  Widget _questionMarkAvatar(
    Color accentColor,
    double? radius,
    bool isMobile, [
    BuildContext? context,
  ]) {
    final double avatarRadius = radius ?? (isMobile ? 14 : 16);
    // Use theme from context if available
    Color bgColor = AppColors.white;
    if (context != null) {
      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;
      bgColor = isDark ? AppColors.darkSurface : AppColors.white;
    }
    return Container(
      width: avatarRadius * 2,
      height: avatarRadius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: Border.all(color: accentColor, width: borderWidth ?? 1),
      ),
      alignment: Alignment.center,
      child: Text(
        '?',
        style: TextStyle(
          color: accentColor,
          fontWeight: FontWeight.bold,
          fontSize: avatarRadius * 1.15,
        ),
      ),
    );
  }
}
