import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized Typography Scale for Vendor App
/// Uses Google Fonts Plus Jakarta Sans / Inter for crisp, geometric hierarchy.
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Plus Jakarta Sans';

  // Base text style generator
  static TextStyle _baseStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required double lineHeight,
    double letterSpacing = 0.0,
    required Color color,
  }) {
    try {
      return GoogleFonts.plusJakartaSans(
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: lineHeight / fontSize,
        letterSpacing: letterSpacing,
        color: color,
      );
    } catch (_) {
      return TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: lineHeight / fontSize,
        letterSpacing: letterSpacing,
        color: color,
      );
    }
  }

  // Light Theme Typography Hierarchy

  // Hero Display & Large Stats
  static TextStyle displayLarge = _baseStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w800,
    lineHeight: 40.0,
    letterSpacing: -0.5,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle displayMedium = _baseStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    lineHeight: 36.0,
    letterSpacing: -0.4,
    color: AppColors.textPrimaryLight,
  );

  // Headlines
  static TextStyle headlineLarge = _baseStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    lineHeight: 32.0,
    letterSpacing: -0.3,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle headlineMedium = _baseStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    lineHeight: 28.0,
    letterSpacing: -0.2,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle headlineSmall = _baseStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    lineHeight: 24.0,
    color: AppColors.textPrimaryLight,
  );

  // Titles & Card Headers
  static TextStyle titleLarge = _baseStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    lineHeight: 22.0,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle titleMedium = _baseStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    lineHeight: 20.0,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle titleSmall = _baseStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    lineHeight: 18.0,
    color: AppColors.textPrimaryLight,
  );

  // Body Text
  static TextStyle bodyLarge = _baseStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    lineHeight: 24.0,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle bodyMedium = _baseStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    lineHeight: 20.0,
    color: AppColors.textSecondaryLight,
  );

  static TextStyle bodySmall = _baseStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    lineHeight: 16.0,
    color: AppColors.textSecondaryLight,
  );

  // Buttons & CTAs
  static TextStyle buttonLarge = _baseStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    lineHeight: 20.0,
    letterSpacing: 0.2,
    color: AppColors.ctaPrimaryText,
  );

  static TextStyle buttonMedium = _baseStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    lineHeight: 18.0,
    letterSpacing: 0.1,
    color: AppColors.ctaPrimaryText,
  );

  static TextStyle buttonSmall = _baseStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    lineHeight: 16.0,
    color: AppColors.ctaPrimaryText,
  );

  // Badges & Micro Labels
  static TextStyle labelLarge = _baseStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w600,
    lineHeight: 16.0,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle labelMedium = _baseStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    lineHeight: 14.0,
    letterSpacing: 0.3,
    color: AppColors.textSecondaryLight,
  );

  static TextStyle labelSmall = _baseStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    lineHeight: 12.0,
    color: AppColors.textMutedLight,
  );

  // Numeric Stats & Metrics
  static TextStyle statLarge = _baseStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w800,
    lineHeight: 38.0,
    letterSpacing: -0.5,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle statMedium = _baseStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.w800,
    lineHeight: 32.0,
    letterSpacing: -0.5,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle statValue = _baseStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.w800,
    lineHeight: 32.0,
    letterSpacing: -0.5,
    color: AppColors.textPrimaryLight,
  );

  // Dark Theme TextTheme Assembly Helper
  static TextTheme createTextTheme({required bool isDark}) {
    final primaryColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return TextTheme(
      displayLarge: displayLarge.copyWith(color: primaryColor),
      displayMedium: displayMedium.copyWith(color: primaryColor),
      headlineLarge: headlineLarge.copyWith(color: primaryColor),
      headlineMedium: headlineMedium.copyWith(color: primaryColor),
      headlineSmall: headlineSmall.copyWith(color: primaryColor),
      titleLarge: titleLarge.copyWith(color: primaryColor),
      titleMedium: titleMedium.copyWith(color: primaryColor),
      titleSmall: titleSmall.copyWith(color: primaryColor),
      bodyLarge: bodyLarge.copyWith(color: primaryColor),
      bodyMedium: bodyMedium.copyWith(color: secondaryColor),
      bodySmall: bodySmall.copyWith(color: secondaryColor),
      labelLarge: labelLarge.copyWith(color: primaryColor),
      labelMedium: labelMedium.copyWith(color: secondaryColor),
      labelSmall: labelSmall.copyWith(color: secondaryColor),
    );
  }
}
