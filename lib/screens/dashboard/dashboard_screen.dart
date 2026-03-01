import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/providers/auth_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/user_service.dart';
import 'package:collective_action_frontend/screens/dashboard/components/navigation_button.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:collective_action_frontend/screens/dashboard/components/summary_pane.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
    // Sync user from auth after first frame (ref.read only in callbacks, not in build).
    // On mobile web, defer a bit longer so route transition can finish and avoid
    // ref-after-dispose / overload during navigation (e.g. Home button).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (kIsWeb && AppConstants.isMobile(context)) {
        Future.delayed(const Duration(milliseconds: 180), () {
          if (mounted) _syncUserFromAuth();
        });
      } else {
        _syncUserFromAuth();
      }
    });
  }

  void _syncUserFromAuth() {
    if (!mounted) return;
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
      if (mounted) ref.read(currentUserProvider.notifier).clearUser();
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

/// Builds the 4-pane dashboard. On mobile, the second row (Maps, Social) is
/// built after a short delay so the first row can paint first and reduce
/// peak load when navigating back to home (mobile Chrome).
class PaneLayout extends StatefulWidget {
  const PaneLayout({super.key});

  @override
  State<PaneLayout> createState() => _PaneLayoutState();
}

class _PaneLayoutState extends State<PaneLayout> {
  /// On mobile we defer building the second row so first row can load first.
  /// Slower delay improves stability on mobile Chrome (less concurrent load).
  static const Duration _kMobileSecondRowDelay = Duration(milliseconds: 280);

  bool _showSecondRow = true;
  bool _didScheduleDefer = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cannot use MediaQuery/context in initState; defer decision until here.
    if (_didScheduleDefer) return;
    _didScheduleDefer = true;
    if (AppConstants.isMobile(context)) {
      _showSecondRow = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Future.delayed(_kMobileSecondRowDelay, () {
          if (mounted) setState(() => _showSecondRow = true);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppConstants.isMobile(context);

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
          child: _showSecondRow
              ? Row(
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
                )
              : (isMobile
                  ? const Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    )
                  : Row(
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
                    )),
        ),
      ],
    );
  }
}
