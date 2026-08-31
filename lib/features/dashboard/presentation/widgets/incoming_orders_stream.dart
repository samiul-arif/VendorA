import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/status_badge.dart';
import '../../../orders/domain/models/order_status.dart';
import '../../../orders/presentation/controllers/order_controller.dart';
import '../../../orders/presentation/views/order_details_screen.dart';

// Incoming Orders Stream Component for Quick Dispatch & Kitchen Preparation
class IncomingOrdersStream extends StatelessWidget {
  final VoidCallback onViewAllTapped;

  const IncomingOrdersStream({
    super.key,
    required this.onViewAllTapped,
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
    final orderController = context.watch<OrderController>();

    final liveOrders = orderController.allOrders
        .where((o) => o.status == OrderStatus.pending || o.status == OrderStatus.accepted || o.status == OrderStatus.preparing)
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Incoming Live Orders',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            GestureDetector(
              onTap: onViewAllTapped,
              child: Text(
                'View All (${orderController.allOrders.length})',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),

        AppSpacing.vGap12,

        if (liveOrders.isEmpty)
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2E1A2A) : AppColors.primaryTint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_outline_rounded, color: AppColors.primary),
                ),
                AppSpacing.hGap12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kitchen Queue is Clear',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        'New customer orders will appear here in real time.',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
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
            separatorBuilder: (_, __) => AppSpacing.vGap12,
            itemBuilder: (context, index) {
              final order = liveOrders[index];
              final nextStatus = order.status.nextActionStatus;
              final nextActionLabel = order.status.nextActionLabel;

              return AppCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrderDetailsScreen(orderId: order.id),
                    ),
                  );
                },
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order ID & Status Badge
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
                            const SizedBox(width: 8),
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

                    AppSpacing.vGap8,

                    // Items Summary
                    Text(
                      order.itemsSummary,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    AppSpacing.vGap12,

                    // Price & Quick Action Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Formatters.formatCurrency(order.totalAmount),
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        if (nextStatus != null && nextActionLabel != null)
                          ElevatedButton(
                            onPressed: () async {
                              final result = await orderController.updateStatus(
                                orderId: order.id,
                                newStatus: nextStatus,
                              );
                              result.when(
                                success: (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Order #${order.orderNumber} updated to ${nextStatus.label}!'),
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: order.isPending
                                  ? AppColors.primary
                                  : (isDark ? Colors.white : AppColors.ctaPrimary),
                              foregroundColor: order.isPending
                                  ? Colors.white
                                  : (isDark ? AppColors.inkPrimary : Colors.white),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              );
            },
          ),
      ],
    );
  }
}
