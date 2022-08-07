import 'package:flutter/material.dart';

class AppThemes {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColorDark: const Color(0xFF6b6b6b),
    primaryColorLight: Colors.white,
    iconTheme: const IconThemeData(color: Color(0xFF98989f)),
    scaffoldBackgroundColor: Colors.black,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1b1b1d),
      selectedItemColor: Color(0xFF0A7EF3),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1b1b1d)),
  );
}

class ConstColors {
  static const Color gray = Color(0xFFADB3BC);
  static const Color appBarColor = Color(0xFF1b1b1d);
}
