import 'package:collective_action_frontend/screens/dashboard/dashboard_screen.dart';
import 'package:collective_action_frontend/screens/initiatives/initiative_list_screen.dart';
import 'package:collective_action_frontend/screens/projects/project_list_screen.dart';
import 'package:collective_action_frontend/screens/maps/map_screen.dart';
import 'package:collective_action_frontend/screens/social/social_screen.dart';
import 'package:collective_action_frontend/screens/login/login_screen.dart';
import 'package:collective_action_frontend/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }
      if (isLoggedIn && isLoginRoute) {
        return '/';
      }
      return null;
    },
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
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('No route defined for ${state.matchedLocation}'),
      ),
    ),
  );
});
