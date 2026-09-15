import 'package:flutter/material.dart';

class NivoraPalette {
  static const bg = Color(0xFF0A0B14);
  static const surface = Color(0xFF121422);
  static const edge = Color(0xFF1D2036);
  static const accent = Color(0xFF818CF8);
  static const accent2 = Color(0xFFC7D2FE);
  static const ink = Color(0xFFEEF2FF);
  static const inkMuted = Color(0xFF8186A2);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'AppFont',
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: accent,
        secondary: accent2,
        onSurface: ink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: ink,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: accent,
        unselectedLabelColor: inkMuted,
        indicatorColor: accent,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
      ),
    );
  }
}
