import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';

// Category / Filter Pill Chip
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;
  final IconData? icon;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.count,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Colors
    final Color bgColor = isSelected
        ? (isDark ? AppColors.textPrimaryDark : AppColors.ctaPrimary)
        : (isDark ? AppColors.darkSurface : AppColors.lightSurface);

    final Color fgColor = isSelected
        ? (isDark ? AppColors.ctaPrimary : AppColors.ctaPrimaryText)
        : (isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight);

    final Color countBg = isSelected
        ? (isDark ? const Color(0x33000000) : const Color(0x33FFFFFF))
        : (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightCanvas);

    final Color countFg = isSelected
        ? fgColor
        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 40),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.chip,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: AppRadius.chip,
              border: isSelected
                  ? null
                  : Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      width: 1.0,
                    ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: fgColor),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: AppTypography.titleSmall.copyWith(
                    color: fgColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (count != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: countBg,
                      borderRadius: AppRadius.full,
                    ),
                    child: Text(
                      '$count',
                      style: AppTypography.labelSmall.copyWith(
                        color: countFg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
