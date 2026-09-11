import 'package:anc_date_calculator/core/ads/ads_initializer.dart';
import 'package:anc_date_calculator/core/providers/navigator_key_provider.dart';
import 'package:anc_date_calculator/core/theme/app_theme.dart';
import 'package:anc_date_calculator/core/services/remote_config_service.dart';
import 'package:anc_date_calculator/features/date_calculator/providers/theme_provider.dart';
import 'package:anc_date_calculator/firebase_options.dart';
import 'package:anc_date_calculator/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'features/date_calculator/presentation/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Required initialization.
  await initializeDateFormatting('gu_IN', null);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await RemoteConfigService.instance.initialize();
  // Start ads without waiting for them.
  AdsInitializer.init().catchError((error) {
    debugPrint('Ads initialization failed: $error');
  });

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigatorKey = ref.read(navigatorKeyProvider);

    return MaterialApp(
      navigatorKey: navigatorKey,

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeControllerProvider),

      home: const SplashScreen(),
    );
  }
}