import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../orders/domain/models/order_status.dart';
import '../../../orders/presentation/controllers/order_controller.dart';
import '../../../orders/presentation/views/order_details_screen.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../notifications/domain/models/notification_type.dart';
import '../../../../shared/components/app_toast.dart';

/// Active Orders Section strictly matching Stitch brief (`dashboard/code.html`)
class IncomingOrdersStream extends StatelessWidget {
  final VoidCallback onViewAllTapped;

  const IncomingOrdersStream({
    super.key,
    required this.onViewAllTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDark;
    final orderController = context.watch<OrderController>();

    final liveOrders = orderController.getRecentActiveOrders(limit: 5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header matching Stitch: "Active Orders" | "See All"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Orders',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            GestureDetector(
              onTap: onViewAllTapped,
              child: Text(
                'See All',
                style: AppTypography.labelLarge.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
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
              borderRadius: AppRadius.md,
              border: Border.all(color: colors.borderSubtle),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: colors.primary,
                    size: 22,
                  ),
                ),
                AppSpacing.hGap14,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Orders Fulfilled',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                      AppSpacing.vGap2,
                      Text(
                        'New live customer orders will appear here automatically.',
                        style: AppTypography.bodySmall.copyWith(
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
                padding: AppSpacing.cardPadding,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
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
                                style: AppTypography.bodySmall.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: colors.textSecondary,
                                ),
                              ),
                              AppSpacing.vGap2,
                              Text(
                                order.itemsSummary,
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.hGap8,
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
                              Icon(
                                Icons.schedule_rounded,
                                size: 15,
                                color: colors.textMuted,
                              ),
                              AppSpacing.hGap4,
                              Text(
                                order.status == OrderStatus.preparing
                                    ? 'Pickup in 5 mins'
                                    : 'Delivery in 15 mins',
                                style: AppTypography.bodySmall.copyWith(
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              if (order.status == OrderStatus.pending)
                                InkWell(
                                  onTap: () async {
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
                                  borderRadius: AppRadius.full,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: colors.primary,
                                      borderRadius: AppRadius.full,
                                    ),
                                    child: Text(
                                      'Accept',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: colors.textInverse,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              if (order.status == OrderStatus.pending) AppSpacing.hGap8,
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => OrderDetailsScreen(orderId: order.id),
                                    ),
                                  );
                                },
                                borderRadius: AppRadius.full,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: colors.surface,
                                    borderRadius: AppRadius.full,
                                    border: Border.all(color: colors.borderSubtle),
                                  ),
                                  child: Text(
                                    'Details',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: colors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
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
        if (liveOrders.isNotEmpty) ...[
          AppSpacing.vGap12,
          Center(
            child: TextButton.icon(
              onPressed: onViewAllTapped,
              icon: Icon(Icons.receipt_long_rounded, size: 16, color: colors.primary),
              label: Text(
                'View All Orders',
                style: AppTypography.labelMedium.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                backgroundColor: colors.primary.withValues(alpha: 0.08),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusBadge(OrderStatus status, AppSemanticColors colors) {
    if (status == OrderStatus.preparing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colors.textSecondary.withValues(alpha: 0.12),
          borderRadius: AppRadius.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department_rounded,
              size: 14,
              color: colors.textSecondary,
            ),
            AppSpacing.hGap4,
            Text(
              'Preparing',
              style: AppTypography.labelSmall.copyWith(
                color: colors.textSecondary,
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
          color: colors.secondaryContainer.withValues(alpha: 0.25),
          borderRadius: AppRadius.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 14,
              color: colors.secondary,
            ),
            AppSpacing.hGap4,
            Text(
              'Accepted',
              style: AppTypography.labelSmall.copyWith(
                color: colors.secondary,
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
          color: colors.primary.withValues(alpha: 0.12),
          borderRadius: AppRadius.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.fiber_new_rounded, size: 14, color: colors.primary),
            AppSpacing.hGap4,
            Text(
              'New',
              style: AppTypography.labelSmall.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      );
    }
  }
}
