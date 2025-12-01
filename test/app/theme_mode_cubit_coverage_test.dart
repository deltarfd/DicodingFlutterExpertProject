import 'package:ditonton/app/theme_mode_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeModeCubit Coverage', () {
    test(
      'setThemeMode(ThemeMode.system) saves "system" to SharedPreferences',
      () async {
        SharedPreferences.setMockInitialValues({});
        final cubit = ThemeModeCubit();

        cubit.setThemeMode(ThemeMode.system);

        // Wait for async save
        await Future.delayed(Duration.zero);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('app_theme_mode'), 'system');
        expect(cubit.state.themeMode, ThemeMode.system);
      },
    );
  });
}
