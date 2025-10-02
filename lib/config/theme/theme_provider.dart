import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  static const String _themeKey = 'isDarkMode';

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  // Saved theme ni yuklash
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
    _updateSystemUI();
  }

  // Theme ni o'zgartirish
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
    _updateSystemUI();
  }

  // System UI ni yangilash
  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: _isDarkMode ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: _isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: _isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );
  }

  // Theme data ni olish
  ThemeData get themeData {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  // Light Theme
  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6C5CE7),
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5F5F5),
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF6C5CE7),
      unselectedItemColor: Colors.grey,
      elevation: 0,
    ),
    cardColor: Colors.white,
    dividerColor: Colors.grey[300],
  );

  // Dark Theme
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6C5CE7),
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF1A1A1A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF2A2A2A),
      selectedItemColor: Color(0xFF6C5CE7),
      unselectedItemColor: Colors.grey,
      elevation: 0,
    ),
    cardColor: const Color(0xFF2A2A2A),
    dividerColor: Colors.grey[800],
  );
}