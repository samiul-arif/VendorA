import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_button.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/app_dialog.dart';
import '../../../../shared/components/status_badge.dart';
import '../../../../shared/components/app_circular_back_button.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../notifications/domain/models/notification_type.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_status.dart';
import '../controllers/order_controller.dart';
import '../widgets/order_item_tile.dart';

// Comprehensive Order Details Screen with Kitchen Timeline & Line Item Breakdown
class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderController>().loadOrderDetails(widget.orderId);
    });
  }

  void _handleStatusTransition(OrderModel order, OrderStatus nextStatus) async {
    final orderController = context.read<OrderController>();
    final result = await orderController.updateStatus(
      orderId: order.id,
      newStatus: nextStatus,
    );

    if (!mounted) return;

    final notif = context.read<NotificationController>();

    result.when(
      success: (_) {
        if (nextStatus == OrderStatus.accepted) {
          notif.dispatchNotification(
            context,
            title: 'Order #${order.orderNumber} Accepted',
            message: 'Moved to kitchen preparation queue.',
            type: NotificationType.order,
            relatedOrderId: order.id,
            toastVariant: AppToastVariant.success,
          );
        } else if (nextStatus == OrderStatus.ready) {
          notif.dispatchNotification(
            context,
            title: 'Order #${order.orderNumber} Ready',
            message: 'Courier notified for immediate pickup.',
            type: NotificationType.order,
            relatedOrderId: order.id,
            toastVariant: AppToastVariant.success,
          );
        } else if (nextStatus == OrderStatus.delivered) {
          notif.dispatchNotification(
            context,
            title: 'Order #${order.orderNumber} Completed',
            message: 'Order successfully delivered to customer.',
            type: NotificationType.order,
            relatedOrderId: order.id,
            toastVariant: AppToastVariant.success,
          );
        }
      },
      failure: (msg, _) {
        AppToast.showError(context, title: 'Update Failed', message: msg);
      },
    );
  }

  void _handleDeclineOrder(OrderModel order) async {
    final confirmed = await AppDialog.showConfirmation(
      context: context,
      title: 'Decline Order #${order.orderNumber}?',
      message: 'Are you sure you want to decline this incoming order? This will notify the customer and cancel the transaction.',
      isDestructive: true,
      confirmText: 'Decline Order',
      cancelText: 'Keep Order',
    );

    if (confirmed == true && mounted) {
      final orderController = context.read<OrderController>();
      final result = await orderController.cancelOrder(
        order.id,
        reason: 'Merchant unavailable to fulfill',
      );

      if (!mounted) return;

      result.when(
        success: (_) {
          context.read<NotificationController>().dispatchNotification(
            context,
            title: 'Order #${order.orderNumber} Declined',
            message: 'Order cancelled and customer notified.',
            type: NotificationType.order,
            relatedOrderId: order.id,
            toastVariant: AppToastVariant.error,
          );
          Navigator.of(context).pop();
        },
        failure: (msg, _) {
          AppToast.showError(context, title: 'Action Failed', message: msg);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final orderController = context.watch<OrderController>();
    final order = orderController.selectedOrder;

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: Center(
          child: CircularProgressIndicator(color: colors.primary),
        ),
      );
    }

    final nextStatus = order.status.nextActionStatus;
    final nextActionLabel = order.status.nextActionLabel;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 56,
        leading: const AppCircularBackButton(),
        title: Text(
          'Order #${order.orderNumber}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: StatusBadge(
                type: order.status.badgeType,
                label: order.status.label,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: colors.borderSubtle,
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          children: [
            // 1. Order Status Timeline Progression Card
            _buildStatusProgressCard(order, colors),

            AppSpacing.vGap16,

            // 2. Customer Information Card
            _buildCustomerCard(order, colors),

            AppSpacing.vGap16,

            // 3. Rider / Courier Details Card
            if (order.riderName != null) ...[
              _buildRiderCard(order, colors),
              AppSpacing.vGap16,
            ],

            // 4. Line Items Breakdown Card
            _buildItemsBreakdownCard(order, colors),

            AppSpacing.vGap16,

            // 5. Payment & Price Receipt Card
            _buildReceiptCard(order, colors),

            if (order.rejectionReason != null) ...[
              AppSpacing.vGap16,
              _buildCancellationNoticeCard(order, colors),
            ],
          ],
        ),
      ),
      bottomSheet: _buildBottomActionBar(order, nextStatus, nextActionLabel, colors),
    );
  }

  Widget _buildStatusProgressCard(OrderModel order, AppSemanticColors colors) {
    final stages = [
      {'status': OrderStatus.pending, 'label': 'Placed'},
      {'status': OrderStatus.accepted, 'label': 'Accepted'},
      {'status': OrderStatus.preparing, 'label': 'Kitchen'},
      {'status': OrderStatus.ready, 'label': 'Ready'},
      {'status': OrderStatus.delivered, 'label': 'Delivered'},
    ];

    final currentIdx = stages.indexWhere((s) => s['status'] == order.status);

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kitchen Dispatch Timeline',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              if (order.estimatedPrepMinutes > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: AppRadius.full,
                  ),
                  child: Text(
                    '~${order.estimatedPrepMinutes}m prep',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: colors.primary,
                    ),
                  ),
                ),
            ],
          ),

          AppSpacing.vGap16,

          Row(
            children: List.generate(stages.length * 2 - 1, (index) {
              if (index.isOdd) {
                final stepIdx = index ~/ 2;
                final isDone = currentIdx >= 0 && stepIdx < currentIdx;
                return Expanded(
                  child: Container(
                    height: 3,
                    color: isDone ? colors.primary : colors.borderSubtle,
                  ),
                );
              }

              final stepIdx = index ~/ 2;
              final isReached = currentIdx >= 0 && stepIdx <= currentIdx;
              final isCurrent = stepIdx == currentIdx;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? colors.primary
                          : (isReached
                              ? colors.primaryContainer
                              : colors.surfaceSubtle),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isReached ? colors.primary : colors.borderSubtle,
                        width: isCurrent ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      isReached ? Icons.check_rounded : Icons.circle,
                      size: isReached ? 16 : 8,
                      color: isCurrent
                          ? Colors.white
                          : (isReached ? colors.primary : colors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stages[stepIdx]['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                      color: isCurrent
                          ? colors.primary
                          : colors.textMuted,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(OrderModel order, AppSemanticColors colors) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customer Details',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  AppToast.showInfo(
                    context,
                    title: 'Initiating Call',
                    message: 'Connecting to customer at ${order.customerPhone}...',
                  );
                },
                icon: const Icon(Icons.call_rounded, size: 14),
                label: const Text('Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primaryContainer,
                  foregroundColor: colors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                ),
              ),
            ],
          ),

          AppSpacing.vGap12,

          Text(
            order.customerName,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),

          Text(
            order.customerPhone,
            style: AppTypography.bodySmall.copyWith(
              color: colors.textMuted,
            ),
          ),

          AppSpacing.vGap12,

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: colors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.deliveryAddress,
                  style: AppTypography.bodyMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          if (order.customerNotes != null && order.customerNotes!.isNotEmpty) ...[
            AppSpacing.vGap12,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.warningBg,
                borderRadius: AppRadius.md,
                border: Border.all(
                  color: colors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 18, color: colors.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Delivery Instruction: ${order.customerNotes}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRiderCard(OrderModel order, AppSemanticColors colors) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.successBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delivery_dining_rounded,
              color: colors.success,
              size: 24,
            ),
          ),
          AppSpacing.hGap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assigned Courier',
                  style: AppTypography.labelSmall.copyWith(
                    color: colors.textMuted,
                  ),
                ),
                Text(
                  order.riderName!,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                if (order.riderPhone != null)
                  Text(
                    order.riderPhone!,
                    style: AppTypography.bodySmall.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              AppToast.showInfo(
                context,
                title: 'Calling Courier',
                message: 'Connecting dispatch line with ${order.riderName}...',
              );
            },
            icon: Icon(Icons.phone_in_talk_rounded, color: colors.success),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsBreakdownCard(OrderModel order, AppSemanticColors colors) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items (${order.totalItemCount})',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          AppSpacing.vGap8,
          ...order.items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isLast = idx == order.items.length - 1;
            return OrderItemTile(
              item: item,
              showDivider: !isLast,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReceiptCard(OrderModel order, AppSemanticColors colors) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Summary',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          AppSpacing.vGap16,
          _buildSummaryRow('Subtotal', Formatters.formatCurrency(order.subtotal), colors),
          AppSpacing.vGap8,
          _buildSummaryRow('Delivery Fee', Formatters.formatCurrency(order.deliveryFee), colors),
          if (order.tax > 0) ...[
            AppSpacing.vGap8,
            _buildSummaryRow('Estimated Tax', Formatters.formatCurrency(order.tax), colors),
          ],
          if (order.discount > 0) ...[
            AppSpacing.vGap8,
            _buildSummaryRow(
              'Merchant Discount',
              '- ${Formatters.formatCurrency(order.discount)}',
              colors,
              textColor: colors.success,
            ),
          ],
          AppSpacing.vGap12,
          Divider(
            height: 1,
            color: colors.divider,
          ),
          AppSpacing.vGap12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Revenue',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                Formatters.formatCurrency(order.totalAmount),
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          AppSpacing.vGap12,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.surfaceSubtle,
              borderRadius: AppRadius.sm,
            ),
            child: Row(
              children: [
                Icon(Icons.payment_rounded, size: 16, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  '${order.paymentMethod} • ${order.isPaid ? "Paid Online" : "Payment Pending"}',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancellationNoticeCard(OrderModel order, AppSemanticColors colors) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: colors.errorBg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.cancel_rounded, color: colors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Cancelled',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: colors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.rejectionReason!,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    AppSemanticColors colors, {
    Color? textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: textColor ?? colors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(
    OrderModel order,
    OrderStatus? nextStatus,
    String? nextActionLabel,
    AppSemanticColors colors,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: colors.borderSubtle,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: [
          if (order.isPending) ...[
            Expanded(
              child: AppButton(
                text: 'Decline',
                variant: AppButtonVariant.destructive,
                size: AppButtonSize.large,
                onPressed: () => _handleDeclineOrder(order),
              ),
            ),
            const SizedBox(width: 12),
          ],

          if (nextStatus != null && nextActionLabel != null)
            Expanded(
              flex: order.isPending ? 2 : 1,
              child: AppButton(
                text: nextActionLabel,
                variant: AppButtonVariant.primary,
                size: AppButtonSize.large,
                onPressed: () => _handleStatusTransition(order, nextStatus),
              ),
            )
          else
            Expanded(
              child: AppButton(
                text: 'Back to Orders List',
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.large,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
        ],
      ),
    );
  }
}
