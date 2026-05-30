import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF1E1E1E),

    primaryColor: const Color(0xFF0E639C),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF252526),
      elevation: 0,
      centerTitle: false,
    ),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF0E639C),
      secondary: Color(0xFF3794FF),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  );
}
