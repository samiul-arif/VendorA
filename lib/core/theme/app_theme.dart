import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_semantic_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

/// Centralized ThemeData Configuration
/// Combines modern_ui_arif (Card-first architecture, black pill CTAs, soft canvas)
/// with ui-ux-pro-max (Strict token usage, WCAG 4.5:1 contrast, tap feedback).
class AppTheme {
  AppTheme._();

  // Light Theme
  static ThemeData get lightTheme {
    final textTheme = AppTypography.createTextTheme(isDark: false);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.lightCanvas,
      canvasColor: AppColors.lightCanvas,
      cardColor: AppColors.lightSurface,
      dividerColor: AppColors.lightDivider,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textInverse,
        primaryContainer: AppColors.primaryTint,
        onPrimaryContainer: AppColors.primary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textInverse,
        secondaryContainer: AppColors.secondaryTint,
        surface: AppColors.lightSurface,
        onSurface: AppColors.textPrimaryLight,
        surfaceContainerHighest: AppColors.lightSurfaceSubtle,
        error: AppColors.statusError,
        onError: AppColors.textInverse,
        outline: AppColors.lightBorder,
      ),

      // Typography
      textTheme: textTheme,
      fontFamily: AppTypography.fontFamily,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimaryLight,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // Card Theme (modern_ui_arif: High Radius Cards, White on Muted Canvas)
      cardTheme: const CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(color: AppColors.lightBorder, width: 1.0),
        ),
      ),

      // Primary Button Theme (modern_ui_arif: Solid Near-Black Pill CTA)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ctaPrimary,
          foregroundColor: AppColors.ctaPrimaryText,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: AppSpacing.buttonPadding,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: AppTypography.buttonLarge,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimaryLight,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: AppSpacing.buttonPadding,
          side: const BorderSide(color: AppColors.lightBorder, width: 1.5),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: AppTypography.buttonLarge.copyWith(color: AppColors.textPrimaryLight),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: AppTypography.buttonMedium.copyWith(color: AppColors.primary),
        ),
      ),

      // Input Decoration Theme (Soft rounded inputs with clear feedback)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMutedLight),
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
        prefixIconColor: AppColors.textSecondaryLight,
        suffixIconColor: AppColors.textSecondaryLight,
        border: const OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.lightBorder, width: 1.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.lightBorder, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.primary, width: 2.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.statusError, width: 1.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.statusError, width: 2.0),
        ),
      ),

      // Dialog Theme
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
        showDragHandle: true,
        dragHandleColor: AppColors.lightBorder,
      ),

      // Switch Theme (Vibrant primary toggle for shop status)
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightSurface;
          }
          return AppColors.textMutedLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.lightBorder;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.lightDivider,
        thickness: 1.0,
        space: 1.0,
      ),

      // Semantic Theme Extensions
      extensions: const [
        AppSemanticColors.light,
      ],
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    final textTheme = AppTypography.createTextTheme(isDark: true);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkCanvas,
      canvasColor: AppColors.darkCanvas,
      cardColor: AppColors.darkSurface,
      dividerColor: AppColors.darkDivider,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.textInverse,
        primaryContainer: Color(0xFF4A0A26),
        onPrimaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textInverse,
        secondaryContainer: Color(0xFF0F3A30),
        surface: AppColors.darkSurface,
        onSurface: AppColors.textPrimaryDark,
        surfaceContainerHighest: AppColors.darkSurfaceSubtle,
        error: AppColors.statusError,
        onError: AppColors.textInverse,
        outline: AppColors.darkBorder,
      ),

      // Typography
      textTheme: textTheme,
      fontFamily: AppTypography.fontFamily,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimaryDark,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
      ),

      // Primary Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.textPrimaryDark,
          foregroundColor: AppColors.ctaPrimary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: AppSpacing.buttonPadding,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: AppTypography.buttonLarge.copyWith(color: AppColors.ctaPrimary),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimaryDark,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: AppSpacing.buttonPadding,
          side: const BorderSide(color: AppColors.darkBorder, width: 1.5),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: AppTypography.buttonLarge.copyWith(color: AppColors.textPrimaryDark),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: AppTypography.buttonMedium.copyWith(color: AppColors.primaryLight),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMutedDark),
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
        prefixIconColor: AppColors.textSecondaryDark,
        suffixIconColor: AppColors.textSecondaryDark,
        border: const OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.primaryLight, width: 2.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.statusError, width: 1.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.statusError, width: 2.0),
        ),
      ),

      // Dialog Theme
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
        showDragHandle: true,
        dragHandleColor: AppColors.darkBorder,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.darkSurface;
          }
          return AppColors.textMutedDark;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return AppColors.darkBorder;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1.0,
        space: 1.0,
      ),

      // Semantic Theme Extensions
      extensions: const [
        AppSemanticColors.dark,
      ],
    );
  }
}
