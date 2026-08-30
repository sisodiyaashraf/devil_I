import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0A0A0B);
  static const Color surface = Color(0xFF141416);
  static const Color bloodRed = Color(0xFF6E1414);
  static const Color fadedText = Color(0xFFB8B4AE);
  static const Color whisperWhite = Color(0xFFE8E4DE);
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.bloodRed,
        surface: AppColors.surface,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 18.0,
          height: 1.6,
          color: AppColors.fadedText,
        ),
        titleLarge: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
          color: AppColors.whisperWhite,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.whisperWhite,
          side: const BorderSide(color: AppColors.bloodRed, width: 0.6),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          ),
        ),
      ),
    );
  }
}
