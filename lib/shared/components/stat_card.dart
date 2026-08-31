import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import 'app_card.dart';

// Analytics & Summary Metric Card (modern_ui_arif POS/Analytics Style)
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? trendText;
  final bool isTrendPositive;
  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.trendText,
    this.isTrendPositive = true,
    required this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryIconColor = iconColor ?? AppColors.primary;
    final primaryIconBg = iconBackgroundColor ??
        (isDark ? const Color(0xFF381223) : AppColors.primaryTint);

    return AppCard(
      onTap: onTap,
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primaryIconBg,
                  borderRadius: AppRadius.md,
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: primaryIconColor,
                ),
              ),
              if (trendText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isTrendPositive
                        ? (isDark ? const Color(0xFF0F3A2E) : AppColors.statusSuccessBg)
                        : (isDark ? const Color(0xFF3B1414) : AppColors.statusErrorBg),
                    borderRadius: AppRadius.full,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isTrendPositive ? Icons.trending_up : Icons.trending_down,
                        size: 14,
                        color: isTrendPositive
                            ? AppColors.statusSuccess
                            : AppColors.statusError,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trendText!,
                        style: AppTypography.labelSmall.copyWith(
                          color: isTrendPositive
                              ? (isDark ? const Color(0xFF34D399) : const Color(0xFF059669))
                              : (isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626)),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          AppSpacing.vGap16,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.titleSmall.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppSpacing.vGap4,
              Text(
                value,
                style: AppTypography.statValue.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              if (subtitle != null) ...[
                AppSpacing.vGap4,
                Text(
                  subtitle!,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
