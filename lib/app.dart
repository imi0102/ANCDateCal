import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/core_providers.dart' as coreProviders;
import 'core/theme/app_theme.dart';
import 'features/date_calculator/presentation/screens/date_calculator_screen.dart';


class MyApp extends ConsumerWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(coreProviders.themeProvider);


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const DateCalculatorScreen(),
    );
  }
}