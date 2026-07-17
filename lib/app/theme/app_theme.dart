import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.surface,
      primary: AppColors.coolAccent,
      onPrimary: AppColors.background,
      error: AppColors.error,
    ),
    textTheme: const TextTheme(
      displayLarge: AppTypography.display,
      headlineMedium: AppTypography.headline,
      titleLarge: AppTypography.title,
      bodyLarge: AppTypography.body,
      labelLarge: AppTypography.label,
      bodySmall: AppTypography.caption,
    ),
    dividerColor: AppColors.borderSubtle,
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surfaceElevated,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceElevated,
    ),
  );
}
