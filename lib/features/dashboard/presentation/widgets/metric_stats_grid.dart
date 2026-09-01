import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/dashboard_metrics.dart';

/// 2-Column Metric Stats Grid strictly matching Stitch brief (`dashboard/code.html`)
class MetricStatsGrid extends StatelessWidget {
  final DashboardMetrics? metrics;
  final VoidCallback? onOrdersTapped;
  final VoidCallback? onPayoutsTapped;

  const MetricStatsGrid({
    super.key,
    this.metrics,
    this.onOrdersTapped,
    this.onPayoutsTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDark;

    final totalOrders = metrics?.totalOrdersToday ?? 48;
    final totalPayouts = metrics?.nextPayoutAmount ?? 850.00;

    return Row(
      children: [
        // Left Card: Total Orders
        Expanded(
          child: GestureDetector(
            onTap: onOrdersTapped,
            child: Container(
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppRadius.md,
                border: Border.all(color: colors.borderSubtle),
                boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 20,
                        color: colors.textSecondary,
                      ),
                      AppSpacing.hGap8,
                      Text(
                        'Total Orders',
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vGap12,
                  Text(
                    '$totalOrders',
                    style: AppTypography.headlineLarge.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: colors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        AppSpacing.hGap14,

        // Right Card: Total Payouts
        Expanded(
          child: GestureDetector(
            onTap: onPayoutsTapped,
            child: Container(
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppRadius.md,
                border: Border.all(color: colors.borderSubtle),
                boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 20,
                        color: colors.textSecondary,
                      ),
                      AppSpacing.hGap8,
                      Text(
                        'Total Payouts',
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vGap12,
                  Text(
                    Formatters.formatCurrency(totalPayouts),
                    style: AppTypography.headlineLarge.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: colors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
