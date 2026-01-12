import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/app_bar_icon_button.dart';
import 'package:collective_action_frontend/components/confirmation_dialog.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
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
    final authState = ref.watch(authStateProvider);
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final isMobile = MediaQuery.of(context).size.width < 600;

    final user = authState.value;

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

        // User Profile Button - Show Google photo if available
        user?.photoURL != null
            ? Padding(
                padding: const EdgeInsets.all(4),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackBar.info('Profile feature coming soon!'),
                      );
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackBar.info('Profile feature coming soon!'),
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
              builder: (context) => ConfirmationDialog(
                title: 'Confirm Logout',
                content: 'Are you sure you want to log out?',
                confirmColor: AppColors.errorRed,
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
