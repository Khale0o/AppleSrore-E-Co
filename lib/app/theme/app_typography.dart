import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTypography {
  static const display = TextStyle(
    fontSize: 48,
    height: 1.02,
    letterSpacing: -2,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
  );
  static const headline = TextStyle(
    fontSize: 30,
    height: 1.12,
    letterSpacing: -1,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static const title = TextStyle(
    fontSize: 20,
    height: 1.2,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontSize: 16,
    height: 1.45,
    color: AppColors.textSecondary,
  );
  static const label = TextStyle(
    fontSize: 13,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w600,
    color: AppColors.coolAccent,
  );
  static const caption = TextStyle(
    fontSize: 12,
    height: 1.35,
    color: AppColors.textMuted,
  );
}
