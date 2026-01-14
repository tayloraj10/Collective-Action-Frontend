import 'dart:developer';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firebase_options.dart';
import 'providers/theme_provider.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Call backend health check to spin up backend on app start
  ApiService()
      .getHealth()
      .then((value) {
        log('Health check result:');
        log(value.toString());
      })
      .catchError((error) {
        log('Health check error:');
        log(error.toString());
      });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Collective Action Network',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
