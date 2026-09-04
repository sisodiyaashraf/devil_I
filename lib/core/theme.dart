import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF000000);
  static const Color terminalGreen = Color(0xFF00FF9C);
  static const Color corruptRed = Color(0xFFFF1B3C);
  static const Color surface = Color(0xFF0D0D0F);
  static const Color staticGray = Color(0xFF3A3A3D);
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.terminalGreen,
        secondary: AppColors.corruptRed,
        surface: AppColors.surface,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'monospace',
          fontSize: 16.0,
          height: 1.4,
          color: AppColors.terminalGreen,
        ),
        titleLarge: TextStyle(
          fontFamily: 'monospace',
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 2.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.terminalGreen,
          side: const BorderSide(color: AppColors.terminalGreen, width: 1.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
    );
  }
}
