import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/screens/dashboard/dashboard_screen.dart';
import 'package:collective_action_frontend/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Collective Action Network',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: authState.when(
        data: (user) => user != null ? DashboardScreen() : LoginScreen(),
        loading: () => const CircularProgressIndicator(),
        error: (_, _) => LoginScreen(),
      ),
    );
  }
}
