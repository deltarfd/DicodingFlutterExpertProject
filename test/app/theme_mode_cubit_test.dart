import 'package:ditonton/app/theme_mode_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeModeCubit', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state is ThemeMode.system', () {
      final cubit = ThemeModeCubit();
      expect(cubit.state.themeMode, ThemeMode.system);
    });

    test('loads saved theme mode (light)', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'light'});
      final cubit = ThemeModeCubit();
      await Future.delayed(const Duration(milliseconds: 100));
      expect(cubit.state.themeMode, ThemeMode.light);
    });

    test('loads saved theme mode (dark)', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'dark'});
      final cubit = ThemeModeCubit();
      await Future.delayed(const Duration(milliseconds: 100));
      expect(cubit.state.themeMode, ThemeMode.dark);
    });

    test('loads saved theme mode (system)', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'system'});
      final cubit = ThemeModeCubit();
      await Future.delayed(const Duration(milliseconds: 100));
      expect(cubit.state.themeMode, ThemeMode.system);
    });

    test('toggle from light to dark', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'light'});
      final cubit = ThemeModeCubit();
      await Future.delayed(const Duration(milliseconds: 100));

      cubit.toggle();
      expect(cubit.state.themeMode, ThemeMode.dark);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_theme_mode'), 'dark');
    });

    test('toggle from dark to light', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'dark'});
      final cubit = ThemeModeCubit();
      await Future.delayed(const Duration(milliseconds: 100));

      cubit.toggle();
      expect(cubit.state.themeMode, ThemeMode.light);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_theme_mode'), 'light');
    });

    test('toggle from system to light', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'system'});
      final cubit = ThemeModeCubit();
      await Future.delayed(const Duration(milliseconds: 100));

      cubit.toggle();
      expect(cubit.state.themeMode, ThemeMode.light);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_theme_mode'), 'light');
    });

    test('setThemeMode changes theme and persists', () async {
      final cubit = ThemeModeCubit();
      await Future.delayed(const Duration(milliseconds: 100));

      cubit.setThemeMode(ThemeMode.dark);
      expect(cubit.state.themeMode, ThemeMode.dark);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_theme_mode'), 'dark');
    });

    test('ThemeModeState equality works correctly', () {
      const state1 = ThemeModeState(ThemeMode.light);
      const state2 = ThemeModeState(ThemeMode.light);
      const state3 = ThemeModeState(ThemeMode.dark);

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('persistence works across instances', () async {
      final cubit1 = ThemeModeCubit();
      await Future.delayed(const Duration(milliseconds: 100));

      cubit1.setThemeMode(ThemeMode.dark);
      await Future.delayed(const Duration(milliseconds: 100));

      final cubit2 = ThemeModeCubit();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(cubit2.state.themeMode, ThemeMode.dark);
    });
  });
}
