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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: colors.surface,
          elevation: 0,
          leading: const AppCircularBackButton(),
          title: Text(
            'Order Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: colors.textPrimary,
            ),
          ),
        ),
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
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 110),
          children: [
            // 1. Order Information Card
            _buildOrderInfoCard(order, colors),

            AppSpacing.vGap16,

            // 2. Customer Information Card (with Call Customer & Open in Maps)
            _buildCustomerCard(order, colors),

            AppSpacing.vGap16,

            // 3. Ordered Items Card (Images, quantities, unit prices, subtotals)
            _buildItemsBreakdownCard(order, colors),

            AppSpacing.vGap16,

            // 4. Payment Information Card (Method, TXN ID, Status)
            _buildPaymentInfoCard(order, colors),

            AppSpacing.vGap16,

            // 5. Order Summary Card (Subtotal, Delivery, Tax, Total)
            _buildOrderSummaryCard(order, colors),

            if (order.riderName != null) ...[
              AppSpacing.vGap16,
              // 6. Rider Information Card (if assigned)
              _buildRiderCard(order, colors),
            ],

            AppSpacing.vGap16,

            // 7. Order Timeline Card (Milestones & Stepper)
            _buildOrderTimelineCard(order, colors),

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

  // 1. Order Information Card
  Widget _buildOrderInfoCard(OrderModel order, AppSemanticColors colors) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: AppRadius.sm,
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        size: 20,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${order.orderNumber}',
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.w900,
                              color: colors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Placed ${Formatters.formatRelativeTime(order.createdAt)}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: colors.textMuted,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(
                type: order.status.badgeType,
                label: order.status.label,
              ),
            ],
          ),
          Divider(height: 24, color: colors.divider),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 14, color: colors.textMuted),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        Formatters.formatDateTime(order.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (order.estimatedPrepMinutes > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: AppRadius.full,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer_outlined, size: 12, color: colors.primary),
                      const SizedBox(width: 4),
                      Text(
                        '~${order.estimatedPrepMinutes}m prep',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. Customer Information Card
  Widget _buildCustomerCard(OrderModel order, AppSemanticColors colors) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colors.surfaceSubtle,
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 18,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Customer Information',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),

          AppSpacing.vGap14,

          Text(
            order.customerName,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            order.customerPhone,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
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
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.vGap14,

          // Action Buttons: Call Customer & Open Location in Maps
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    AppToast.showInfo(
                      context,
                      title: 'Calling Customer',
                      message: 'Connecting dispatch phone to ${order.customerPhone}...',
                    );
                  },
                  borderRadius: AppRadius.full,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: AppRadius.full,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.call_rounded, size: 15, color: colors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'Call Customer',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AppSpacing.hGap10,
              Expanded(
                child: InkWell(
                  onTap: () {
                    AppToast.showInfo(
                      context,
                      title: 'Opening Map Location',
                      message: 'Navigating to: ${order.deliveryAddress}',
                    );
                  },
                  borderRadius: AppRadius.full,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: colors.surfaceSubtle,
                      borderRadius: AppRadius.full,
                      border: Border.all(color: colors.borderSubtle),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 15, color: colors.textPrimary),
                        const SizedBox(width: 6),
                        Text(
                          'Open in Maps',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.notes_rounded, size: 18, color: colors.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Delivery Instruction: ${order.customerNotes}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.warning,
                        height: 1.3,
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

  // 3. Ordered Items Card
  Widget _buildItemsBreakdownCard(OrderModel order, AppSemanticColors colors) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ordered Items (${order.totalItemCount})',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                '${order.items.length} ${order.items.length == 1 ? "line item" : "line items"}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.textMuted,
                ),
              ),
            ],
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

  // 4. Payment Information Card
  Widget _buildPaymentInfoCard(OrderModel order, AppSemanticColors colors) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Information',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          AppSpacing.vGap14,
          _buildSummaryRow(
            'Payment Method',
            order.paymentMethod,
            colors,
            icon: Icons.credit_card_rounded,
          ),
          AppSpacing.vGap10,
          _buildSummaryRow(
            'Transaction ID',
            'TXN-${order.orderNumber.replaceAll("#", "").replaceAll("-", "")}-PAY',
            colors,
            icon: Icons.confirmation_number_outlined,
          ),
          AppSpacing.vGap10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.verified_outlined, size: 16, color: colors.textMuted),
                  const SizedBox(width: 6),
                  Text(
                    'Payment Status',
                    style: AppTypography.bodyMedium.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: order.isPaid ? colors.successBg : colors.warningBg,
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  order.isPaid ? 'Paid Online' : 'Payment Pending',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: order.isPaid ? colors.success : colors.warning,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 5. Order Summary Card
  Widget _buildOrderSummaryCard(OrderModel order, AppSemanticColors colors) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          AppSpacing.vGap16,
          _buildSummaryRow('Subtotal', Formatters.formatCurrency(order.subtotal), colors),
          AppSpacing.vGap8,
          _buildSummaryRow(
            'Delivery Fee',
            order.deliveryFee == 0 ? 'Free' : Formatters.formatCurrency(order.deliveryFee),
            colors,
          ),
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
                'Total Amount',
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

  // 6. Rider Information Card (if assigned)
  Widget _buildRiderCard(OrderModel order, AppSemanticColors colors) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Assigned Courier / Rider',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  order.riderName!,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                if (order.riderPhone != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    order.riderPhone!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              AppToast.showInfo(
                context,
                title: 'Calling Courier',
                message: 'Connecting dispatch line with ${order.riderName}...',
              );
            },
            borderRadius: AppRadius.full,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: colors.successBg,
                borderRadius: AppRadius.full,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone_in_talk_rounded, size: 14, color: colors.success),
                  const SizedBox(width: 4),
                  Text(
                    'Call',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colors.success,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 7. Order Timeline Card (Vertical Milestone Tracker)
  Widget _buildOrderTimelineCard(OrderModel order, AppSemanticColors colors) {
    final stages = [
      {'status': OrderStatus.pending, 'label': 'Order Placed', 'desc': 'Received by merchant system'},
      {'status': OrderStatus.accepted, 'label': 'Order Accepted', 'desc': 'Sent to kitchen prep queue'},
      {'status': OrderStatus.preparing, 'label': 'Kitchen Preparation', 'desc': 'Meal being cooked & packed'},
      {'status': OrderStatus.ready, 'label': 'Ready for Pickup', 'desc': 'Awaiting courier dispatch'},
      {'status': OrderStatus.delivered, 'label': 'Order Delivered', 'desc': 'Handed over to customer'},
    ];

    final currentIdx = stages.indexWhere((s) => s['status'] == order.status);

    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Timeline',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  order.status.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: colors.primary,
                  ),
                ),
              ),
            ],
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
                // Milestone Node & Vertical Connector Line
                Column(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? colors.primary
                            : (isReached ? colors.primaryContainer : colors.surfaceSubtle),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isReached ? colors.primary : colors.borderSubtle,
                          width: isCurrent ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: isReached
                            ? Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: isCurrent ? Colors.white : colors.primary,
                              )
                            : Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: colors.textMuted,
                                  shape: BoxShape.circle,
                                ),
                              ),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 28,
                        color: (currentIdx >= 0 && index < currentIdx)
                            ? colors.primary
                            : colors.borderSubtle,
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Step Title & Description
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stage['label'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isCurrent ? FontWeight.w800 : (isReached ? FontWeight.w700 : FontWeight.w500),
                            color: isCurrent
                                ? colors.primary
                                : (isReached ? colors.textPrimary : colors.textMuted),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          stage['desc'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: isReached ? colors.textSecondary : colors.textMuted,
                          ),
                        ),
                        if (!isLast) const SizedBox(height: 12),
                      ],
                    ),
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
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 15, color: colors.textMuted),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: textColor ?? colors.textPrimary,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  // 8. Contextual Actions
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
