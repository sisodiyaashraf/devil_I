import 'package:flutter/material.dart';

class AppColors {
  // Core background
  static const Color background = Color(0xFF020408);
  static const Color surface = Color(0xFF0A0E14);
  static const Color surfaceElevated = Color(0xFF111720);

  // Primary accent — electric cyan/teal
  static const Color terminalGreen = Color(0xFF00E5FF);
  static const Color terminalGreenDim = Color(0xFF00B8D4);

  // Corruption accent — deep crimson / neon red
  static const Color corruptRed = Color(0xFFFF1744);
  static const Color corruptRedDim = Color(0xFFB71C1C);

  // Neutral
  static const Color staticGray = Color(0xFF37474F);
  static const Color mutedText = Color(0xFF546E7A);

  // Glow helpers (used for BoxShadow)
  static const Color glowCyan = Color(0xFF00E5FF);
  static const Color glowRed = Color(0xFFFF1744);

  // Warning / mid-level corruption — amber
  static const Color warningAmber = Color(0xFFFFAB00);
}

class AppTheme {
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.terminalGreen,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.terminalGreen,
      secondary: AppColors.corruptRed,
      surface: AppColors.surface,
      error: AppColors.corruptRed,
      onSurface: AppColors.terminalGreen,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: colorScheme,
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'monospace',
          fontSize: 16.0,
          height: 1.5,
          color: AppColors.terminalGreen,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13.0,
          height: 1.4,
          color: AppColors.terminalGreenDim,
        ),
        titleLarge: TextStyle(
          fontFamily: 'monospace',
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 3.0,
        ),
        labelSmall: TextStyle(
          fontFamily: 'monospace',
          fontSize: 10.0,
          letterSpacing: 2.0,
          color: AppColors.mutedText,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.terminalGreen,
          side: const BorderSide(color: AppColors.terminalGreen, width: 1.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          ),
        ),
      ),
    );
  }
}

/// Helper to create a neon glow shadow list.
List<BoxShadow> neonGlow(Color color, {double blur = 12.0, double spread = 0.0}) {
  return [
    BoxShadow(color: color.withValues(alpha: 0.55), blurRadius: blur, spreadRadius: spread),
    BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: blur * 2.5, spreadRadius: spread),
  ];
}
