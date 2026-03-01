import 'dart:async';
import 'dart:developer';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/router.dart';
import 'package:collective_action_frontend/app/theme.dart';
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

void main() {
  // Run bindings and runApp in the same zone so Flutter does not throw a zone
  // mismatch. Catch unhandled async errors so they don't kill the isolate
  // (avoids tab crash and forced refresh on mobile browsers).
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    _initAndRun();
  }, (Object error, StackTrace stackTrace) {
    log('Unhandled async error', error: error, stackTrace: stackTrace);
  });
}

Future<void> _initAndRun() async {
  usePathUrlStrategy();
  if (kIsWeb) {
    ImagePickerPlugin.registerWith(webPluginRegistrar);
    // Use web implementation for Google Maps (avoids "Windows not supported" when running in Chrome)
    GoogleMapsPlugin.registerWith(webPluginRegistrar);
    // Preload audio so first user gesture can unlock playback on mobile browsers
    AppConstants.preloadAudioForWeb();
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Catch Flutter framework errors; log and forward to default so we have a
  // record without changing debug behavior. Reduces chance of opaque crash/refresh on web.
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    log('FlutterError', error: details.exception, stackTrace: details.stack);
    previousOnError?.call(details);
  };

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
      child: _WebAudioUnlock(
        child: MaterialApp.router(
          title: 'Collective Action Network',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        ),
      ),
    );
  }
}

/// On web, unlocks audio on first user tap anywhere so success sounds can play on mobile browsers.
/// Listener catches pointer (and touch) events; GestureDetector ensures tap is also handled on all platforms.
class _WebAudioUnlock extends StatelessWidget {
  const _WebAudioUnlock({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => AppConstants.unlockAudioForWeb(),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => AppConstants.unlockAudioForWeb(),
        child: child,
      ),
    );
  }
}
