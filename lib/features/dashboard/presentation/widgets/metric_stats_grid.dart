import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                        color: isDark ? const Color(0xFF381223) : const Color(0xFFFFF0F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),

                    // +3 new green pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F3A2E) : const Color(0xFFECFDF5),
                        borderRadius: AppRadius.full,
                      ),
                      child: const Text(
                        '+3 new',
                        style: TextStyle(
                          color: Color(0xFF059669),
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
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Active Orders',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textMutedDark : const Color(0xFF6B7280),
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
                        color: isDark ? const Color(0xFF0F3A2E) : const Color(0xFFE6F7F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.credit_card_rounded,
                          color: Color(0xFF2FBF9F),
                          size: 20,
                        ),
                      ),
                    ),

                    // Weekly blue pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                        borderRadius: AppRadius.full,
                      ),
                      child: const Text(
                        'Weekly',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
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
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Next Payout',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textMutedDark : const Color(0xFF6B7280),
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
