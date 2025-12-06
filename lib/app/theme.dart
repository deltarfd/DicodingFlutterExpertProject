import 'package:ditonton_core/core/core.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    const seed = Color(0xFF006D77); // teal-ish
    final colorScheme =
        ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        elevation: 0,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      drawerTheme: const DrawerThemeData(),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
        ),
      ),
      inputDecorationTheme:
          const InputDecorationTheme(border: OutlineInputBorder()),
    );
  }

  static ThemeData dark() {
    const seed = Color(0xFF00B4D8); // cyan-ish
    final colorScheme =
        ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        elevation: 0,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      drawerTheme: const DrawerThemeData(),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
        ),
      ),
      inputDecorationTheme:
          const InputDecorationTheme(border: OutlineInputBorder()),
    );
  }
}
