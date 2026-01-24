import 'package:collective_action_frontend/screens/dashboard/dashboard_screen.dart';
import 'package:collective_action_frontend/screens/initiatives/initiative_list_screen.dart';
import 'package:collective_action_frontend/screens/projects/project_list_screen.dart';
import 'package:collective_action_frontend/screens/maps/map_screen.dart';
import 'package:collective_action_frontend/screens/social/social_screen.dart';
import 'package:collective_action_frontend/screens/login/login_screen.dart';
import 'package:collective_action_frontend/screens/health_check_screen.dart';
import 'package:collective_action_frontend/screens/user_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const DashboardScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/initiatives',
        builder: (context, state) => const InitiativeListScreen(),
      ),
      GoRoute(
        path: '/projects',
        builder: (context, state) => const ProjectListScreen(),
      ),
      GoRoute(path: '/maps', builder: (context, state) => const MapScreen()),
      GoRoute(
        path: '/social',
        builder: (context, state) => const SocialScreen(),
      ),
      GoRoute(
        path: '/health',
        builder: (context, state) => const HealthCheckScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const UserSettingsPage(),
      ),
      // Catch-all route for unknown paths
      GoRoute(path: '/:notFound(.*)', redirect: (_, _) => '/'),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('No route defined for ${state.matchedLocation}'),
      ),
    ),
  );
});
