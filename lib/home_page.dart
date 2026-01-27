import 'dart:ui' as html;

import 'package:anc_date_calculator/core/utils/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/date_calculator/presentation/screens/anc_date_calculator_screen.dart';
import 'features/date_calculator/presentation/screens/pnc_date_calculator_screen.dart';
import 'features/date_calculator/providers/theme_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _titles = [
    'ANC વિઝિટ કૅલ્ક્યુલેટેર',
    'PNC વિઝિટ કૅલ્ક્યુલેટેર',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging)
        return; // avoid rebuild during animation
      setState(() {}); // Rebuild to update AppBar title
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(themeControllerProvider);
    final systemBrightness = MediaQuery.of(context).platformBrightness;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_tabController.index]),
        actions: [
          IconButton(
            icon: Icon(
              mode == ThemeMode.system
                  ? (systemBrightness == Brightness.dark
                        ? Icons.dark_mode_sharp
                        : Icons.light_mode_sharp)
                  : mode == ThemeMode.dark
                  ? Icons.dark_mode_sharp
                  : Icons.light_mode_sharp,
            ),
            onPressed: () => ref
                .read(themeControllerProvider.notifier)
                .toggle(systemBrightness),
            tooltip: 'Change Theme',
          ),

          if (kIsWeb)
            IconButton(
              icon: const Icon(Icons.get_app_rounded),
              tooltip: 'Download Android App',
              onPressed: Utility.downloadApkWeb,
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          labelColor: Colors.white,
          // active tab text/icon
          unselectedLabelColor: Colors.white60,
          // inactive tab text/icon
          dividerColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white60
              : Colors.black54,
          tabs: const [
            Tab(icon: Icon(Icons.pregnant_woman), text: 'ANC મુલાકાત'),
            Tab(icon: Icon(Icons.local_hospital), text: 'PNC મુલાકાત'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ANCDateCalculatorScreen(
            lmp: DateTime.now(), // Replace with actual LMP selection
          ),
          const PNCDateCalculatorScreen(),
        ],
      ),
    );
  }
}
