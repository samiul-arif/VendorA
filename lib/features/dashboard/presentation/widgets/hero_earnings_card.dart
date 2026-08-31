import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/dashboard_metrics.dart';

/// Hero Earnings Card matching Stitch brief (`dashboard/code.html`)
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
    final earnings = metrics?.totalEarningsToday ?? 1240.50;
    final growth = metrics?.earningsGrowthPercentage ?? 12.0;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFB90058), // primary
            Color(0xFFE21B70), // primary-container
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB90058).withValues(alpha: 0.25),
            offset: const Offset(0, 8),
            blurRadius: 28,
            spreadRadius: -2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Decorative Subtle Glow Circle
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
                // Label: Today's Earnings
                Text(
                  'Today\'s Earnings',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),

                const SizedBox(height: 8),

                // Amount + Growth Pill
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Formatters.formatCurrency(earnings),
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.trending_up_rounded, size: 14, color: Colors.white),
                          const SizedBox(width: 3),
                          Text(
                            '+${growth.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2),
                Text(
                  'vs yesterday',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                AppSpacing.vGap16,

                // Mini Bar Chart & View Analytics Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // View Analytics White Pill Button
                    ElevatedButton(
                      onPressed: onAnalyticsTapped,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFB90058),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View Analytics',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFB90058),
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 15, color: Color(0xFFB90058)),
                        ],
                      ),
                    ),

                    // 5-Bar Mini Chart Graphic
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildMiniBar(height: 14, opacity: 0.4),
                        const SizedBox(width: 5),
                        _buildMiniBar(height: 22, opacity: 0.4),
                        const SizedBox(width: 5),
                        _buildMiniBar(height: 30, opacity: 0.5),
                        const SizedBox(width: 5),
                        _buildMiniBar(height: 38, opacity: 0.7),
                        const SizedBox(width: 5),
                        _buildMiniBar(height: 48, opacity: 1.0),
                      ],
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

  Widget _buildMiniBar({required double height, required double opacity}) {
    return Container(
      width: 14,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
      ),
    );
  }
}
