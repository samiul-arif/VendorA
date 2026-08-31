import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_card.dart';
import '../../domain/models/sales_chart_point.dart';

// Interactive Sales Performance Bar Chart Card
class SalesAnalyticsChart extends StatelessWidget {
  final List<SalesChartPoint> chartPoints;
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;

  const SalesAnalyticsChart({
    super.key,
    required this.chartPoints,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final maxAmount = chartPoints.isEmpty
        ? 2500.0
        : chartPoints.map((p) => p.amount).reduce((a, b) => a > b ? a : b) * 1.15;

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Period Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Revenue Analytics',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    'Sales trend over time',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),

              // Period Toggle Pill
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF232A34) : AppColors.borderLight,
                  borderRadius: AppRadius.full,
                ),
                child: Row(
                  children: [
                    _buildPeriodButton('weekly', 'Weekly', isDark),
                    _buildPeriodButton('monthly', 'Monthly', isDark),
                  ],
                ),
              ),
            ],
          ),

          AppSpacing.vGap24,

          // Bar Chart Area
          SizedBox(
            height: 160,
            child: chartPoints.isEmpty
                ? const Center(
                    child: Text(
                      'No revenue data available',
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: chartPoints.map((point) {
                      final ratio = (point.amount / maxAmount).clamp(0.08, 1.0);
                      final isHighlight = point.isCurrentDay;

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Tooltip / Amount Label
                              if (isHighlight)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  margin: const EdgeInsets.only(bottom: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: AppRadius.sm,
                                  ),
                                  child: Text(
                                    Formatters.formatCurrency(point.amount),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                )
                              else
                                const SizedBox(height: 18),

                              // Bar Graphic
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                height: 100 * ratio,
                                decoration: BoxDecoration(
                                  color: isHighlight
                                      ? AppColors.primary
                                      : (isDark
                                          ? const Color(0xFF2D3748)
                                          : const Color(0xFFE5E7EB)),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: isHighlight
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withValues(alpha: 0.35),
                                            offset: const Offset(0, 4),
                                            blurRadius: 10,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),

                              AppSpacing.vGap8,

                              // X-Axis Label
                              Text(
                                point.label,
                                style: AppTypography.labelSmall.copyWith(
                                  color: isHighlight
                                      ? AppColors.primary
                                      : (isDark
                                          ? AppColors.textMutedDark
                                          : AppColors.textMutedLight),
                                  fontWeight: isHighlight
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period, String label, bool isDark) {
    final isSelected = selectedPeriod == period;
    return GestureDetector(
      onTap: () => onPeriodChanged(period),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkSurface : Colors.white)
              : Colors.transparent,
          borderRadius: AppRadius.full,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected
                ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          ),
        ),
      ),
    );
  }
}
