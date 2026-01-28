import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode;
  bool _isLoaded = false;

  bool get isDarkMode => _isDarkMode;
  bool get isLoaded => _isLoaded;

  // Constructor accepts initial value from main.dart
  ThemeProvider({bool initialDarkMode = false})
    : _isDarkMode = initialDarkMode {
    _isLoaded = true; // Already loaded from main.dart
    _verifyThemePreference();
  }

  // Verify the theme preference matches SharedPreferences
  Future<void> _verifyThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedValue = prefs.getBool('isDarkMode') ?? false;
      if (savedValue != _isDarkMode) {
        _isDarkMode = savedValue;
        notifyListeners();
      }
      debugPrint('✓ Theme verified: isDarkMode=$_isDarkMode');
    } catch (e) {
      debugPrint('⚠ Failed to verify theme preference: $e');
    }
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _saveThemePreference();
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _saveThemePreference();
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
      debugPrint('✓ Theme saved: isDarkMode=$_isDarkMode');
    } catch (e) {
      debugPrint('⚠ Failed to save theme preference: $e');
    }
  }
}
