import 'package:collective_action_frontend/screens/dashboard/dashboard_screen.dart';
import 'package:collective_action_frontend/screens/initiatives/initiative_list_screen.dart';
import 'package:collective_action_frontend/screens/projects/project_list_screen.dart';
import 'package:collective_action_frontend/screens/maps/map_screen.dart';
import 'package:collective_action_frontend/screens/social/social_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case '/initiatives':
        return MaterialPageRoute(builder: (_) => const InitiativeListScreen());
      case '/projects':
        return MaterialPageRoute(builder: (_) => const ProjectListScreen());
      case '/maps':
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case '/social':
        return MaterialPageRoute(builder: (_) => const SocialScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
