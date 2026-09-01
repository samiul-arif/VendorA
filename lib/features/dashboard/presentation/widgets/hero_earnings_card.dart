import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/dashboard_metrics.dart';

/// Hero Earnings Card strictly matching Stitch brief (`dashboard/code.html`)
/// with Gradient Background, Large Typography, Growth Chip, Mini Bar Chart, and Analytics Trigger.
class HeroEarningsCard extends StatelessWidget {
  final DashboardMetrics? metrics;
  final VoidCallback? onAnalyticsTapped;

  const HeroEarningsCard({
    super.key,
    this.metrics,
    this.onAnalyticsTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final earnings = metrics?.totalEarningsToday ?? 1240.50;
    final growth = metrics?.earningsGrowthPercentage ?? 12.0;

    return Container(
      padding: AppSpacing.cardPaddingLg,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,          // #B90058
            AppColors.primaryContainer, // #E21B70
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lg,
        boxShadow: AppShadows.heroGlow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label: Today's Earnings
          Text(
            'Today\'s Earnings',
            style: AppTypography.bodyMedium.copyWith(
              color: colors.textInverse.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),

          AppSpacing.vGap8,

          // Amount + Growth Pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Formatters.formatCurrency(earnings),
                style: AppTypography.displayMedium.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: colors.textInverse,
                  letterSpacing: -0.6,
                ),
              ),
              AppSpacing.hGap10,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.textInverse.withValues(alpha: 0.22),
                  borderRadius: AppRadius.sm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 14,
                      color: colors.textInverse,
                    ),
                    AppSpacing.hGap4,
                    Text(
                      '+${growth.toStringAsFixed(0)}%',
                      style: AppTypography.labelSmall.copyWith(
                        color: colors.textInverse,
                        fontWeight: FontWeight.w800,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          AppSpacing.vGap2,
          Text(
            'vs yesterday',
            style: AppTypography.bodySmall.copyWith(
              color: colors.textInverse.withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          AppSpacing.vGap16,

          // Mini Bar Chart & View Analytics Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // "View Analytics" Pill Button
              InkWell(
                onTap: onAnalyticsTapped,
                borderRadius: AppRadius.full,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.textInverse,
                    borderRadius: AppRadius.full,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Analytics',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: colors.primary,
                        ),
                      ),
                      AppSpacing.hGap4,
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 15,
                        color: colors.primary,
                      ),
                    ],
                  ),
                ),
              ),

              // 5-Bar Mini Chart Graphic
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildMiniBar(height: 14, opacity: 0.4, color: colors.textInverse),
                  const SizedBox(width: 5),
                  _buildMiniBar(height: 22, opacity: 0.4, color: colors.textInverse),
                  const SizedBox(width: 5),
                  _buildMiniBar(height: 30, opacity: 0.5, color: colors.textInverse),
                  const SizedBox(width: 5),
                  _buildMiniBar(height: 38, opacity: 0.7, color: colors.textInverse),
                  const SizedBox(width: 5),
                  _buildMiniBar(height: 48, opacity: 1.0, color: colors.textInverse),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBar({
    required double height,
    required double opacity,
    required Color color,
  }) {
    return Container(
      width: 14,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: opacity),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
      ),
    );
  }
}
