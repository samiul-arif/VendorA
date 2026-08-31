import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
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
  final VoidCallback? onAccept;
  final VoidCallback? onReady;
  final VoidCallback? onReject;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.onQuickAction,
    this.onAccept,
    this.onReady,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

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
                  color: colors.textPrimary,
                ),
              ),
              _buildStatusBadge(order.status, colors),
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
                    color: colors.textSecondary,
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
                    color: colors.textPrimary,
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
                  onTap: () {
                    if (onAccept != null) {
                      onAccept!();
                    } else {
                      onQuickAction?.call(OrderStatus.preparing);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: colors.primary,
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
                  onTap: () {
                    if (onReady != null) {
                      onReady!();
                    } else {
                      onQuickAction?.call(OrderStatus.ready);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: colors.ctaPrimary,
                      borderRadius: AppRadius.full,
                    ),
                    child: Text(
                      'Mark Ready',
                      style: TextStyle(
                        color: colors.ctaPrimaryText,
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
                    color: colors.textMuted,
                  ),
                )
              else
                Text(
                  order.status.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colors.textMuted,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status, AppSemanticColors colors) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case OrderStatus.ready:
        bg = colors.orderReadyBg;
        fg = colors.orderReady;
        label = 'Ready for Delivery';
        break;
      case OrderStatus.preparing:
      case OrderStatus.accepted:
        bg = colors.orderPreparingBg;
        fg = colors.orderPreparing;
        label = 'In Preparation';
        break;
      case OrderStatus.pending:
        bg = colors.orderPendingBg;
        fg = colors.orderPending;
        label = 'New';
        break;
      case OrderStatus.delivered:
        bg = colors.orderDeliveredBg;
        fg = colors.orderDelivered;
        label = 'Completed';
        break;
      case OrderStatus.cancelled:
        bg = colors.orderCancelledBg;
        fg = colors.orderCancelled;
        label = 'Cancelled';
        break;
      default:
        bg = colors.surfaceSubtle;
        fg = colors.textSecondary;
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
