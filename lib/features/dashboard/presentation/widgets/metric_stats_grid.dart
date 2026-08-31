import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/stat_card.dart';
import '../../domain/models/dashboard_metrics.dart';

// 2-Column Responsive Metric Stats Grid
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
    final activeOrders = metrics?.activeOrdersCount ?? 18;
    final nextPayout = metrics?.nextPayoutAmount ?? 8940.00;

    return Row(
      children: [
        // Active Orders Stat Card
        Expanded(
          child: StatCard(
            title: 'Active Orders',
            value: '$activeOrders',
            icon: Icons.receipt_long_rounded,
            iconColor: AppColors.primary,
            iconBackgroundColor: AppColors.primaryTint,
            trendText: '+3 incoming',
            isPositiveTrend: true,
            onTap: onOrdersTapped,
          ),
        ),

        AppSpacing.hGap12,

        // Next Payout Stat Card
        Expanded(
          child: StatCard(
            title: 'Next Payout',
            value: Formatters.formatCurrency(nextPayout),
            icon: Icons.account_balance_wallet_rounded,
            iconColor: AppColors.secondary,
            iconBackgroundColor: AppColors.secondaryTint,
            trendText: 'Weekly',
            isPositiveTrend: true,
            onTap: onPayoutsTapped,
          ),
        ),
      ],
    );
  }
}
