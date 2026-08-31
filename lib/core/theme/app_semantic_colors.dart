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
  final Color surface;
  final Color surfaceSubtle;
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
    required this.surface,
    required this.surfaceSubtle,
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
    secondaryContainer: AppColors.secondaryTint,
    surface: AppColors.lightSurface,
    surfaceSubtle: AppColors.lightSurfaceSubtle,
    border: AppColors.lightBorder,
    borderSubtle: Color(0xFFE5E7EB),
    divider: AppColors.lightDivider,
    textPrimary: AppColors.textPrimaryLight,
    textSecondary: AppColors.textSecondaryLight,
    textMuted: AppColors.textMutedLight,
    textInverse: AppColors.textInverse,
    success: AppColors.statusSuccess,
    successBg: AppColors.statusSuccessBg,
    warning: AppColors.statusWarning,
    warningBg: AppColors.statusWarningBg,
    error: AppColors.statusError,
    errorBg: AppColors.statusErrorBg,
    info: AppColors.statusInfo,
    infoBg: AppColors.statusInfoBg,
    ctaPrimary: AppColors.ctaPrimary,
    ctaPrimaryText: AppColors.ctaPrimaryText,
    ctaSecondary: AppColors.ctaSecondary,
    ctaSecondaryText: AppColors.ctaSecondaryText,
    shimmerBase: Color(0xFFE5E7EB),
    shimmerHighlight: Color(0xFFF3F4F6),
    orderPending: AppColors.orderPending,
    orderPendingBg: Color(0xFFFFFBEB),
    orderAccepted: AppColors.orderAccepted,
    orderAcceptedBg: Color(0xFFEFF6FF),
    orderPreparing: AppColors.orderPreparing,
    orderPreparingBg: Color(0xFFF5F3FF),
    orderReady: AppColors.orderReady,
    orderReadyBg: Color(0xFFECFDF5),
    orderDelivered: AppColors.orderDelivered,
    orderDeliveredBg: Color(0xFFECFDF5),
    orderCancelled: AppColors.orderCancelled,
    orderCancelledBg: Color(0xFFFEF2F2),
  );

  /// Standard Dark Theme Semantic Tokens
  static const AppSemanticColors dark = AppSemanticColors(
    primary: AppColors.primary,
    primaryContainer: Color(0xFF2E1A2A),
    primaryLight: AppColors.primaryLight,
    secondary: AppColors.secondary,
    secondaryContainer: Color(0xFF0F3A30),
    surface: AppColors.darkSurface,
    surfaceSubtle: AppColors.darkSurfaceSubtle,
    border: AppColors.darkBorder,
    borderSubtle: Color(0xFF232A34),
    divider: AppColors.darkDivider,
    textPrimary: AppColors.textPrimaryDark,
    textSecondary: AppColors.textSecondaryDark,
    textMuted: AppColors.textMutedDark,
    textInverse: AppColors.textInverse,
    success: Color(0xFF34D399),
    successBg: Color(0xFF0F3A2E),
    warning: Color(0xFFFBBF24),
    warningBg: Color(0xFF3A2E0F),
    error: Color(0xFFF87171),
    errorBg: Color(0xFF3B1414),
    info: Color(0xFF60A5FA),
    infoBg: Color(0xFF1E293B),
    ctaPrimary: Color(0xFFFFFFFF),
    ctaPrimaryText: Color(0xFF141414),
    ctaSecondary: Color(0xFF232A34),
    ctaSecondaryText: Color(0xFFFFFFFF),
    shimmerBase: Color(0xFF1E242C),
    shimmerHighlight: Color(0xFF28303C),
    orderPending: Color(0xFFFBBF24),
    orderPendingBg: Color(0xFF3A2E0F),
    orderAccepted: Color(0xFF60A5FA),
    orderAcceptedBg: Color(0xFF1E293B),
    orderPreparing: Color(0xFFA78BFA),
    orderPreparingBg: Color(0xFF2E1F47),
    orderReady: Color(0xFF34D399),
    orderReadyBg: Color(0xFF0F3A2E),
    orderDelivered: Color(0xFF10B981),
    orderDeliveredBg: Color(0xFF0F3A2E),
    orderCancelled: Color(0xFFF87171),
    orderCancelledBg: Color(0xFF3B1414),
  );

  @override
  ThemeExtension<AppSemanticColors> copyWith({
    Color? primary,
    Color? primaryContainer,
    Color? primaryLight,
    Color? secondary,
    Color? secondaryContainer,
    Color? surface,
    Color? surfaceSubtle,
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
      surface: surface ?? this.surface,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
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
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
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
