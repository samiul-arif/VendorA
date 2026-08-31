import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

// Hero Brand Header for Authentication Screens (modern_ui_arif Brand Identity)
class VendorBrandHeader extends StatelessWidget {
  const VendorBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Brand Icon Capsule with Gradient Accent
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                offset: const Offset(0, 8),
                blurRadius: 20,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.storefront_rounded,
              size: 38,
              color: Colors.white,
            ),
          ),
        ),

        AppSpacing.vGap20,

        // Tagline Pill Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF4A0A26) : AppColors.primaryTint,
            borderRadius: AppRadius.full,
          ),
          child: Text(
            'FOODPANDA MERCHANT PARTNER',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ),

        AppSpacing.vGap12,

        // Welcome Headline
        Text(
          'Welcome Back!',
          style: AppTypography.displayMedium.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),

        AppSpacing.vGap4,

        // Subtitle
        Text(
          'Sign in to manage your store, orders & sales',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
