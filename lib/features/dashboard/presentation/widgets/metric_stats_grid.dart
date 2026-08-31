import 'package:flutter/material.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/dashboard_metrics.dart';

/// 2-Column Metric Stats Grid matching Stitch brief (`dashboard/code.html`)
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

    final totalOrders = metrics?.totalOrdersToday ?? 48;
    final totalPayouts = metrics?.nextPayoutAmount ?? 850.00;

    return Row(
      children: [
        // Left Card: Total Orders
        Expanded(
          child: GestureDetector(
            onTap: onOrdersTapped,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.borderSubtle),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF15171C).withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
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
                      const SizedBox(width: 8),
                      Text(
                        'Total Orders',
                        style: TextStyle(
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
                    style: TextStyle(
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

        const SizedBox(width: 14),

        // Right Card: Total Payouts
        Expanded(
          child: GestureDetector(
            onTap: onPayoutsTapped,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.borderSubtle),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF15171C).withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
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
                      const SizedBox(width: 8),
                      Text(
                        'Total Payouts',
                        style: TextStyle(
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
                    style: TextStyle(
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
