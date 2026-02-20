import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/providers/auth_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/user_service.dart';
import 'package:collective_action_frontend/screens/dashboard/components/navigation_button.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:collective_action_frontend/screens/dashboard/components/summary_pane.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Sync user from auth after first frame (ref.read only in callbacks, not in build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncUserFromAuth();
    });
  }

  void _syncUserFromAuth() {
    final authUser = ref.read(authStateProvider).value;
    if (authUser != null) {
      UserService()
          .fetchUserByFirebaseID(userId: authUser.uid)
          .then((appUser) {
        if (mounted && appUser != null) {
          ref.read(currentUserProvider.notifier).setUser(appUser);
        }
      });
    } else {
      ref.read(currentUserProvider.notifier).clearUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (_, _) {
      _syncUserFromAuth();
    });
    final isMobile = AppConstants.isMobile(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 16,
              vertical: isMobile ? 0 : 12,
            ),
            child: isMobile
                ? null
                //  Row(
                //     children: [
                //       Expanded(
                //         child: NavigationButton(
                //           icon: Icons.trending_up,
                //           label: 'Initiatives',
                //           color: AppColors.lightBlue,
                //           onTap: () {
                //             context.go('/initiatives');
                //           },
                //           small: true,
                //         ),
                //       ),
                //       SizedBox(width: 4),
                //       Expanded(
                //         child: NavigationButton(
                //           icon: Icons.assignment_outlined,
                //           label: 'Projects',
                //           color: AppColors.errorRed,
                //           onTap: () {
                //             context.go('/projects');
                //           },
                //           small: true,
                //         ),
                //       ),
                //       SizedBox(width: 4),
                //       Expanded(
                //         child: NavigationButton(
                //           icon: Icons.map_outlined,
                //           label: 'Maps',
                //           color: AppColors.successGreen,
                //           onTap: () {
                //             context.go('/maps');
                //           },
                //           small: true,
                //         ),
                //       ),
                //       SizedBox(width: 4),
                //       Expanded(
                //         child: NavigationButton(
                //           icon: Icons.people_outline,
                //           label: 'Social',
                //           color: AppColors.warningOrange,
                //           onTap: () {
                //             context.go('/social');
                //           },
                //           small: true,
                //         ),
                //       ),
                //     ],
                //   )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        NavigationButton(
                          icon: Icons.trending_up,
                          label: 'Initiatives',
                          color: AppColors.lightBlue,
                          onTap: () => safeGo(context, '/initiatives'),
                        ),
                        SizedBox(width: 12),
                        NavigationButton(
                          icon: Icons.assignment_outlined,
                          label: 'Projects',
                          color: AppColors.errorRed,
                          onTap: () => safeGo(context, '/projects'),
                        ),
                        SizedBox(width: 12),
                        NavigationButton(
                          icon: Icons.map_outlined,
                          label: 'Maps',
                          color: AppColors.successGreen,
                          onTap: () => safeGo(context, '/maps/cleanup'),
                        ),
                        SizedBox(width: 12),
                        NavigationButton(
                          icon: Icons.people_outline,
                          label: 'Social',
                          color: AppColors.warningOrange,
                          onTap: () => safeGo(context, '/social'),
                        ),
                      ],
                    ),
                  ),
          ),
          if (!isMobile) Divider(height: 1),
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
