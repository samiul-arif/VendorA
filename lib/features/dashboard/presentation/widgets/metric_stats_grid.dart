import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_card.dart';
import '../../domain/models/dashboard_metrics.dart';

// 2-Column Responsive Metric Stats Grid (Screenshot 4 Matching)
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

    final activeOrders = metrics?.activeOrdersCount ?? 18;
    final nextPayout = metrics?.nextPayoutAmount ?? 8940.00;

    return Row(
      children: [
        // Left Card: Active Orders
        Expanded(
          child: AppCard(
            onTap: onOrdersTapped,
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Pink Bag Icon Box
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: colors.primary,
                          size: 20,
                        ),
                      ),
                    ),

                    // +3 new green pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: colors.successBg,
                        borderRadius: AppRadius.full,
                      ),
                      child: Text(
                        '+3 new',
                        style: TextStyle(
                          color: colors.success,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),

                AppSpacing.vGap16,

                Text(
                  '$activeOrders',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Active Orders',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),

        AppSpacing.hGap12,

        // Right Card: Next Payout
        Expanded(
          child: AppCard(
            onTap: onPayoutsTapped,
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Mint Card Icon Box
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.infoBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.credit_card_rounded,
                          color: colors.info,
                          size: 20,
                        ),
                      ),
                    ),

                    // Weekly blue pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: colors.orderAcceptedBg,
                        borderRadius: AppRadius.full,
                      ),
                      child: Text(
                        'Weekly',
                        style: TextStyle(
                          color: colors.orderAccepted,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),

                AppSpacing.vGap16,

                Text(
                  '\$${nextPayout.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Next Payout',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
