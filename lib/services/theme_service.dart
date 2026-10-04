import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  ThemeService._();

  static final ThemeService instance = ThemeService._();

  static const String _darkModeKey = 'dark_mode';

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> loadTheme() async {
    final preferences = await SharedPreferences.getInstance();

    _isDarkMode = preferences.getBool(_darkModeKey) ?? false;
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;

    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_darkModeKey, value);
  }
}