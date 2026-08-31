import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_semantic_colors.dart';
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
    final colors = context.appColors;
    final config = _resolveConfig(colors);

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

  _BadgeStyleConfig _resolveConfig(AppSemanticColors colors) {
    switch (type) {
      case BadgeType.pending:
        return _BadgeStyleConfig(
          defaultLabel: 'Pending',
          backgroundColor: colors.orderPendingBg,
          borderColor: colors.orderPending.withValues(alpha: 0.3),
          textColor: colors.orderPending,
          dotColor: colors.orderPending,
        );

      case BadgeType.accepted:
        return _BadgeStyleConfig(
          defaultLabel: 'Accepted',
          backgroundColor: colors.orderAcceptedBg,
          borderColor: colors.orderAccepted.withValues(alpha: 0.3),
          textColor: colors.orderAccepted,
          dotColor: colors.orderAccepted,
        );

      case BadgeType.preparing:
        return _BadgeStyleConfig(
          defaultLabel: 'Preparing',
          backgroundColor: colors.orderPreparingBg,
          borderColor: colors.orderPreparing.withValues(alpha: 0.3),
          textColor: colors.orderPreparing,
          dotColor: colors.orderPreparing,
        );

      case BadgeType.ready:
        return _BadgeStyleConfig(
          defaultLabel: 'Ready for Pickup',
          backgroundColor: colors.orderReadyBg,
          borderColor: colors.orderReady.withValues(alpha: 0.3),
          textColor: colors.orderReady,
          dotColor: colors.orderReady,
        );

      case BadgeType.delivered:
        return _BadgeStyleConfig(
          defaultLabel: 'Delivered',
          backgroundColor: colors.orderDeliveredBg,
          borderColor: colors.orderDelivered.withValues(alpha: 0.3),
          textColor: colors.orderDelivered,
          dotColor: colors.orderDelivered,
        );

      case BadgeType.cancelled:
        return _BadgeStyleConfig(
          defaultLabel: 'Cancelled',
          backgroundColor: colors.orderCancelledBg,
          borderColor: colors.orderCancelled.withValues(alpha: 0.3),
          textColor: colors.orderCancelled,
          dotColor: colors.orderCancelled,
        );

      case BadgeType.open:
        return _BadgeStyleConfig(
          defaultLabel: 'Open',
          backgroundColor: colors.successBg,
          borderColor: colors.success.withValues(alpha: 0.3),
          textColor: colors.success,
          dotColor: colors.success,
        );

      case BadgeType.closed:
        return _BadgeStyleConfig(
          defaultLabel: 'Closed',
          backgroundColor: colors.surfaceSubtle,
          borderColor: colors.borderSubtle,
          textColor: colors.textSecondary,
          dotColor: colors.textMuted,
        );

      case BadgeType.inStock:
        return _BadgeStyleConfig(
          defaultLabel: 'In Stock',
          backgroundColor: colors.successBg,
          borderColor: colors.success.withValues(alpha: 0.3),
          textColor: colors.success,
          dotColor: colors.success,
        );

      case BadgeType.outOfStock:
        return _BadgeStyleConfig(
          defaultLabel: 'Out of Stock',
          backgroundColor: colors.errorBg,
          borderColor: colors.error.withValues(alpha: 0.3),
          textColor: colors.error,
          dotColor: colors.error,
        );

      case BadgeType.featured:
        return _BadgeStyleConfig(
          defaultLabel: 'Featured',
          backgroundColor: colors.primaryContainer,
          borderColor: colors.primary.withValues(alpha: 0.3),
          textColor: colors.primary,
          dotColor: colors.primary,
        );

      case BadgeType.success:
        return _BadgeStyleConfig(
          defaultLabel: 'Success',
          backgroundColor: colors.successBg,
          borderColor: colors.success.withValues(alpha: 0.3),
          textColor: colors.success,
          dotColor: colors.success,
        );

      case BadgeType.warning:
        return _BadgeStyleConfig(
          defaultLabel: 'Warning',
          backgroundColor: colors.warningBg,
          borderColor: colors.warning.withValues(alpha: 0.3),
          textColor: colors.warning,
          dotColor: colors.warning,
        );

      case BadgeType.error:
        return _BadgeStyleConfig(
          defaultLabel: 'Error',
          backgroundColor: colors.errorBg,
          borderColor: colors.error.withValues(alpha: 0.3),
          textColor: colors.error,
          dotColor: colors.error,
        );

      case BadgeType.info:
        return _BadgeStyleConfig(
          defaultLabel: 'Info',
          backgroundColor: colors.infoBg,
          borderColor: colors.info.withValues(alpha: 0.3),
          textColor: colors.info,
          dotColor: colors.info,
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
