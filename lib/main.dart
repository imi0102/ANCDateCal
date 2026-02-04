import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/ads/ads_initializer.dart';
import 'home_page.dart';
import 'core/theme/app_theme.dart';
import 'features/date_calculator/providers/theme_provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdsInitializer.init();
  await initializeDateFormatting('gu_IN', null);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeControllerProvider),
      home: const HomePage(),
    );
  }
}