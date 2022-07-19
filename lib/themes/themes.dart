import 'package:flutter/material.dart';

class AppThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1b1b1d),
      selectedItemColor: Color(0xFF0A7EF3),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1b1b1d)
    )
  );
}