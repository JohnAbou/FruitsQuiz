import 'dart:convert';
import 'package:android_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService with ChangeNotifier {
  static const String defaultTheme = 'lemon-theme';
  static const String defaultBackground = 'none';
  static const String themeKey = 'userTheme';
  static const String backgroundKey = 'userBackground';

  String _currentTheme = defaultTheme;
  String _currentBackground = defaultBackground;

  String get currentTheme => _currentTheme;
  String get currentBackground => _currentBackground;

  final AuthService authService;
  final String baseUrl;

  PreferencesService({required this.authService, required this.baseUrl}) {
    _initializePreferences();

    authService.onPreferencesSubject.subscribe((preferences) {
      _applyTheme(preferences.theme);
      _applyBackground(preferences.background);
    });
  }

  Future<void> _initializePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _applyTheme(prefs.getString(themeKey) ?? defaultTheme);
    _applyBackground(prefs.getString(backgroundKey) ?? defaultBackground);
  }

  Future<void> _saveTheme(String theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(themeKey, theme);
  }

  Future<void> _saveBackground(String background) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(backgroundKey, background);
  }

  void _applyTheme(String theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  void _applyBackground(String background) {
    _currentBackground = background;
    notifyListeners();
  }

  Future<void> setTheme(String theme) async {
    _applyTheme(theme);
    await _saveTheme(theme);

    await http.put(
      Uri.parse('$baseUrl/themes'),
      headers: _getSessionIdHeaders(),
      body: jsonEncode({'theme': theme}),
    );
  }

  Future<void> setBackground(String background) async {
    _applyBackground(background);
    await _saveBackground(background);

    await http.put(
      Uri.parse('$baseUrl/background'),
      headers: _getSessionIdHeaders(),
      body: jsonEncode({'background': background}),
    );
  }

  Future<void> loadUserTheme() async {
    final url = Uri.parse('$baseUrl/themes');
    final response = await http.get(url, headers: _getSessionIdHeaders());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String theme = data['theme'] ?? defaultTheme;
      await _saveTheme(theme);
      _applyTheme(theme);
    } else {
      await _saveTheme(defaultTheme);
      _applyTheme(defaultTheme);
    }
  }

  Future<void> loadUserBackground() async {
    final url = Uri.parse('$baseUrl/background');
    final response = await http.get(url, headers: _getSessionIdHeaders());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String background = data['background'] ?? defaultBackground;
      await _saveBackground(background);
      _applyBackground(background);
    } else {
      await _saveBackground(defaultBackground);
      _applyBackground(defaultBackground);
    }
  }

  Map<String, String> _getSessionIdHeaders() {
    return {
      'Content-Type': 'application/json',
      'x-session-id': authService.getSessionId(),
    };
  }
}