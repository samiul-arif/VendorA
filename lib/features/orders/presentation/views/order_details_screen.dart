import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/app_dialog.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../notifications/domain/models/notification_type.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_status.dart';
import '../controllers/order_controller.dart';
import '../widgets/order_item_tile.dart';

/// Order Details Screen strictly matching Stitch brief (`order_detail_updated_with_payment_info/code.html`)
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
        if (nextStatus == OrderStatus.accepted || nextStatus == OrderStatus.preparing) {
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
            message: 'Marked ready for customer pickup.',
            type: NotificationType.order,
            relatedOrderId: order.id,
            toastVariant: AppToastVariant.success,
          );
        } else if (nextStatus == OrderStatus.delivered) {
          notif.dispatchNotification(
            context,
            title: 'Order #${order.orderNumber} Completed',
            message: 'Order successfully handed over and delivered.',
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
      message: 'Are you sure you want to decline this incoming order? This will notify the customer and cancel the order.',
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
            toastVariant: AppToastVariant.warning,
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
        backgroundColor: colors.surface,
        appBar: AppBar(
          backgroundColor: colors.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: colors.primary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Order Details',
            style: AppTypography.headlineMedium.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(color: colors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.surface,
      // Stitch Top AppBar
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Order #${order.orderNumber}',
              style: AppTypography.headlineMedium.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 19,
                letterSpacing: -0.3,
              ),
            ),
            AppSpacing.hGap8,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                borderRadius: AppRadius.full,
              ),
              child: Text(
                order.status.label,
                style: AppTypography.labelSmall.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            120, // clearance for bottom action bar
          ),
          children: [
            // 1. Customer Details Card (without Call or Map buttons)
            _buildCustomerCard(order, colors),

            AppSpacing.vGap16,

            // 2. Order Items Card
            _buildItemsBreakdownCard(order, colors),

            AppSpacing.vGap16,

            // 3. Payment Information Card
            _buildPaymentInfoCard(order, colors),

            AppSpacing.vGap16,

            // 4. Order Status Timeline Card
            _buildOrderTimelineCard(order, colors),

            if (order.rejectionReason != null) ...[
              AppSpacing.vGap16,
              _buildCancellationNoticeCard(order, colors),
            ],
          ],
        ),
      ),
      // Sticky Bottom Action Bar
      bottomSheet: _buildBottomActionBar(order, colors),
    );
  }

  // 1. Customer Information Card (Removed Call & Map buttons as requested)
  Widget _buildCustomerCard(OrderModel order, AppSemanticColors colors) {
    final customerName = order.customerName.isNotEmpty ? order.customerName : 'Customer';

    return AppCard(
      padding: AppSpacing.cardPaddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Details',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          AppSpacing.vGap14,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.surfaceLow,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 22,
                  color: colors.textSecondary,
                ),
              ),
              AppSpacing.hGap14,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                    AppSpacing.vGap4,
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: colors.textMuted,
                        ),
                        AppSpacing.hGap4,
                        Expanded(
                          child: Text(
                            order.deliveryAddress,
                            style: AppTypography.bodyMedium.copyWith(
                              color: colors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vGap4,
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 15,
                          color: colors.textMuted,
                        ),
                        AppSpacing.hGap4,
                        Text(
                          order.customerPhone,
                          style: AppTypography.bodyMedium.copyWith(
                            color: colors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (order.customerNotes != null && order.customerNotes!.isNotEmpty) ...[
            AppSpacing.vGap12,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surfaceLow,
                borderRadius: AppRadius.sm,
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Row(
                children: [
                  Icon(Icons.notes_rounded, size: 16, color: colors.primary),
                  AppSpacing.hGap8,
                  Expanded(
                    child: Text(
                      'Note: ${order.customerNotes}',
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
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

  // 2. Order Items Card
  Widget _buildItemsBreakdownCard(OrderModel order, AppSemanticColors colors) {
    return AppCard(
      padding: AppSpacing.cardPaddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items (${order.totalItemCount})',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          AppSpacing.vGap10,
          ...order.items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isLast = idx == order.items.length - 1;
            return OrderItemTile(
              item: item,
              showDivider: !isLast,
            );
          }),
          AppSpacing.vGap14,
          Divider(height: 1, color: colors.divider),
          AppSpacing.vGap14,
          // Financial Breakdown
          _buildSummaryRow('Subtotal', Formatters.formatCurrency(order.subtotal), colors),
          AppSpacing.vGap8,
          _buildSummaryRow('Delivery Fee', order.deliveryFee == 0 ? 'Free' : Formatters.formatCurrency(order.deliveryFee), colors),
          if (order.tax > 0) ...[
            AppSpacing.vGap8,
            _buildSummaryRow('Tax', Formatters.formatCurrency(order.tax), colors),
          ],
          AppSpacing.vGap12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                Formatters.formatCurrency(order.totalAmount),
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Payment Information Card matching Stitch brief
  Widget _buildPaymentInfoCard(OrderModel order, AppSemanticColors colors) {
    return AppCard(
      padding: AppSpacing.cardPaddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Information',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          AppSpacing.vGap14,
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.surfaceLow,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.credit_card_rounded,
                  size: 22,
                  color: colors.textSecondary,
                ),
              ),
              AppSpacing.hGap14,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Method',
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                    AppSpacing.vGap2,
                    Text(
                      order.paymentMethod,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: order.isPaid ? colors.secondaryContainer.withValues(alpha: 0.25) : colors.warningBg,
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  order.isPaid ? 'Paid' : 'Pending',
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: order.isPaid ? colors.secondary : colors.warning,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.vGap12,
          Divider(height: 1, color: colors.divider),
          AppSpacing.vGap12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transaction ID',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textMuted,
                ),
              ),
              Text(
                'TXN-${order.orderNumber.replaceAll("#", "").replaceAll("-", "")}9876',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 4. Order Timeline Card matching Stitch brief
  Widget _buildOrderTimelineCard(OrderModel order, AppSemanticColors colors) {
    final stages = [
      {'status': OrderStatus.pending, 'label': 'Order Received', 'time': Formatters.formatTime(order.createdAt)},
      {'status': OrderStatus.preparing, 'label': 'Preparing', 'time': 'In Kitchen Queue'},
      {'status': OrderStatus.ready, 'label': 'Ready for Pickup', 'time': 'Awaiting Courier'},
      {'status': OrderStatus.delivered, 'label': 'Delivered', 'time': 'Completed'},
    ];

    final currentIdx = stages.indexWhere((s) => s['status'] == order.status);

    return AppCard(
      padding: AppSpacing.cardPaddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          AppSpacing.vGap16,
          ...List.generate(stages.length, (index) {
            final stage = stages[index];
            final isReached = currentIdx >= 0 && index <= currentIdx;
            final isCurrent = index == currentIdx;
            final isLast = index == stages.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? colors.primary
                            : (isReached ? colors.secondary : colors.surfaceLow),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isReached ? Colors.transparent : colors.borderSubtle,
                        ),
                      ),
                      child: Center(
                        child: isReached
                            ? Icon(
                                Icons.check_rounded,
                                size: 13,
                                color: colors.textInverse,
                              )
                            : null,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 32,
                        color: (currentIdx >= 0 && index < currentIdx)
                            ? colors.secondary
                            : colors.borderSubtle,
                      ),
                  ],
                ),
                AppSpacing.hGap14,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stage['label'] as String,
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                          color: isCurrent
                              ? colors.primary
                              : (isReached ? colors.textPrimary : colors.textMuted),
                        ),
                      ),
                      AppSpacing.vGap2,
                      Text(
                        stage['time'] as String,
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      if (!isLast) AppSpacing.vGap14,
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCancellationNoticeCard(OrderModel order, AppSemanticColors colors) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      backgroundColor: colors.errorBg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.cancel_rounded, color: colors.error),
          AppSpacing.hGap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Cancelled',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.error,
                  ),
                ),
                AppSpacing.vGap4,
                Text(
                  order.rejectionReason!,
                  style: AppTypography.bodySmall.copyWith(
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

  Widget _buildSummaryRow(String label, String value, AppSemanticColors colors) {
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
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }

  // 5. Updated Accept & Decline / Status Action Bar for Order Details
  Widget _buildBottomActionBar(OrderModel order, AppSemanticColors colors) {
    final isPending = order.status == OrderStatus.pending;
    final isAccepted = order.status == OrderStatus.accepted || order.status == OrderStatus.preparing;
    final isReady = order.status == OrderStatus.ready;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.borderSubtle),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D15171C),
            offset: Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPending) ...[
              // Accept & Decline in One Single Floating Row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => _handleDeclineOrder(order),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colors.error.withValues(alpha: 0.6)),
                          foregroundColor: colors.error,
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.full,
                          ),
                        ),
                        child: Text(
                          'Decline',
                          style: AppTypography.labelLarge.copyWith(
                            color: colors.error,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.hGap12,
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => _handleStatusTransition(order, OrderStatus.preparing),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.textInverse,
                          elevation: 2,
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.full,
                          ),
                        ),
                        child: Text(
                          'Accept Order',
                          style: AppTypography.labelLarge.copyWith(
                            color: colors.textInverse,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (isAccepted) ...[
              // Cancel & Mark as Ready in One Single Floating Row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => _handleDeclineOrder(order),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colors.borderSubtle),
                          foregroundColor: colors.textSecondary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.full,
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTypography.labelLarge.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.hGap12,
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => _handleStatusTransition(order, OrderStatus.ready),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.textInverse,
                          elevation: 2,
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.full,
                          ),
                        ),
                        child: Text(
                          'Mark as Ready',
                          style: AppTypography.labelLarge.copyWith(
                            color: colors.textInverse,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (isReady) ...[
              // Complete Handover
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _handleStatusTransition(order, OrderStatus.delivered),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.secondary,
                    foregroundColor: colors.textInverse,
                    elevation: 2,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.full,
                    ),
                  ),
                  child: Text(
                    'Mark as Delivered',
                    style: AppTypography.labelLarge.copyWith(
                      color: colors.textInverse,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Order Completed / Cancelled
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.borderSubtle),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.full,
                    ),
                  ),
                  child: Text(
                    'Back to Orders',
                    style: AppTypography.labelMedium.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
