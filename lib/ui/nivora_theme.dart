import 'package:flutter/material.dart';

class NivoraTheme {
  static const Color midnightVoid = Color(0xFF0B0F19);
  static const Color cardSurface = Color(0xFF151D2A);
  static const Color moonGlow = Color(0xFFFFF7D6);
  static const Color indigoAccent = Color(0xFF6366F1);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        fontFamily: 'AppFont',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: midnightVoid,
        colorScheme: const ColorScheme.dark(
          primary: moonGlow,
          secondary: indigoAccent,
          surface: cardSurface,
        ),
      );
}
