import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/dashboard_metrics.dart';

// Hero Net Earnings Card with Food-Tech Gradient & Performance Badges
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
    final earnings = metrics?.totalEarningsToday ?? 1420.50;
    final growth = metrics?.earningsGrowthPercentage ?? 14.2;
    final ordersCount = metrics?.totalOrdersToday ?? 24;
    final avgTicket = metrics?.averageTicketSize ?? 59.18;
    final rating = metrics?.storeRating ?? 4.9;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppRadius.card,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.32),
            offset: const Offset(0, 10),
            blurRadius: 24,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle Ambient Background Circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tagline & Growth Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: AppRadius.full,
                      ),
                      child: Text(
                        "TODAY'S NET EARNINGS",
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.full,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_up_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '+${growth.toStringAsFixed(1)}%',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                AppSpacing.vGap16,

                // Primary Revenue Amount
                Text(
                  Formatters.formatCurrency(earnings),
                  style: AppTypography.statLarge.copyWith(
                    color: Colors.white,
                    letterSpacing: -1.0,
                  ),
                ),

                AppSpacing.vGap4,

                Text(
                  'Real-time automated revenue ledger',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),

                AppSpacing.vGap16,

                // Divider Line
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.2),
                ),

                AppSpacing.vGap12,

                // Sub-Metrics Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSubMetric(
                      label: 'Total Orders',
                      value: '$ordersCount',
                    ),
                    _buildMetricDivider(),
                    _buildSubMetric(
                      label: 'Avg Ticket',
                      value: Formatters.formatCurrency(avgTicket),
                    ),
                    _buildMetricDivider(),
                    _buildSubMetric(
                      label: 'Store Rating',
                      value: '$rating ★',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubMetric({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricDivider() {
    return Container(
      width: 1,
      height: 24,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }
}
