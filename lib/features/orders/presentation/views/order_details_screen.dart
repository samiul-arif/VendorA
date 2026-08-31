import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_button.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/app_dialog.dart';
import '../../../../shared/components/status_badge.dart';
import '../../../../shared/components/app_circular_back_button.dart';
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

  void _handleStatusTransition(OrderModel order, OrderStatus newStatus) async {
    final orderController = context.read<OrderController>();
    final result = await orderController.updateStatus(
      orderId: order.id,
      newStatus: newStatus,
    );

    if (!mounted) return;

    result.when(
      success: (updated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order #${order.orderNumber} status changed to ${newStatus.label}!'),
            backgroundColor: AppColors.statusSuccess,
            behavior: SnackBarBehavior.floating,
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
  }

  void _handleDeclineOrder(OrderModel order) async {
    final confirmed = await AppDialog.showConfirmation(
      context: context,
      title: 'Decline Order #${order.orderNumber}',
      message: 'Are you sure you want to reject this order? This cannot be undone.',
      confirmText: 'Decline Order',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      final orderController = context.read<OrderController>();
      final result = await orderController.cancelOrder(
        order.id,
        reason: 'Store was unable to fulfill this order.',
      );

      if (!mounted) return;

      result.when(
        success: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order #${order.orderNumber} has been cancelled.'),
              backgroundColor: AppColors.statusError,
              behavior: SnackBarBehavior.floating,
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final orderController = context.watch<OrderController>();
    final order = orderController.selectedOrder;

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final nextStatus = order.status.nextActionStatus;
    final nextActionLabel = order.status.nextActionLabel;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF161B22) : const Color(0xFFFFFFFF),
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
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
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
            color: isDark ? AppColors.darkBorder : const Color(0xFFEEF0F2),
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          children: [
            // 1. Order Status Timeline Progression Card
            _buildStatusProgressCard(order, isDark),

            AppSpacing.vGap16,

            // 2. Customer Information Card
            _buildCustomerCard(order, isDark),

            AppSpacing.vGap16,

            // 3. Rider / Courier Details Card
            if (order.riderName != null) ...[
              _buildRiderCard(order, isDark),
              AppSpacing.vGap16,
            ],

            // 4. Line Items Breakdown Card
            _buildItemsBreakdownCard(order, isDark),

            AppSpacing.vGap16,

            // 5. Payment & Price Receipt Card
            _buildReceiptCard(order, isDark),

            if (order.rejectionReason != null) ...[
              AppSpacing.vGap16,
              _buildCancellationNoticeCard(order, isDark),
            ],
          ],
        ),
      ),
      bottomSheet: _buildBottomActionBar(order, nextStatus, nextActionLabel, isDark),
    );
  }

  Widget _buildStatusProgressCard(OrderModel order, bool isDark) {
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
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              if (order.estimatedPrepMinutes > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2E1A2A) : AppColors.primaryTint,
                    borderRadius: AppRadius.full,
                  ),
                  child: Text(
                    '~${order.estimatedPrepMinutes}m prep',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
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
                    color: isDone ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.borderLight),
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
                          ? AppColors.primary
                          : (isReached
                              ? (isDark ? const Color(0xFF381223) : AppColors.primaryTint)
                              : (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle)),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isReached ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.borderLight),
                        width: isCurrent ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      isReached ? Icons.check_rounded : Icons.circle,
                      size: isReached ? 16 : 8,
                      color: isCurrent
                          ? Colors.white
                          : (isReached ? AppColors.primary : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stages[stepIdx]['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                      color: isCurrent
                          ? AppColors.primary
                          : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
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

  Widget _buildCustomerCard(OrderModel order, bool isDark) {
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
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Simulating call to ${order.customerPhone}...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.call_rounded, size: 14),
                label: const Text('Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF2E1A2A) : AppColors.primaryTint,
                  foregroundColor: AppColors.primary,
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
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),

          Text(
            order.customerPhone,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),

          AppSpacing.vGap12,

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.deliveryAddress,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
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
                color: isDark ? const Color(0xFF3B2A10) : AppColors.statusWarningBg,
                borderRadius: AppRadius.md,
                border: Border.all(
                  color: isDark ? const Color(0xFF5A3E14) : const Color(0xFFFDE68A),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.statusWarning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Delivery Instruction: ${order.customerNotes}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.statusWarning,
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

  Widget _buildRiderCard(OrderModel order, bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F3A2E) : AppColors.statusSuccessBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delivery_dining_rounded,
              color: AppColors.statusSuccess,
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
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                Text(
                  order.riderName!,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                if (order.riderPhone != null)
                  Text(
                    order.riderPhone!,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Contacting courier ${order.riderName}...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.phone_in_talk_rounded, color: AppColors.statusSuccess),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsBreakdownCard(OrderModel order, bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items (${order.totalItemCount})',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
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

  Widget _buildReceiptCard(OrderModel order, bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Summary',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.vGap16,
          _buildSummaryRow('Subtotal', Formatters.formatCurrency(order.subtotal), isDark),
          AppSpacing.vGap8,
          _buildSummaryRow('Delivery Fee', Formatters.formatCurrency(order.deliveryFee), isDark),
          if (order.tax > 0) ...[
            AppSpacing.vGap8,
            _buildSummaryRow('Estimated Tax', Formatters.formatCurrency(order.tax), isDark),
          ],
          if (order.discount > 0) ...[
            AppSpacing.vGap8,
            _buildSummaryRow(
              'Merchant Discount',
              '- ${Formatters.formatCurrency(order.discount)}',
              isDark,
              textColor: AppColors.statusSuccess,
            ),
          ],
          AppSpacing.vGap12,
          Divider(
            height: 1,
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
          AppSpacing.vGap12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Revenue',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              Text(
                Formatters.formatCurrency(order.totalAmount),
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          AppSpacing.vGap12,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF232A34) : AppColors.lightSurfaceSubtle,
              borderRadius: AppRadius.sm,
            ),
            child: Row(
              children: [
                const Icon(Icons.payment_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  '${order.paymentMethod} • ${order.isPaid ? "Paid Online" : "Payment Pending"}',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancellationNoticeCard(OrderModel order, bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: isDark ? const Color(0xFF3B1414) : AppColors.statusErrorBg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.cancel_rounded, color: AppColors.statusError),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Cancelled',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.statusError,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.rejectionReason!,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B),
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
    bool isDark, {
    Color? textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: textColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(
    OrderModel order,
    OrderStatus? nextStatus,
    String? nextActionLabel,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.borderLight,
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
