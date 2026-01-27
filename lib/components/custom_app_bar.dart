import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/app_bar_icon_button.dart';
import 'package:collective_action_frontend/components/confirmation_dialog.dart';
import 'package:collective_action_frontend/providers/auth_provider.dart';
import 'package:collective_action_frontend/providers/theme_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
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
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final isMobile = AppConstants.isMobile(context);
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final isHomeRoute = currentLocation == '/';

    final user = authState.value;

    return AppBar(
      elevation: 2,
      centerTitle: isMobile ? false : true,
      leadingWidth: !isHomeRoute ? 72 : null,
      leading: !isHomeRoute
          ? Padding(
              padding: const EdgeInsets.only(left: 12),
              child: AppBarIconButton(
                icon: Icons.home,
                onPressed: () => context.go('/'),
                tooltip: 'Home',
                backgroundColor: Colors.white.withAlpha(38),
              ),
            )
          : null,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8),
        child: Text(
          isMobile ? 'Collective' : 'Collective Action Network',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: isMobile ? 0 : 0.5,
          ),
        ),
      ),
      actions: [
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
                            'support@collectiveaction.app',
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
                          Text('v1.0.0', style: TextStyle(fontSize: 13)),
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
                              '- Dashboard\n- Profile Page',
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
                              '- Projects\n- Maps\n- Events',
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
        // Dark/Light Mode Toggle
        AppBarIconButton(
          icon: isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
          onPressed: () {
            ref.read(themeProvider.notifier).toggleTheme();
          },
          tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
          backgroundColor: Colors.white.withAlpha(38),
        ),

        // User Profile Button or Login Button
        if (authState.value != null)
          (user?.photoURL != null
              ? Padding(
                  padding: const EdgeInsets.all(4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.go('/settings');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(user!.photoURL!),
                          backgroundColor: Colors.white.withAlpha(38),
                        ),
                      ),
                    ),
                  ),
                )
              : AppBarIconButton(
                  icon: Icons.person_outline,
                  onPressed: () {
                    context.go('/settings');
                  },
                  tooltip: 'Profile',
                  backgroundColor: Colors.white.withAlpha(38),
                ))
        else
          AppBarIconButton(
            icon: Icons.login,
            onPressed: () {
              context.go('/login');
            },
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
                ref.read(currentUserProvider.notifier).clearUser();
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
