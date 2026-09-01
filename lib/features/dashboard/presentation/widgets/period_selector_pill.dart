import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/analytics_time_range.dart';

// Rounded Period Selector Pill matching Stitch Analytics specification
class PeriodSelectorPill extends StatelessWidget {
  final AnalyticsTimeRange selectedRange;
  final ValueChanged<AnalyticsTimeRange> onRangeSelected;

  const PeriodSelectorPill({
    super.key,
    required this.selectedRange,
    required this.onRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerBg = isDark ? const Color(0xFF1E232D) : const Color(0xFFEAEDF9);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: containerBg,
        borderRadius: AppRadius.full,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(21, 23, 28, 0.04),
            offset: Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: AnalyticsTimeRange.values.map((range) {
          final isSelected = range == selectedRange;
          return _buildSegment(
            context: context,
            range: range,
            isSelected: isSelected,
            colors: colors,
            isDark: isDark,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSegment({
    required BuildContext context,
    required AnalyticsTimeRange range,
    required bool isSelected,
    required AppSemanticColors colors,
    required bool isDark,
  }) {
    final activeBg = colors.primary;
    const activeText = Colors.white;
    final inactiveText = isDark ? const Color(0xFFDFE2EE) : const Color(0xFF5A3F46);

    return InkWell(
      onTap: () => onRangeSelected(range),
      borderRadius: AppRadius.full,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.transparent,
          borderRadius: AppRadius.full,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeBg.withValues(alpha: 0.35),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              range.label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? activeText : inactiveText,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 12,
              ),
            ),
            if (range == AnalyticsTimeRange.custom) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.calendar_month_outlined,
                size: 14,
                color: isSelected ? activeText : inactiveText,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
