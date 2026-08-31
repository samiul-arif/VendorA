import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_card.dart';
import '../../../orders/domain/models/order_status.dart';
import '../../../orders/presentation/controllers/order_controller.dart';
import '../../../orders/presentation/views/order_details_screen.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../notifications/domain/models/notification_type.dart';
import '../../../../shared/components/app_toast.dart';

// Incoming Orders Stream Component (Screenshot 4 Matching)
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
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Matching Screenshot 4: INCOMING ORDERS | View All (18)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'INCOMING ORDERS',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 0.8,
                color: colors.textMuted,
              ),
            ),
            GestureDetector(
              onTap: onViewAllTapped,
              child: Text(
                'View All (${orderController.allOrders.length})',
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),

        AppSpacing.vGap12,

        if (liveOrders.isEmpty)
          AppCard(
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle_outline_rounded, color: colors.primary, size: 20),
                ),
                AppSpacing.hGap12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kitchen Queue is Clear',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        'New customer orders will appear here in real time.',
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          // Order Cards List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: liveOrders.length,
            separatorBuilder: (_, __) => AppSpacing.vGap10,
            itemBuilder: (context, index) {
              final order = liveOrders[index];
              final isNew = order.isPending;

              return AppCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrderDetailsScreen(orderId: order.id),
                    ),
                  );
                },
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                borderRadius: BorderRadius.circular(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Order Info Left
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '#${order.orderNumber}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Status pill (Preparing in yellow / New in blue)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: isNew
                                      ? colors.orderPendingBg
                                      : colors.orderPreparingBg,
                                  borderRadius: AppRadius.full,
                                ),
                                child: Text(
                                  isNew ? 'New' : 'Preparing',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: isNew ? colors.orderPending : colors.orderPreparing,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.itemsSummary,
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            Formatters.formatCurrency(order.totalAmount),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Action Button Right (Pink "Accept" or Black "Ready")
                    if (isNew)
                      GestureDetector(
                        onTap: () async {
                          final result = await orderController.updateStatus(
                            orderId: order.id,
                            newStatus: OrderStatus.preparing,
                          );
                          if (!context.mounted) return;
                          final notifController = context.read<NotificationController>();
                          result.when(
                            success: (_) {
                              notifController.dispatchNotification(
                                context,
                                title: 'Order Accepted (#${order.orderNumber})',
                                message: 'Order has been moved to kitchen preparation queue.',
                                type: NotificationType.order,
                                relatedOrderId: order.id,
                                toastVariant: AppToastVariant.success,
                                actionLabel: 'View',
                                onAction: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: order.id)),
                                  );
                                },
                              );
                            },
                            failure: (msg, _) {
                              AppToast.showError(context, title: 'Action Failed', message: msg);
                            },
                          );
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
                    else
                      GestureDetector(
                        onTap: () async {
                          final result = await orderController.updateStatus(
                            orderId: order.id,
                            newStatus: OrderStatus.ready,
                          );
                          if (!context.mounted) return;
                          final notifController = context.read<NotificationController>();
                          result.when(
                            success: (_) {
                              notifController.dispatchNotification(
                                context,
                                title: 'Order Ready for Pickup (#${order.orderNumber})',
                                message: 'Assigned courier has been notified for immediate pickup.',
                                type: NotificationType.order,
                                relatedOrderId: order.id,
                                toastVariant: AppToastVariant.success,
                                actionLabel: 'View',
                                onAction: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: order.id)),
                                  );
                                },
                              );
                            },
                            failure: (msg, _) {
                              AppToast.showError(context, title: 'Action Failed', message: msg);
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: colors.ctaPrimary,
                            borderRadius: AppRadius.full,
                          ),
                          child: Text(
                            'Ready',
                            style: TextStyle(
                              color: colors.ctaPrimaryText,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
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
}
