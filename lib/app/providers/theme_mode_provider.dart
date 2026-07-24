import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeProvider extends ChangeNotifier {
  ThemeMode _currentThemeMode = .system;

  ThemeMode get themeMode => _currentThemeMode;

  void changeThemeMode(ThemeMode mode) {
    _currentThemeMode = mode;
    _saveThemeMode(mode);
    notifyListeners();
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('theme-mode', mode.name);
  }

  Future<void> setDefaultThemeMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? themeMode = sharedPreferences.getString('theme-mode');
    if (themeMode != null) {
      _currentThemeMode = _parseThemeMode(themeMode);
    }
  }

  ThemeMode _parseThemeMode(String themeMode) {
    switch (themeMode) {
      case 'light':
        return .light;
      case 'dark':
        return .dark;
      default:
        return .system;
    }
  }
}