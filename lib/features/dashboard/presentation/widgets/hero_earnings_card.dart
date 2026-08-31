import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/dashboard_metrics.dart';

// Hero Net Earnings Card with Food-Tech Gradient & Performance Badges (Screenshot 4 Matching)
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
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE21B70),
            Color(0xFFD81B60),
            Color(0xFFC0155C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE21B70).withValues(alpha: 0.35),
            offset: const Offset(0, 12),
            blurRadius: 28,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Badge Matching Screenshot 4: TODAY'S OVERVIEW
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: AppRadius.full,
              ),
              child: Text(
                "TODAY'S OVERVIEW",
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 0.8,
                ),
              ),
            ),

            AppSpacing.vGap16,

            // Primary Revenue Amount
            Text(
              Formatters.formatCurrency(earnings),
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.8,
              ),
            ),

            const SizedBox(height: 4),

            // Subtext: Total Net Revenue (+14.2% vs yesterday)
            Text(
              'Total Net Revenue (+${growth.toStringAsFixed(1)}% vs yesterday)',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            AppSpacing.vGap20,

            // Sub-Metrics Row Matching Screenshot 4: 24 Orders | $59.18 Avg Ticket | 4.9 ★ Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildSubMetric(
                  value: '$ordersCount',
                  label: 'Orders',
                ),
                _buildMetricDivider(),
                _buildSubMetric(
                  value: Formatters.formatCurrency(avgTicket),
                  label: 'Avg Ticket',
                ),
                _buildMetricDivider(),
                _buildSubMetric(
                  value: '$rating ★',
                  label: 'Rating',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubMetric({required String value, required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricDivider() {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white.withValues(alpha: 0.25),
    );
  }
}
