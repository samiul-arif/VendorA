import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Semantic Theme Tokens Extension
/// Follows Flutter's production-grade ThemeExtension architecture.
/// Ensures complete light/dark mode parity without hardcoded color checks.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color primary;
  final Color primaryContainer;
  final Color primaryLight;
  final Color secondary;
  final Color secondaryContainer;
  final Color canvas;
  final Color surface;
  final Color surfaceLow;
  final Color surfaceSubtle;
  final Color surfaceHigh;
  final Color border;
  final Color borderSubtle;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textInverse;
  final Color success;
  final Color successBg;
  final Color warning;
  final Color warningBg;
  final Color error;
  final Color errorBg;
  final Color info;
  final Color infoBg;
  final Color ctaPrimary;
  final Color ctaPrimaryText;
  final Color ctaSecondary;
  final Color ctaSecondaryText;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color navBarBg;
  final Color navBarBorder;

  // Order Flow Status Tokens
  final Color orderPending;
  final Color orderPendingBg;
  final Color orderAccepted;
  final Color orderAcceptedBg;
  final Color orderPreparing;
  final Color orderPreparingBg;
  final Color orderReady;
  final Color orderReadyBg;
  final Color orderDelivered;
  final Color orderDeliveredBg;
  final Color orderCancelled;
  final Color orderCancelledBg;

  const AppSemanticColors({
    required this.primary,
    required this.primaryContainer,
    required this.primaryLight,
    required this.secondary,
    required this.secondaryContainer,
    required this.canvas,
    required this.surface,
    required this.surfaceLow,
    required this.surfaceSubtle,
    required this.surfaceHigh,
    required this.border,
    required this.borderSubtle,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textInverse,
    required this.success,
    required this.successBg,
    required this.warning,
    required this.warningBg,
    required this.error,
    required this.errorBg,
    required this.info,
    required this.infoBg,
    required this.ctaPrimary,
    required this.ctaPrimaryText,
    required this.ctaSecondary,
    required this.ctaSecondaryText,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.navBarBg,
    required this.navBarBorder,
    required this.orderPending,
    required this.orderPendingBg,
    required this.orderAccepted,
    required this.orderAcceptedBg,
    required this.orderPreparing,
    required this.orderPreparingBg,
    required this.orderReady,
    required this.orderReadyBg,
    required this.orderDelivered,
    required this.orderDeliveredBg,
    required this.orderCancelled,
    required this.orderCancelledBg,
  });

  /// Standard Light Theme Semantic Tokens
  static const AppSemanticColors light = AppSemanticColors(
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryTint,
    primaryLight: AppColors.primaryLight,
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.secondaryContainer,
    canvas: AppColors.lightCanvas,
    surface: AppColors.lightSurface,
    surfaceLow: AppColors.lightSurfaceLow,
    surfaceSubtle: AppColors.lightSurfaceSubtle,
    surfaceHigh: AppColors.lightSurfaceHigh,
    border: AppColors.lightBorder,
    borderSubtle: AppColors.lightDivider,
    divider: AppColors.lightDivider,
    textPrimary: AppColors.textPrimaryLight,
    textSecondary: AppColors.textSecondaryLight,
    textMuted: AppColors.textMutedLight,
    textInverse: AppColors.textInverseLight,
    success: AppColors.statusSuccess,
    successBg: AppColors.statusSuccessBgLight,
    warning: AppColors.statusWarning,
    warningBg: AppColors.statusWarningBgLight,
    error: AppColors.statusError,
    errorBg: AppColors.statusErrorBgLight,
    info: AppColors.statusInfo,
    infoBg: AppColors.statusInfoBgLight,
    ctaPrimary: AppColors.ctaPrimaryLight,
    ctaPrimaryText: AppColors.ctaPrimaryLightText,
    ctaSecondary: AppColors.ctaSecondaryLight,
    ctaSecondaryText: AppColors.ctaSecondaryLightText,
    shimmerBase: AppColors.shimmerBaseLight,
    shimmerHighlight: AppColors.shimmerHighlightLight,
    navBarBg: AppColors.navBarBgLight,
    navBarBorder: AppColors.navBarBorderLight,
    orderPending: AppColors.orderPending,
    orderPendingBg: AppColors.statusWarningBgLight,
    orderAccepted: AppColors.orderAccepted,
    orderAcceptedBg: AppColors.statusInfoBgLight,
    orderPreparing: AppColors.orderPreparing,
    orderPreparingBg: Color(0xFFF5F3FF),
    orderReady: AppColors.orderReady,
    orderReadyBg: AppColors.statusSuccessBgLight,
    orderDelivered: AppColors.orderDelivered,
    orderDeliveredBg: AppColors.statusSuccessBgLight,
    orderCancelled: AppColors.orderCancelled,
    orderCancelledBg: AppColors.statusErrorBgLight,
  );

  /// Standard Dark Theme Semantic Tokens
  static const AppSemanticColors dark = AppSemanticColors(
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryTintDark,
    primaryLight: AppColors.primaryLight,
    secondary: AppColors.secondaryContainer,
    secondaryContainer: AppColors.secondaryTintDark,
    canvas: AppColors.darkCanvas,
    surface: AppColors.darkSurface,
    surfaceLow: AppColors.darkSurfaceElevated,
    surfaceSubtle: AppColors.darkSurfaceHighest,
    surfaceHigh: AppColors.darkSurfaceHighest,
    border: AppColors.darkBorder,
    borderSubtle: AppColors.darkDivider,
    divider: AppColors.darkDivider,
    textPrimary: AppColors.textPrimaryDark,
    textSecondary: AppColors.textSecondaryDark,
    textMuted: AppColors.textMutedDark,
    textInverse: AppColors.textPrimaryLight,
    success: AppColors.statusSuccess,
    successBg: AppColors.statusSuccessBgDark,
    warning: AppColors.statusWarning,
    warningBg: AppColors.statusWarningBgDark,
    error: AppColors.statusError,
    errorBg: AppColors.statusErrorBgDark,
    info: AppColors.statusInfo,
    infoBg: AppColors.statusInfoBgDark,
    ctaPrimary: AppColors.ctaPrimaryDark,
    ctaPrimaryText: AppColors.ctaPrimaryDarkText,
    ctaSecondary: AppColors.ctaSecondaryDark,
    ctaSecondaryText: AppColors.ctaSecondaryDarkText,
    shimmerBase: AppColors.shimmerBaseDark,
    shimmerHighlight: AppColors.shimmerHighlightDark,
    navBarBg: AppColors.navBarBgDark,
    navBarBorder: AppColors.navBarBorderDark,
    orderPending: AppColors.orderPending,
    orderPendingBg: AppColors.statusWarningBgDark,
    orderAccepted: AppColors.orderAccepted,
    orderAcceptedBg: AppColors.statusInfoBgDark,
    orderPreparing: AppColors.orderPreparing,
    orderPreparingBg: Color(0xFF2E1F47),
    orderReady: AppColors.orderReady,
    orderReadyBg: AppColors.statusSuccessBgDark,
    orderDelivered: AppColors.orderDelivered,
    orderDeliveredBg: AppColors.statusSuccessBgDark,
    orderCancelled: AppColors.orderCancelled,
    orderCancelledBg: AppColors.statusErrorBgDark,
  );

  @override
  ThemeExtension<AppSemanticColors> copyWith({
    Color? primary,
    Color? primaryContainer,
    Color? primaryLight,
    Color? secondary,
    Color? secondaryContainer,
    Color? canvas,
    Color? surface,
    Color? surfaceLow,
    Color? surfaceSubtle,
    Color? surfaceHigh,
    Color? border,
    Color? borderSubtle,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textInverse,
    Color? success,
    Color? successBg,
    Color? warning,
    Color? warningBg,
    Color? error,
    Color? errorBg,
    Color? info,
    Color? infoBg,
    Color? ctaPrimary,
    Color? ctaPrimaryText,
    Color? ctaSecondary,
    Color? ctaSecondaryText,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? navBarBg,
    Color? navBarBorder,
    Color? orderPending,
    Color? orderPendingBg,
    Color? orderAccepted,
    Color? orderAcceptedBg,
    Color? orderPreparing,
    Color? orderPreparingBg,
    Color? orderReady,
    Color? orderReadyBg,
    Color? orderDelivered,
    Color? orderDeliveredBg,
    Color? orderCancelled,
    Color? orderCancelledBg,
  }) {
    return AppSemanticColors(
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      primaryLight: primaryLight ?? this.primaryLight,
      secondary: secondary ?? this.secondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceLow: surfaceLow ?? this.surfaceLow,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textInverse: textInverse ?? this.textInverse,
      success: success ?? this.success,
      successBg: successBg ?? this.successBg,
      warning: warning ?? this.warning,
      warningBg: warningBg ?? this.warningBg,
      error: error ?? this.error,
      errorBg: errorBg ?? this.errorBg,
      info: info ?? this.info,
      infoBg: infoBg ?? this.infoBg,
      ctaPrimary: ctaPrimary ?? this.ctaPrimary,
      ctaPrimaryText: ctaPrimaryText ?? this.ctaPrimaryText,
      ctaSecondary: ctaSecondary ?? this.ctaSecondary,
      ctaSecondaryText: ctaSecondaryText ?? this.ctaSecondaryText,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      navBarBg: navBarBg ?? this.navBarBg,
      navBarBorder: navBarBorder ?? this.navBarBorder,
      orderPending: orderPending ?? this.orderPending,
      orderPendingBg: orderPendingBg ?? this.orderPendingBg,
      orderAccepted: orderAccepted ?? this.orderAccepted,
      orderAcceptedBg: orderAcceptedBg ?? this.orderAcceptedBg,
      orderPreparing: orderPreparing ?? this.orderPreparing,
      orderPreparingBg: orderPreparingBg ?? this.orderPreparingBg,
      orderReady: orderReady ?? this.orderReady,
      orderReadyBg: orderReadyBg ?? this.orderReadyBg,
      orderDelivered: orderDelivered ?? this.orderDelivered,
      orderDeliveredBg: orderDeliveredBg ?? this.orderDeliveredBg,
      orderCancelled: orderCancelled ?? this.orderCancelled,
      orderCancelledBg: orderCancelledBg ?? this.orderCancelledBg,
    );
  }

  @override
  ThemeExtension<AppSemanticColors> lerp(
    covariant ThemeExtension<AppSemanticColors>? other,
    double t,
  ) {
    if (other is! AppSemanticColors) return this;

    return AppSemanticColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryContainer: Color.lerp(secondaryContainer, other.secondaryContainer, t)!,
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceLow: Color.lerp(surfaceLow, other.surfaceLow, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      surfaceHigh: Color.lerp(surfaceHigh, other.surfaceHigh, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      success: Color.lerp(success, other.success, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoBg: Color.lerp(infoBg, other.infoBg, t)!,
      ctaPrimary: Color.lerp(ctaPrimary, other.ctaPrimary, t)!,
      ctaPrimaryText: Color.lerp(ctaPrimaryText, other.ctaPrimaryText, t)!,
      ctaSecondary: Color.lerp(ctaSecondary, other.ctaSecondary, t)!,
      ctaSecondaryText: Color.lerp(ctaSecondaryText, other.ctaSecondaryText, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      navBarBg: Color.lerp(navBarBg, other.navBarBg, t)!,
      navBarBorder: Color.lerp(navBarBorder, other.navBarBorder, t)!,
      orderPending: Color.lerp(orderPending, other.orderPending, t)!,
      orderPendingBg: Color.lerp(orderPendingBg, other.orderPendingBg, t)!,
      orderAccepted: Color.lerp(orderAccepted, other.orderAccepted, t)!,
      orderAcceptedBg: Color.lerp(orderAcceptedBg, other.orderAcceptedBg, t)!,
      orderPreparing: Color.lerp(orderPreparing, other.orderPreparing, t)!,
      orderPreparingBg: Color.lerp(orderPreparingBg, other.orderPreparingBg, t)!,
      orderReady: Color.lerp(orderReady, other.orderReady, t)!,
      orderReadyBg: Color.lerp(orderReadyBg, other.orderReadyBg, t)!,
      orderDelivered: Color.lerp(orderDelivered, other.orderDelivered, t)!,
      orderDeliveredBg: Color.lerp(orderDeliveredBg, other.orderDeliveredBg, t)!,
      orderCancelled: Color.lerp(orderCancelled, other.orderCancelled, t)!,
      orderCancelledBg: Color.lerp(orderCancelledBg, other.orderCancelledBg, t)!,
    );
  }
}

/// Syntactic sugar extensions on BuildContext and ThemeData
extension AppThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  bool get isDark => theme.brightness == Brightness.dark;
  AppSemanticColors get appColors =>
      theme.extension<AppSemanticColors>() ?? (isDark ? AppSemanticColors.dark : AppSemanticColors.light);
}

extension AppThemeDataExtension on ThemeData {
  bool get isDark => brightness == Brightness.dark;
  AppSemanticColors get appColors =>
      extension<AppSemanticColors>() ?? (isDark ? AppSemanticColors.dark : AppSemanticColors.light);
}
