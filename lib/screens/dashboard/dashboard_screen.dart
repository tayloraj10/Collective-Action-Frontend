import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/providers/auth_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/navigation_button.dart';
import 'package:collective_action_frontend/screens/dashboard/components/summary_pane.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = AppConstants.isMobile(context);
    final authUser = ref.watch(authStateProvider).value;

    // Fetch and set user data if logged in
    if (authUser != null) {
      Future.microtask(() async {
        final appUser = await ref
            .read(activeUserProvider(authUser.uid).notifier)
            .build();
        if (appUser != null) {
          await ref.read(currentUserProvider.notifier).setUser(appUser);
        }
      });
    } else {
      Future.microtask(() async {
        await ref.read(currentUserProvider.notifier).clearUser();
      });
    }

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 16,
              vertical: 12,
            ),
            child: isMobile
                ? Row(
                    children: [
                      Expanded(
                        child: NavigationButton(
                          icon: Icons.trending_up,
                          label: 'Initiatives',
                          color: AppColors.lightBlue,
                          onTap: () {
                            context.go('/initiatives');
                          },
                          small: true,
                        ),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: NavigationButton(
                          icon: Icons.assignment_outlined,
                          label: 'Projects',
                          color: AppColors.errorRed,
                          onTap: () {
                            context.go('/projects');
                          },
                          small: true,
                        ),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: NavigationButton(
                          icon: Icons.map_outlined,
                          label: 'Maps',
                          color: AppColors.successGreen,
                          onTap: () {
                            context.go('/maps');
                          },
                          small: true,
                        ),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: NavigationButton(
                          icon: Icons.people_outline,
                          label: 'Social',
                          color: AppColors.warningOrange,
                          onTap: () {
                            context.go('/social');
                          },
                          small: true,
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        NavigationButton(
                          icon: Icons.trending_up,
                          label: 'Initiatives',
                          color: AppColors.lightBlue,
                          onTap: () {
                            context.go('/initiatives');
                          },
                        ),
                        SizedBox(width: 12),
                        NavigationButton(
                          icon: Icons.assignment_outlined,
                          label: 'Projects',
                          color: AppColors.errorRed,
                          onTap: () {
                            context.go('/projects');
                          },
                        ),
                        SizedBox(width: 12),
                        NavigationButton(
                          icon: Icons.map_outlined,
                          label: 'Maps',
                          color: AppColors.successGreen,
                          onTap: () {
                            context.go('/maps');
                          },
                        ),
                        SizedBox(width: 12),
                        NavigationButton(
                          icon: Icons.people_outline,
                          label: 'Social',
                          color: AppColors.warningOrange,
                          onTap: () {
                            context.go('/social');
                          },
                        ),
                      ],
                    ),
                  ),
          ),
          Divider(height: 1),
          // 4-Pane Layout
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 8 : 10),
              child: const PaneLayout(),
            ),
          ),
        ],
      ),
    );
  }
}

class PaneLayout extends StatelessWidget {
  const PaneLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: const [
              Expanded(
                child: SummaryPane(
                  title: 'Initiatives',
                  icon: Icons.trending_up,
                  color: AppColors.lightBlue,
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: SummaryPane(
                  title: 'Projects',
                  icon: Icons.assignment_outlined,
                  color: AppColors.errorRed,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Row(
            children: const [
              Expanded(
                child: SummaryPane(
                  title: 'Maps',
                  icon: Icons.map_outlined,
                  color: AppColors.successGreen,
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: SummaryPane(
                  title: 'Social',
                  icon: Icons.people_outline,
                  color: AppColors.warningOrange,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
