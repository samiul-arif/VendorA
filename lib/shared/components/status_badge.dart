import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

// Status Badge Type
enum BadgeType {
  // Order Statuses
  pending,
  accepted,
  preparing,
  ready,
  delivered,
  cancelled,

  // Shop & Product Statuses
  open,
  closed,
  inStock,
  outOfStock,
  featured,

  // Semantic
  success,
  warning,
  error,
  info,
}

// Pastel Status Badge / Chip
class StatusBadge extends StatelessWidget {
  final String? label;
  final BadgeType type;
  final bool showDot;
  final IconData? icon;
  final EdgeInsetsGeometry padding;

  const StatusBadge({
    super.key,
    this.label,
    required this.type,
    this.showDot = true,
    this.icon,
    this.padding = AppSpacing.chipPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final config = _resolveConfig(isDark);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: AppRadius.chip,
        border: Border.all(color: config.borderColor, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: config.textColor),
            const SizedBox(width: 5),
          ] else if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: config.dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label ?? config.defaultLabel,
            style: AppTypography.labelMedium.copyWith(
              color: config.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeStyleConfig _resolveConfig(bool isDark) {
    switch (type) {
      case BadgeType.pending:
        return _BadgeStyleConfig(
          defaultLabel: 'Pending',
          backgroundColor: isDark ? const Color(0xFF3B2A10) : AppColors.statusWarningBg,
          borderColor: isDark ? const Color(0xFF5A3E14) : const Color(0xFFFDE68A),
          textColor: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
          dotColor: AppColors.statusWarning,
        );

      case BadgeType.accepted:
        return _BadgeStyleConfig(
          defaultLabel: 'Accepted',
          backgroundColor: isDark ? const Color(0xFF13294B) : AppColors.statusInfoBg,
          borderColor: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFBFDBFE),
          textColor: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
          dotColor: AppColors.statusInfo,
        );

      case BadgeType.preparing:
        return _BadgeStyleConfig(
          defaultLabel: 'Preparing',
          backgroundColor: isDark ? const Color(0xFF2E1A47) : const Color(0xFFF5F3FF),
          borderColor: isDark ? const Color(0xFF4C1D95) : const Color(0xFFDDD6FE),
          textColor: isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED),
          dotColor: const Color(0xFF8B5CF6),
        );

      case BadgeType.ready:
        return _BadgeStyleConfig(
          defaultLabel: 'Ready for Pickup',
          backgroundColor: isDark ? const Color(0xFF0F3A2E) : AppColors.statusSuccessBg,
          borderColor: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
          textColor: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
          dotColor: AppColors.statusSuccess,
        );

      case BadgeType.delivered:
        return _BadgeStyleConfig(
          defaultLabel: 'Delivered',
          backgroundColor: isDark ? const Color(0xFF0F3A2E) : const Color(0xFFECFDF5),
          borderColor: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
          textColor: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
          dotColor: const Color(0xFF059669),
        );

      case BadgeType.cancelled:
        return _BadgeStyleConfig(
          defaultLabel: 'Cancelled',
          backgroundColor: isDark ? const Color(0xFF3B1414) : AppColors.statusErrorBg,
          borderColor: isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFECACA),
          textColor: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
          dotColor: AppColors.statusError,
        );

      case BadgeType.open:
        return _BadgeStyleConfig(
          defaultLabel: 'Open',
          backgroundColor: isDark ? const Color(0xFF0F3A2E) : AppColors.statusSuccessBg,
          borderColor: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
          textColor: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
          dotColor: AppColors.statusSuccess,
        );

      case BadgeType.closed:
        return _BadgeStyleConfig(
          defaultLabel: 'Closed',
          backgroundColor: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF3F4F6),
          borderColor: isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB),
          textColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          dotColor: AppColors.textMutedLight,
        );

      case BadgeType.inStock:
        return _BadgeStyleConfig(
          defaultLabel: 'In Stock',
          backgroundColor: isDark ? const Color(0xFF0F3A2E) : AppColors.statusSuccessBg,
          borderColor: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
          textColor: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
          dotColor: AppColors.statusSuccess,
        );

      case BadgeType.outOfStock:
        return _BadgeStyleConfig(
          defaultLabel: 'Out of Stock',
          backgroundColor: isDark ? const Color(0xFF3B1414) : AppColors.statusErrorBg,
          borderColor: isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFECACA),
          textColor: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
          dotColor: AppColors.statusError,
        );

      case BadgeType.featured:
        return _BadgeStyleConfig(
          defaultLabel: 'Featured',
          backgroundColor: isDark ? const Color(0xFF4A0A26) : AppColors.primaryTint,
          borderColor: isDark ? const Color(0xFF831843) : const Color(0xFFFBCFE8),
          textColor: AppColors.primary,
          dotColor: AppColors.primary,
        );

      case BadgeType.success:
        return _BadgeStyleConfig(
          defaultLabel: 'Success',
          backgroundColor: isDark ? const Color(0xFF0F3A2E) : AppColors.statusSuccessBg,
          borderColor: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
          textColor: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
          dotColor: AppColors.statusSuccess,
        );

      case BadgeType.warning:
        return _BadgeStyleConfig(
          defaultLabel: 'Warning',
          backgroundColor: isDark ? const Color(0xFF3B2A10) : AppColors.statusWarningBg,
          borderColor: isDark ? const Color(0xFF5A3E14) : const Color(0xFFFDE68A),
          textColor: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
          dotColor: AppColors.statusWarning,
        );

      case BadgeType.error:
        return _BadgeStyleConfig(
          defaultLabel: 'Error',
          backgroundColor: isDark ? const Color(0xFF3B1414) : AppColors.statusErrorBg,
          borderColor: isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFECACA),
          textColor: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
          dotColor: AppColors.statusError,
        );

      case BadgeType.info:
        return _BadgeStyleConfig(
          defaultLabel: 'Info',
          backgroundColor: isDark ? const Color(0xFF13294B) : AppColors.statusInfoBg,
          borderColor: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFBFDBFE),
          textColor: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
          dotColor: AppColors.statusInfo,
        );
    }
  }
}

class _BadgeStyleConfig {
  final String defaultLabel;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color dotColor;

  const _BadgeStyleConfig({
    required this.defaultLabel,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.dotColor,
  });
}
