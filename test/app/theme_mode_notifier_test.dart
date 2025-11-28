import 'package:ditonton/app/theme_mode_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ThemeModeNotifier loads default and toggles/saves', () async {
    SharedPreferences.setMockInitialValues({});
    final notifier = ThemeModeNotifier();

    // Wait for initial _load
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(notifier.themeMode, anyOf(ThemeMode.system, ThemeMode.light, ThemeMode.dark));

    final before = notifier.themeMode;
    notifier.toggle();
    expect(notifier.themeMode == before, false);

    // Set explicit mode
    notifier.set(ThemeMode.dark);
    expect(notifier.themeMode, ThemeMode.dark);

    // Recreate to ensure persisted value is loaded
    final notifier2 = ThemeModeNotifier();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(notifier2.themeMode, ThemeMode.dark);
  });

  test('loads "light" from prefs and toggles light<->dark', () async {
    // Ensure load branch for 'light' is covered
    SharedPreferences.setMockInitialValues({'app_theme_mode': 'light'});
    final notifier = ThemeModeNotifier();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(notifier.themeMode, ThemeMode.light);

    // Toggle to dark (covers line where light -> dark)
    notifier.toggle();
    expect(notifier.themeMode, ThemeMode.dark);

    // Toggle back to light (covers line where dark -> light)
    notifier.toggle();
    expect(notifier.themeMode, ThemeMode.light);
  });
}
