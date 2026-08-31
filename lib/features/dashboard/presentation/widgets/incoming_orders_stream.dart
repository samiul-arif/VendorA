import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_card.dart';
import '../../../orders/domain/models/order_status.dart';
import '../../../orders/presentation/controllers/order_controller.dart';
import '../../../orders/presentation/views/order_details_screen.dart';

// Incoming Orders Stream Component (Screenshot 4 Matching)
class IncomingOrdersStream extends StatelessWidget {
  final VoidCallback onViewAllTapped;

  const IncomingOrdersStream({
    super.key,
    required this.onViewAllTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
                color: isDark ? AppColors.textMutedDark : const Color(0xFF6B7280),
              ),
            ),
            GestureDetector(
              onTap: onViewAllTapped,
              child: Text(
                'View All (${orderController.allOrders.length})',
                style: const TextStyle(
                  color: AppColors.primary,
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
                    color: isDark ? const Color(0xFF2E1A2A) : const Color(0xFFFFF0F6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_outline_rounded, color: AppColors.primary, size: 20),
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
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        'New customer orders will appear here in real time.',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.textMutedDark : const Color(0xFF6B7280),
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
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Status pill (Preparing in yellow / New in blue)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: isNew
                                      ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF))
                                      : (isDark ? const Color(0xFF382914) : const Color(0xFFFFFBEB)),
                                  borderRadius: AppRadius.full,
                                ),
                                child: Text(
                                  isNew ? 'New' : 'Preparing',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: isNew ? const Color(0xFF2563EB) : const Color(0xFFD97706),
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
                              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6B7280),
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
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
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
                          result.when(
                            success: (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Order #${order.orderNumber} Accepted! Moved to Preparing.'),
                                  backgroundColor: AppColors.statusSuccess,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            failure: (msg, _) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(msg),
                                  backgroundColor: AppColors.statusError,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          );
                        },
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
                    else
                      GestureDetector(
                        onTap: () async {
                          final result = await orderController.updateStatus(
                            orderId: order.id,
                            newStatus: OrderStatus.ready,
                          );
                          result.when(
                            success: (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Order #${order.orderNumber} Ready! Assigned rider notified for immediate pickup.'),
                                  backgroundColor: AppColors.statusSuccess,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            },
                            failure: (msg, _) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(msg),
                                  backgroundColor: AppColors.statusError,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white : AppColors.ctaPrimary,
                            borderRadius: AppRadius.full,
                          ),
                          child: Text(
                            'Ready',
                            style: TextStyle(
                              color: isDark ? AppColors.inkPrimary : Colors.white,
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
