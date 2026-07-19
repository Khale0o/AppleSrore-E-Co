import 'package:flutter/material.dart';

abstract final class StoreColors {
  static const background = Color(0xFFF7F7F9);
  static const surface = Colors.white;
  static const ink = Color(0xFF171719);
  static const muted = Color(0xFF77777F);
  static const line = Color(0xFFE7E7EB);
  static const red = Color(0xFFE32636);
  static const softRed = Color(0xFFFFECEE);
}

abstract final class StoreThemeV2 {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: StoreColors.red,
      brightness: Brightness.light,
      surface: StoreColors.surface,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        primary: StoreColors.red,
        onPrimary: Colors.white,
        surface: StoreColors.surface,
        onSurface: StoreColors.ink,
        outlineVariant: StoreColors.line,
      ),
      scaffoldBackgroundColor: StoreColors.background,
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          color: StoreColors.ink,
          fontSize: 34,
          height: 1.05,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.2,
        ),
        headlineSmall: TextStyle(
          color: StoreColors.ink,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        titleMedium: TextStyle(
          color: StoreColors.ink,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(color: StoreColors.muted, height: 1.45),
        labelLarge: TextStyle(fontWeight: FontWeight.w700),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: StoreColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: StoreColors.line),
        ),
      ),
      cardTheme: CardThemeData(
        color: StoreColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: StoreColors.line),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: StoreColors.softRed,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? StoreColors.red
                : StoreColors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
