import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// State for theme mode
class ThemeModeState {
  final ThemeMode themeMode;

  const ThemeModeState(this.themeMode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeModeState &&
          runtimeType == other.runtimeType &&
          themeMode == other.themeMode;

  @override
  int get hashCode => themeMode.hashCode;
}

/// Cubit for managing theme mode (light/dark/system)
class ThemeModeCubit extends Cubit<ThemeModeState> {
  static const _key = 'app_theme_mode';

  ThemeModeCubit() : super(const ThemeModeState(ThemeMode.system)) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    final themeMode = switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    emit(ThemeModeState(themeMode));
  }

  Future<void> _save(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await prefs.setString(_key, value);
  }

  void toggle() {
    final newMode = switch (state.themeMode) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.light,
    };
    emit(ThemeModeState(newMode));
    _save(newMode);
  }

  void setThemeMode(ThemeMode mode) {
    emit(ThemeModeState(mode));
    _save(mode);
  }
}
