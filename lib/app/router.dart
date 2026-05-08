import 'package:collective_action_frontend/screens/dashboard/dashboard_screen.dart';
import 'package:collective_action_frontend/screens/initiatives/initiative_list_screen.dart';
import 'package:collective_action_frontend/screens/network_graph/network_graph_screen.dart';
import 'package:collective_action_frontend/screens/user/contributions_page.dart';
import 'package:collective_action_frontend/screens/projects/project_list_screen.dart';
import 'package:collective_action_frontend/screens/projects/project_detail_screen.dart';
import 'package:collective_action_frontend/screens/maps/map_screen.dart';
import 'package:collective_action_frontend/screens/social/directory_of_good_entry_details.dart';
import 'package:collective_action_frontend/screens/social/social_screen.dart';
import 'package:collective_action_frontend/screens/login/login_screen.dart';
import 'package:collective_action_frontend/screens/health_check_screen.dart';
import 'package:collective_action_frontend/screens/user/settings_page.dart';
import 'package:collective_action_frontend/screens/user/profile_page.dart';
import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      // Redirect /maps to /maps/cleanup so we never build then navigate (avoids
      // mobile Chrome crashes from context.go in postFrameCallback).
      final path = state.uri.path;
      if (path == '/maps' || path == '/maps/') {
        return '/maps/cleanup';
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
        routes: [
          GoRoute(
            path: ':projectId',
            builder: (context, state) {
              final id = state.pathParameters['projectId'] ?? '';
              if (id.isEmpty) return const ProjectListScreen();
              return ProjectDetailScreen(projectId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/maps',
        builder: (context, state) => const MapScreen(),
        routes: [
          GoRoute(
            path: 'cleanup',
            builder: (context, state) => const MapScreen(
              initialCampaignType: MapCampaignTypeEnum.cleanupMap,
            ),
          ),
          GoRoute(
            path: 'planting',
            builder: (context, state) => const MapScreen(
              initialCampaignType: MapCampaignTypeEnum.plantingMap,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/social',
        builder: (context, state) => const SocialScreen(),
        routes: [
          GoRoute(
            path: 'directory/:entryId',
            builder: (context, state) {
              final entryId = state.pathParameters['entryId'] ?? '';
              if (entryId.isEmpty) return const SocialScreen();
              return DirectoryOfGoodEntryPage(entryId: entryId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/network',
        redirect: (context, state) {
          if (state.uri.path == '/network') {
            return '/network/graph';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: 'graph',
            builder: (context, state) =>
                const NetworkGraphScreen(initialView: NetworkView.graph),
          ),
          GoRoute(
            path: 'circuit',
            builder: (context, state) =>
                const NetworkGraphScreen(initialView: NetworkView.grid),
          ),
          GoRoute(path: 'directory', redirect: (_, _) => '/network/circuit'),
          GoRoute(
            path: 'map',
            builder: (context, state) =>
                const NetworkGraphScreen(initialView: NetworkView.map),
          ),
        ],
      ),
      GoRoute(
        path: '/contributions/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId'] ?? '';
          if (userId.isEmpty) return const DashboardScreen();
          return ContributionsPage(userId: userId);
        },
      ),
      GoRoute(
        path: '/health',
        builder: (context, state) => const HealthCheckScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/profile/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId'] ?? '';
          if (userId.isEmpty) return const DashboardScreen();
          return ProfilePage(userId: userId);
        },
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
