import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_card.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_status.dart';

// Order Card for Merchant Dispatch List View (Screenshot 3 Matching)
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isNew = order.isPending;
    final isPreparing = order.status == OrderStatus.preparing || order.status == OrderStatus.accepted;
    final isReady = order.status == OrderStatus.ready;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Order #FP-XXXX + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.orderNumber}',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              _buildStatusBadge(order.status, isDark),
            ],
          ),

          AppSpacing.vGap12,

          // Bulleted Items List (e.g. • 2x Classic Double Cheeseburger ($22.00))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: order.items.map((item) {
              final itemTotal = (item.unitPrice * item.quantity).toStringAsFixed(2);
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  '• ${item.quantity}x ${item.productName} (\$$itemTotal)',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4B5563),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),

          AppSpacing.vGap12,

          // Footer: Total: $XX.XX on left and Action / Rider Status on right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Total: ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  children: [
                    TextSpan(
                      text: Formatters.formatCurrency(order.totalAmount),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              // Right Action / Status Element
              if (isNew)
                GestureDetector(
                  onTap: () => onQuickAction?.call(OrderStatus.preparing),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.full,
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                )
              else if (isPreparing)
                GestureDetector(
                  onTap: () => onQuickAction?.call(OrderStatus.ready),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white : AppColors.ctaPrimary,
                      borderRadius: AppRadius.full,
                    ),
                    child: Text(
                      'Mark Ready',
                      style: TextStyle(
                        color: isDark ? AppColors.inkPrimary : Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                )
              else if (isReady)
                Text(
                  'Rider Assigned (5 mins)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                )
              else
                Text(
                  order.status.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status, bool isDark) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case OrderStatus.ready:
        bg = isDark ? const Color(0xFF0F3A2E) : const Color(0xFFECFDF5);
        fg = const Color(0xFF059669);
        label = 'Ready for Delivery';
        break;
      case OrderStatus.preparing:
      case OrderStatus.accepted:
        bg = isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF);
        fg = const Color(0xFF2563EB);
        label = 'In Preparation';
        break;
      case OrderStatus.pending:
        bg = isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF);
        fg = const Color(0xFF2563EB);
        label = 'New';
        break;
      case OrderStatus.delivered:
        bg = isDark ? const Color(0xFF0F3A2E) : const Color(0xFFECFDF5);
        fg = const Color(0xFF059669);
        label = 'Completed';
        break;
      case OrderStatus.cancelled:
        bg = isDark ? const Color(0xFF3B1414) : const Color(0xFFFEF2F2);
        fg = const Color(0xFFEF4444);
        label = 'Cancelled';
        break;
      default:
        bg = isDark ? const Color(0xFF232A34) : const Color(0xFFF3F4F6);
        fg = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
        label = status.label;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.full,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
