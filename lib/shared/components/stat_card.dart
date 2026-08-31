import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_semantic_colors.dart';
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
    final colors = context.appColors;

    final primaryIconColor = iconColor ?? colors.primary;
    final primaryIconBg = iconBackgroundColor ?? colors.primaryContainer;

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
                    color: isTrendPositive ? colors.successBg : colors.errorBg,
                    borderRadius: AppRadius.full,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isTrendPositive ? Icons.trending_up : Icons.trending_down,
                        size: 14,
                        color: isTrendPositive ? colors.success : colors.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trendText!,
                        style: AppTypography.labelSmall.copyWith(
                          color: isTrendPositive ? colors.success : colors.error,
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
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppSpacing.vGap4,
              Text(
                value,
                style: AppTypography.statValue.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                AppSpacing.vGap4,
                Text(
                  subtitle!,
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.textMuted,
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
