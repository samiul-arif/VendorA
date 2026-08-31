import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../orders/domain/models/order_status.dart';
import '../../../orders/presentation/controllers/order_controller.dart';
import '../../../orders/presentation/views/order_details_screen.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../notifications/domain/models/notification_type.dart';
import '../../../../shared/components/app_toast.dart';

/// Active Orders Section matching Stitch brief (`dashboard/code.html`)
class IncomingOrdersStream extends StatelessWidget {
  final VoidCallback onViewAllTapped;

  const IncomingOrdersStream({
    super.key,
    required this.onViewAllTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final orderController = context.watch<OrderController>();

    final liveOrders = orderController.allOrders
        .where((o) =>
            o.status == OrderStatus.pending ||
            o.status == OrderStatus.accepted ||
            o.status == OrderStatus.preparing)
        .take(4)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header matching Stitch: "Active Orders" | "See All"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Orders',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: colors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            GestureDetector(
              onTap: onViewAllTapped,
              child: Text(
                'See All',
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),

        AppSpacing.vGap14,

        if (liveOrders.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.borderSubtle),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle_outline_rounded, color: colors.primary, size: 22),
                ),
                AppSpacing.hGap14,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Orders Fulfilled',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'New live customer orders will appear here automatically.',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: liveOrders.length,
            separatorBuilder: (_, __) => AppSpacing.vGap12,
            itemBuilder: (context, index) {
              final order = liveOrders[index];

              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF15171C).withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top: Order # and Status Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order #${order.orderNumber}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: colors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                order.itemsSummary,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusBadge(order.status, colors),
                      ],
                    ),

                    AppSpacing.vGap14,

                    // Bottom Row with Divider
                    Container(
                      padding: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: colors.divider, width: 0.8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.schedule_rounded, size: 15, color: colors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                order.status == OrderStatus.preparing
                                    ? 'Pickup in 5 mins'
                                    : 'Delivery in 15 mins',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              if (order.status == OrderStatus.pending)
                                ElevatedButton(
                                  onPressed: () async {
                                    final result = await orderController.updateStatus(
                                      orderId: order.id,
                                      newStatus: OrderStatus.preparing,
                                    );
                                    if (!context.mounted) return;
                                    result.when(
                                      success: (_) {
                                        context.read<NotificationController>().dispatchNotification(
                                          context,
                                          title: 'Order Accepted (#${order.orderNumber})',
                                          message: 'Order moved to kitchen queue.',
                                          type: NotificationType.order,
                                          toastVariant: AppToastVariant.success,
                                        );
                                      },
                                      failure: (msg, _) {
                                        AppToast.showError(context, title: 'Error', message: msg);
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    minimumSize: Size.zero,
                                    shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Accept',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                                  ),
                                ),
                              if (order.status == OrderStatus.pending) const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => OrderDetailsScreen(orderId: order.id),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: colors.borderSubtle),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  minimumSize: Size.zero,
                                  shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                                ),
                                child: Text(
                                  'Details',
                                  style: TextStyle(
                                    color: colors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildStatusBadge(OrderStatus status, AppSemanticColors colors) {
    if (status == OrderStatus.preparing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF5C5D64).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_fire_department_rounded, size: 14, color: Color(0xFF5C5D64)),
            SizedBox(width: 4),
            Text(
              'Preparing',
              style: TextStyle(
                color: Color(0xFF5C5D64),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      );
    } else if (status == OrderStatus.accepted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF75F9D6).withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF006B57)),
            SizedBox(width: 4),
            Text(
              'Accepted',
              style: TextStyle(
                color: Color(0xFF006B57),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colors.primaryContainer.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.fiber_new_rounded, size: 14, color: colors.primary),
            const SizedBox(width: 3),
            Text(
              'New',
              style: TextStyle(
                color: colors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      );
    }
  }
}
