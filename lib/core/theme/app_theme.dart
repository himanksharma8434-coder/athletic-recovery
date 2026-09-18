import 'package:flutter/material.dart';
import 'recova_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: RecovaColors.canvasBase,
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        surface: RecovaColors.canvasBase,
        onSurface: RecovaColors.onSurface,
        onSurfaceVariant: RecovaColors.onSurfaceVariant,
        primary: RecovaColors.recoveryEmerald,
        onPrimary: Color(0xFF00391E),
        primaryContainer: RecovaColors.recoveryEmeraldContainer,
        secondary: RecovaColors.restorativeAzure,
        onSecondary: Color(0xFF003543),
        secondaryContainer: RecovaColors.restorativeAzureContainer,
        tertiary: RecovaColors.kineticAmberGold,
        error: RecovaColors.stressCrimson,
        outline: RecovaColors.borderMedium,
        outlineVariant: RecovaColors.borderSubtle,
      ),
      cardTheme: const CardThemeData(
        color: RecovaColors.surfaceElevation1,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: RecovaColors.borderSubtle),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: RecovaColors.textPrimary,
        ),
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w300,
          letterSpacing: -1.5,
          color: RecovaColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          letterSpacing: -1.0,
          color: RecovaColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          color: RecovaColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: RecovaColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: RecovaColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: RecovaColors.textSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: RecovaColors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: RecovaColors.textTertiary,
        ),
        labelLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
          color: RecovaColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: RecovaColors.textTertiary,
        ),
      ),
    );
  }
}
