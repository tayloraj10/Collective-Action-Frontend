import 'dart:developer';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/app/router.dart';
import 'package:collective_action_frontend/components/user_data_sync_observer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'firebase_options.dart';
import 'providers/theme_provider.dart';
import 'services/health_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  if (kIsWeb) {
    ImagePickerPlugin.registerWith(webPluginRegistrar);
    // Use web implementation for Google Maps (avoids "Windows not supported" when running in Chrome)
    GoogleMapsPlugin.registerWith(webPluginRegistrar);
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Call backend health check to spin up backend on app start
  HealthService().fetchHealth().then((value) {
    log('Health check result:');
    log(value?.toString() ?? 'null');
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(goRouterProvider);

    return UserDataSyncObserver(
      child: MaterialApp.router(
        title: 'Collective Action Network',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
