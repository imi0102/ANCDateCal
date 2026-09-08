/*
import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF142B54);
  static const secondaryColor = Color(0xFFDDDCEA);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    scaffoldBackgroundColor: Color(0xFF0E1625),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
  );


}
*/

import 'package:flutter/material.dart';

class AppTheme {
  //static const primaryColor = Color(0xFFFF546E);
  static const secondaryColor = Color(0xFFDDDCEA);
  static const primaryColor = Color(0xFF142B54);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,

    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),

    scaffoldBackgroundColor: Colors.white,

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    iconTheme: const IconThemeData(
      color: primaryColor,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
      titleMedium: TextStyle(color: primaryColor),
      labelLarge: TextStyle(color: primaryColor),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,

    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
    ),

    scaffoldBackgroundColor: const Color(0xFF0B1220),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121C33),
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    iconTheme: const IconThemeData(
      color: Colors.white,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
      titleMedium: TextStyle(color: Colors.white),
      labelLarge: TextStyle(color: Colors.white),
    ),

  );
}
