import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeControllerProvider =
NotifierProvider<ThemeController, ThemeMode>(ThemeController.new);

class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // App start → follow system theme
    return ThemeMode.system;
  }

  /// Force Light
  void setLight() {
    state = ThemeMode.light;
  }

  /// Force Dark
  void setDark() {
    state = ThemeMode.dark;
  }

  /// Back to System default
  void setSystem() {
    state = ThemeMode.system;
  }

  /// Simple toggle between light & dark
  void toggle(Brightness systemBrightness) {
    if (state == ThemeMode.system) {
      // If system is dark → go light, if system is light → go dark
      state = systemBrightness == Brightness.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    } else {
      state = state == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    }
  }
}
