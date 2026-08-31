import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/status_badge.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_status.dart';

// Order Card for Merchant Dispatch List View
class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;
  final ValueChanged<OrderStatus>? onQuickAction;
  final VoidCallback? onReject;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.onQuickAction,
    this.onReject,
  });

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final nextStatus = order.status.nextActionStatus;
    final nextActionLabel = order.status.nextActionLabel;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Order ID, Time Ago & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '#${order.orderNumber}',
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '• ${_formatTimeAgo(order.createdAt)}',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
              StatusBadge(
                type: order.status.badgeType,
                label: order.status.label,
              ),
            ],
          ),

          AppSpacing.vGap12,

          // Row 2: Customer Name & Delivery Address
          Row(
            children: [
              const Icon(
                Icons.person_outline_rounded,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  order.customerName,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          AppSpacing.vGap4,

          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  order.deliveryAddress,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          AppSpacing.vGap12,

          // Row 3: Items Summary Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF232A34) : AppColors.lightSurfaceSubtle,
              borderRadius: AppRadius.sm,
            ),
            child: Text(
              order.itemsSummary,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          if (order.customerNotes != null && order.customerNotes!.isNotEmpty) ...[
            AppSpacing.vGap8,
            Row(
              children: [
                const Icon(
                  Icons.edit_note_rounded,
                  size: 16,
                  color: AppColors.statusWarning,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Note: ${order.customerNotes}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.statusWarning,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],

          AppSpacing.vGap16,

          // Row 4: Total Price and Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total (${order.totalItemCount} items)',
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                  Text(
                    Formatters.formatCurrency(order.totalAmount),
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),

              // Action Buttons
              Row(
                children: [
                  if (order.isPending && onReject != null) ...[
                    OutlinedButton(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.statusError,
                        side: const BorderSide(color: Color(0xFFFECACA)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                      ),
                      child: const Text(
                        'Decline',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  if (nextStatus != null && nextActionLabel != null)
                    ElevatedButton(
                      onPressed: () => onQuickAction?.call(nextStatus),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: order.isPending
                            ? AppColors.primary
                            : (isDark ? Colors.white : AppColors.ctaPrimary),
                        foregroundColor: order.isPending
                            ? Colors.white
                            : (isDark ? AppColors.inkPrimary : Colors.white),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                        elevation: 0,
                      ),
                      child: Text(
                        nextActionLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
