import 'package:flutter/material.dart';

final ThemeData lemonTheme = ThemeData(
  useMaterial3: false,
  fontFamily: 'Roboto',
  colorScheme: ColorScheme.light(
    primary: Colors.teal,
    secondary: Colors.lime[600]!,
    error: Colors.green[700]!,
    surface: const Color(0xFFDFFFDE),
  ),
  scaffoldBackgroundColor: const Color(0xFFDFFFDE),
  textTheme: const TextTheme().apply(
    fontFamily: 'Roboto',
    bodyColor: Colors.black87,
    displayColor: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.teal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      textStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: Colors.white,
  ),
);

final ThemeData orangesTheme = ThemeData(
  useMaterial3: false,
  fontFamily: 'Roboto',
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFFB8C00),
    secondary: Color(0xFFFF9800),
    error: Color(0xFFFF5722),
    surface: Color(0xFFFFE9D6),
  ),
  scaffoldBackgroundColor: const Color(0xFFFFE9D6),
  textTheme: const TextTheme().apply(
    fontFamily: 'Roboto',
    bodyColor: Colors.black87,
    displayColor: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFFFB8C00),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      textStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: Colors.white,
  ),
);

final ThemeData strawberriesTheme = ThemeData(
  useMaterial3: false,
  fontFamily: 'Roboto',
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFF44336),
    secondary: Color(0xFFEF5350),
    error: Color(0xFFD32F2F),
    surface: Color(0xFFFFD6DF),
  ),
  scaffoldBackgroundColor: const Color(0xFFFFD6DF),
  textTheme: const TextTheme().apply(
    fontFamily: 'Roboto',
    bodyColor: Colors.black87,
    displayColor: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFFF44336),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      textStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: Colors.white,
  ),
);

final ThemeData blueberriesTheme = ThemeData(
  useMaterial3: false,
  fontFamily: 'Roboto',
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2196F3),
    secondary: Color(0xFF42A5F5),
    error: Color(0xFF607D8B),
    surface: Color(0xFFD6ECFF),
  ),
  scaffoldBackgroundColor: const Color(0xFFD6ECFF),
  textTheme: const TextTheme().apply(
    fontFamily: 'Roboto',
    bodyColor: Colors.black87,
    displayColor: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFF2196F3),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      textStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: Colors.white,
  ),
);

final ThemeData watermelonTheme = ThemeData(
  useMaterial3: false,
  fontFamily: 'Roboto',
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF3F9142),
    secondary: const Color(0xFFFF7676),
    error: Colors.red,
    surface: const Color(0xFFE6F5E6),
  ),
  scaffoldBackgroundColor: const Color(0xFFE6F5E6),
  textTheme: const TextTheme().apply(
    fontFamily: 'Roboto',
    bodyColor: Colors.black87,
    displayColor: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFF3F9142),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      textStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: Colors.white,
  ),
);
