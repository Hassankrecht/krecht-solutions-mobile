import 'package:flutter/material.dart';
import '../core/storage/local_storage.dart';

enum AppThemePreference { system, light, dark }

// Holds app-wide UI preferences such as theme mode.
class AppProvider extends ChangeNotifier {
  AppProvider();

  AppThemePreference _themePreference = AppThemePreference.system;

  AppThemePreference get themePreference => _themePreference;
  bool get isDarkMode => _themePreference == AppThemePreference.dark;

  ThemeMode get themeMode {
    switch (_themePreference) {
      case AppThemePreference.light:
        return ThemeMode.light;
      case AppThemePreference.dark:
        return ThemeMode.dark;
      case AppThemePreference.system:
        return ThemeMode.system;
    }
  }

  String get themeLabel {
    switch (_themePreference) {
      case AppThemePreference.light:
        return 'Light';
      case AppThemePreference.dark:
        return 'Dark';
      case AppThemePreference.system:
        return 'Auto';
    }
  }

  Future<void> loadThemePreference() async {
    final savedTheme = await LocalStorage.instance.getThemeMode();
    _themePreference = AppThemePreference.values.firstWhere(
      (theme) => theme.name == savedTheme,
      orElse: () => AppThemePreference.system,
    );
    notifyListeners();
  }

  // Switches dark mode between enabled and disabled.
  Future<void> toggleDarkMode() async {
    await setThemePreference(
      _themePreference == AppThemePreference.dark
          ? AppThemePreference.light
          : AppThemePreference.dark,
    );
  }

  Future<void> setThemePreference(AppThemePreference value) async {
    _themePreference = value;
    await LocalStorage.instance.saveThemeMode(value.name);
    notifyListeners();
  }

  // Sets dark mode to a specific value.
  Future<void> setDarkMode(bool value) async {
    await setThemePreference(
      value ? AppThemePreference.dark : AppThemePreference.light,
    );
  }
}
