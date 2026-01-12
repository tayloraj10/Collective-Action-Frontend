import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/app_bar_icon_button.dart';
import 'package:collective_action_frontend/providers/auth_provider.dart';
import 'package:collective_action_frontend/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return AppBar(
      elevation: 2,
      title: Flexible(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8),
          child: Align(
            alignment: isMobile ? Alignment.centerLeft : Alignment.center,
            child: Text(
              isMobile ? 'Collective' : 'Collective Action Network',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: isMobile ? 0 : 0.5,
                fontSize: isMobile ? 18 : null,
              ),
            ),
          ),
        ),
      ),
      actions: [
        // Dark/Light Mode Toggle
        AppBarIconButton(
          icon: isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
          onPressed: () {
            ref.read(themeProvider.notifier).toggleTheme();
          },
          tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
          backgroundColor: Colors.white.withAlpha(38),
        ),

        // User Profile Button - Hide on mobile
        AppBarIconButton(
          icon: Icons.person_outline,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile feature coming soon!')),
            );
          },
          tooltip: 'Profile',
          backgroundColor: Colors.white.withAlpha(38),
        ),

        // Logout Button
        AppBarIconButton(
          icon: Icons.logout_rounded,
          onPressed: () async {
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm Logout'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorRed,
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );

            if (shouldLogout == true) {
              await authService.signOut();
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
