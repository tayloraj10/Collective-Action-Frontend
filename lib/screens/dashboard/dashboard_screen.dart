import 'dart:async';

import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/providers/auth_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/user_service.dart';
import 'package:collective_action_frontend/services/health_service.dart';
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
  static const Duration _kWarmupDisplayDelay = Duration(milliseconds: 900);
  bool _showWarmupOverlay = false;
  bool _healthCheckResponded = true;

  @override
  void initState() {
    super.initState();
    _startDashboardWarmup();
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
      UserService().fetchUserByFirebaseID(userId: authUser.uid).then((appUser) {
        if (mounted && appUser != null) {
          ref.read(currentUserProvider.notifier).setUser(appUser);
        }
      });
    } else {
      if (mounted) ref.read(currentUserProvider.notifier).clearUser();
    }
  }

  void _startDashboardWarmup() {
    _healthCheckResponded = false;

    // Only show overlay if backend warmup is actually slow.
    Future.delayed(_kWarmupDisplayDelay, () {
      if (!mounted || _healthCheckResponded || _showWarmupOverlay) return;
      setState(() {
        _showWarmupOverlay = true;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _runWarmupHealthCheck();
    });
  }

  Future<void> _runWarmupHealthCheck() async {
    try {
      final response = await HealthService.ensureStartupHealthCheck();
      final hasData = (response ?? '').trim().isNotEmpty;
      if (!mounted) return;
      setState(() {
        _healthCheckResponded = true;
        // Hide immediately once health endpoint returns data.
        _showWarmupOverlay = hasData ? false : _showWarmupOverlay;
      });
    } catch (_) {
      // Continue even if the check fails or times out.
      if (!mounted) return;
      setState(() {
        _healthCheckResponded = true;
        _showWarmupOverlay = false;
      });
    }
  }

  List<Widget> _dashboardNavRowChildren(BuildContext context) {
    const gap = SizedBox(width: 12);
    void go(String route) => safeGo(context, route);
    Widget nav({
      required IconData icon,
      required String label,
      required Color color,
      required String route,
    }) {
      return NavigationButton(
        icon: icon,
        label: label,
        color: color,
        onTap: () => go(route),
      );
    }

    return [
      nav(
        icon: Icons.trending_up,
        label: 'Initiatives',
        color: AppColors.lightBlue,
        route: '/initiatives',
      ),
      gap,
      nav(
        icon: Icons.map_outlined,
        label: 'Maps',
        color: AppColors.successGreen,
        route: '/maps/cleanup',
      ),
      gap,
      nav(
        icon: Icons.dynamic_feed_outlined,
        label: 'Community',
        color: AppColors.errorRed,
        route: '/network',
      ),
      gap,
      nav(
        icon: Icons.people_outline,
        label: 'Actions',
        color: AppColors.warningOrange,
        route: '/social',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (_, _) {
      _syncUserFromAuth();
    });
    final isMobile = AppConstants.isMobile(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              if (!isMobile)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _dashboardNavRowChildren(context),
                    ),
                  ),
                ),
              // 4-Pane Layout
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isMobile ? 6 : 12,
                    isMobile ? 6 : 4,
                    isMobile ? 6 : 12,
                    isMobile ? 6 : 10,
                  ),
                  child: const PaneLayout(),
                ),
              ),
            ],
          ),
          if (_showWarmupOverlay)
            const Positioned.fill(child: _DashboardWarmupOverlay()),
        ],
      ),
    );
  }
}

class _DashboardWarmupOverlay extends StatelessWidget {
  const _DashboardWarmupOverlay();

  @override
  Widget build(BuildContext context) {
    final isMobile = AppConstants.isMobile(context);
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.22),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 28,
              vertical: isMobile ? 24 : 32,
            ),
            child: Card(
              elevation: 2,
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.97),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.25),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 18 : 24,
                  vertical: isMobile ? 20 : 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Getting Ready To Save The World?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Take a few deep breaths while the data loads',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 14),
                    const _BreathCycleIndicator(),
                    const SizedBox(height: 12),
                    Text(
                      'The short wait helps keep costs down. Thanks for your patience.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BreathCycleIndicator extends StatefulWidget {
  const _BreathCycleIndicator();

  @override
  State<_BreathCycleIndicator> createState() => _BreathCycleIndicatorState();
}

class _BreathCycleIndicatorState extends State<_BreathCycleIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  bool _isInhaling = true;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..addStatusListener((status) {
            if (!mounted) return;
            if (status == AnimationStatus.forward && !_isInhaling) {
              setState(() => _isInhaling = true);
            } else if (status == AnimationStatus.reverse && _isInhaling) {
              setState(() => _isInhaling = false);
            }
          });
    _scale = Tween<double>(begin: 0.84, end: 1.18).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: _scale.value,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.14),
                  border: Border.all(
                    color: color.withValues(alpha: 0.55),
                    width: 1.8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _isInhaling ? 'Breathe in...' : 'Breathe out...',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        );
      },
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
              SizedBox(width: 10),
              Expanded(
                child: SummaryPane(
                  title: 'Community',
                  icon: Icons.dynamic_feed_outlined,
                  color: AppColors.errorRed,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
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
                    SizedBox(width: 10),
                    Expanded(
                      child: SummaryPane(
                        title: 'Actions',
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
                          SizedBox(width: 10),
                          Expanded(
                            child: SummaryPane(
                              title: 'Actions',
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
