import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:collective_action_frontend/components/app_bar_icon_button.dart';
import 'package:collective_action_frontend/components/confirmation_dialog.dart';
import 'package:collective_action_frontend/components/quote_bar.dart';
import 'package:collective_action_frontend/providers/auth_provider.dart';
import 'package:collective_action_frontend/providers/sound_provider.dart';
import 'package:collective_action_frontend/providers/theme_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final authState = ref.watch(authStateProvider);
    final isMobile = AppConstants.isMobile(context);
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final isHomeRoute = currentLocation == '/';

    final user = ref.watch(currentUserProvider).value;

    return AppBar(
      elevation: 3,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.darkBlue, AppColors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      centerTitle: isMobile ? false : true,
      leadingWidth: !isHomeRoute ? 66 : null,
      leading: !isHomeRoute
          ? Padding(
              padding: const EdgeInsets.only(left: 12),
              child: AppBarIconButton(
                icon: Icons.home,
                onPressed: () => safeGo(context, '/'),
                tooltip: 'Home',
                backgroundColor: Colors.white.withAlpha(38),
              ),
            )
          : null,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 8),
        child: Column(
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isMobile ? 'Collective' : 'Collective Action Network',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: isMobile ? 0 : 0.5,
                fontSize: isMobile ? 18 : null,
              ),
            ),
            // Quote below title
            if (!isMobile || isHomeRoute) const QuoteBar(),
          ],
        ),
      ),
      actions: [
        // Dashboard (home) on mobile: section links live in the app bar so the body
        // nav strip does not consume vertical space.
        if (isMobile && isHomeRoute)
          PopupMenuButton<String>(
            tooltip: 'Go to section',
            offset: const Offset(0, kToolbarHeight - 4),
            onSelected: (route) => safeGo(context, route),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: '/initiatives',
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: AppColors.lightBlue,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    const Text('Initiatives'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: '/maps/cleanup',
                child: Row(
                  children: [
                    Icon(
                      Icons.map_outlined,
                      color: AppColors.successGreen,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    const Text('Maps'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: '/network',
                child: Row(
                  children: [
                    Icon(
                      Icons.dynamic_feed_outlined,
                      color: AppColors.errorRed,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    const Text('Community'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: '/social',
                child: Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      color: AppColors.warningOrange,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    const Text('Actions'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: '/network',
                child: Row(
                  children: [
                    Icon(
                      Icons.hub_outlined,
                      color: AppColors.statusInReview,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    const Text('Network'),
                  ],
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Icon(Icons.apps_outlined),
            ),
          ),

        // Info Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              tooltip: 'App Info',
              onPressed: () async {
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
                final overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;
                final position = RelativeRect.fromRect(
                  Rect.fromPoints(
                    button.localToGlobal(Offset.zero, ancestor: overlay),
                    button.localToGlobal(
                      button.size.bottomRight(Offset.zero),
                      ancestor: overlay,
                    ),
                  ),
                  Offset.zero & overlay.size,
                );
                await showMenu(
                  context: context,
                  position: position,
                  items: [
                    PopupMenuItem(
                      enabled: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Support',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SelectableText(
                            'support@collectiveaction.us',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.primary,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Version',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          _VersionText(),
                          const SizedBox(height: 8),
                          Text(
                            'Recent Features',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.successGreen,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '- Initial Release!',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.successGreen.withAlpha(179),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Upcoming Features',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.warningOrange,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '• Self Improvement Paths\n• Events\n• More Maps',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.warningOrange.withAlpha(179),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        // Settings menu (theme + sound) — opens next to button like app info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.settings_rounded),
              tooltip: 'Settings',
              onPressed: () async {
                final RenderBox? button =
                    context.findRenderObject() as RenderBox?;
                if (button == null || !button.hasSize) return;
                final overlayState = Overlay.of(context);
                final RenderBox? overlayBox =
                    overlayState.context.findRenderObject() as RenderBox?;
                if (overlayBox == null || !overlayBox.hasSize) return;
                // Button position in global coordinates
                final buttonBottomRight = button.localToGlobal(
                  button.size.bottomRight(Offset.zero),
                );
                // Overlay position in global coordinates (usually 0,0)
                final overlayTopLeft = overlayBox.localToGlobal(Offset.zero);
                // Align menu's right edge with button's right edge
                final buttonRightInOverlay =
                    buttonBottomRight.dx - overlayTopLeft.dx;
                final menuRight = overlayBox.size.width - buttonRightInOverlay;
                final menuTop = buttonBottomRight.dy - overlayTopLeft.dy + 4;
                late OverlayEntry entry;
                entry = OverlayEntry(
                  builder: (overlayContext) => SizedBox.expand(
                    child: Stack(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => entry.remove(),
                        ),
                        Positioned(
                          right: menuRight,
                          top: menuTop,
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(8),
                            child: GestureDetector(
                              onTap:
                                  () {}, // absorb tap so barrier doesn't close
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: IntrinsicWidth(
                                  child: Consumer(
                                    builder: (context, ref, _) {
                                      final theme = Theme.of(context);
                                      final isDarkMode =
                                          ref.watch(themeProvider) ==
                                          ThemeMode.dark;
                                      final soundEnabled = ref.watch(
                                        soundEnabledProvider,
                                      );
                                      final isLoggedIn =
                                          ref.watch(authStateProvider).value !=
                                          null;
                                      final menuTextStyle = theme
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface,
                                            fontWeight: FontWeight.w500,
                                          );
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 85,
                                                child: Text(
                                                  isDarkMode
                                                      ? 'Dark Mode'
                                                      : 'Light Mode',
                                                  style: menuTextStyle,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Material(
                                                color:
                                                    (isDarkMode
                                                            ? Colors.indigo
                                                            : Colors.amber)
                                                        .withAlpha(102),
                                                shape: const CircleBorder(),
                                                child: IconButton(
                                                  icon: Icon(
                                                    isDarkMode
                                                        ? Icons.nightlight_round
                                                        : Icons.wb_sunny,
                                                    size: 20,
                                                    color: isDarkMode
                                                        ? Colors.indigo.shade400
                                                        : Colors.amber.shade800,
                                                  ),
                                                  onPressed: () {
                                                    ref
                                                        .read(
                                                          themeProvider
                                                              .notifier,
                                                        )
                                                        .toggleTheme();
                                                  },
                                                  padding: const EdgeInsets.all(
                                                    6,
                                                  ),
                                                  constraints:
                                                      const BoxConstraints(
                                                        minWidth: 32,
                                                        minHeight: 32,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 85,
                                                child: Text(
                                                  soundEnabled
                                                      ? 'Sound On'
                                                      : 'Sound Off',
                                                  style: menuTextStyle,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Material(
                                                color:
                                                    (soundEnabled
                                                            ? theme
                                                                  .colorScheme
                                                                  .primary
                                                            : AppColors
                                                                  .errorRed)
                                                        .withAlpha(102),
                                                shape: const CircleBorder(),
                                                child: IconButton(
                                                  icon: Icon(
                                                    soundEnabled
                                                        ? Icons.volume_up
                                                        : Icons.volume_off,
                                                    size: 20,
                                                    color: soundEnabled
                                                        ? theme
                                                              .colorScheme
                                                              .primary
                                                        : AppColors.errorRed,
                                                  ),
                                                  onPressed: () {
                                                    ref
                                                        .read(
                                                          soundEnabledProvider
                                                              .notifier,
                                                        )
                                                        .toggle();
                                                  },
                                                  padding: const EdgeInsets.all(
                                                    6,
                                                  ),
                                                  constraints:
                                                      const BoxConstraints(
                                                        minWidth: 32,
                                                        minHeight: 32,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (isLoggedIn) ...[
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                    'Your Profile',
                                                    style: menuTextStyle,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Material(
                                                  color: theme
                                                      .colorScheme
                                                      .primary
                                                      .withAlpha(102),
                                                  shape: const CircleBorder(),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.person_rounded,
                                                      size: 20,
                                                      color: theme
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                    onPressed: () {
                                                      entry.remove();
                                                      safeGo(
                                                        context,
                                                        '/settings',
                                                      );
                                                    },
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    constraints:
                                                        const BoxConstraints(
                                                          minWidth: 32,
                                                          minHeight: 32,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      );
                                    },
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
                overlayState.insert(entry);
              },
            ),
          ),
        ),

        // User avatar → Settings (profile) page
        if (authState.value != null)
          Padding(
            padding: const EdgeInsets.all(4),
            child: Tooltip(
              message: 'Settings',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => safeGo(context, '/settings'),
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: UserAvatar(
                      userId: user?.id,
                      radius: 20,
                      borderWidth: 1.2,
                      showLoadingWhenUserIdNull: true,
                    ),
                  ),
                ),
              ),
            ),
          )
        else
          AppBarIconButton(
            icon: Icons.person_add_rounded,
            onPressed: () => safeGo(context, '/login'),
            tooltip: 'Login',
            backgroundColor: Colors.white.withAlpha(38),
          ),

        // Logout Button
        if (authState.value != null)
          AppBarIconButton(
            icon: Icons.logout_rounded,
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => ConfirmationDialog(
                  title: 'Confirm Logout',
                  content: 'Are you sure you want to log out?',
                  confirmColor: AppColors.errorRed,
                ),
              );

              if (shouldLogout == true) {
                await authService.signOut();
                if (context.mounted) {
                  ref.read(currentUserProvider.notifier).clearUser();
                }
              }
            },
            tooltip: 'Logout',
            backgroundColor: Colors.white.withAlpha(38),
          ),

        SizedBox(width: isMobile ? 4 : 8),
      ],
    );
  }
}

class _VersionText extends StatelessWidget {
  const _VersionText();

  @override
  Widget build(BuildContext context) {
    final label = AppConstants.appReleaseLabel.isEmpty
        ? 'v${AppConstants.appVersionFallback}'
        : '${AppConstants.appReleaseLabel} v${AppConstants.appVersionFallback}';
    return Text(label, style: const TextStyle(fontSize: 13));
  }
}
