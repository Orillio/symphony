import 'package:flutter/material.dart';

class AppThemes {
  static final darkTheme = ThemeData(

    primaryColorDark: const Color(0xFF6b6b6b),
    primaryColorLight: Colors.white,

    iconTheme: IconThemeData(
      color: Color(0xFF98989f)
    ),

    scaffoldBackgroundColor: Colors.black,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1b1b1d),
      selectedItemColor: Color(0xFF0A7EF3),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1b1b1d)
    ),

  );
}