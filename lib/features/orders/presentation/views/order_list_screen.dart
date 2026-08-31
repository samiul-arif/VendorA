import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/error_state_view.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_status.dart';
import '../controllers/order_controller.dart';
import '../widgets/order_card.dart';
import '../../../../shared/components/app_toast.dart';
import 'order_details_screen.dart';

/// Order Management Screen matching Stitch brief (`orders_list/code.html`)
class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  int _selectedFilterIndex = 0; // 0 = Active, 1 = Completed, 2 = Cancelled

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  void _loadOrders() {
    final authController = context.read<AuthController>();
    final orderController = context.read<OrderController>();
    final shopId = authController.activeShop?.id ?? 'shop_01';
    orderController.loadOrders(shopId: shopId);
  }

  void _openOrderDetails(OrderModel order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrderDetailsScreen(orderId: order.id),
      ),
    );
  }

  void _handleAcceptOrder(OrderModel order) async {
    final orderController = context.read<OrderController>();
    final result = await orderController.updateStatus(orderId: order.id, newStatus: OrderStatus.preparing);

    if (!mounted) return;
    result.when(
      success: (_) => AppToast.showSuccess(
        context,
        title: 'Order Accepted',
        message: 'Order #${order.orderNumber} moved to kitchen preparation queue.',
      ),
      failure: (msg, _) => AppToast.showError(context, title: 'Error', message: msg),
    );
  }

  void _handleMarkReady(OrderModel order) async {
    final orderController = context.read<OrderController>();
    final result = await orderController.updateStatus(orderId: order.id, newStatus: OrderStatus.ready);

    if (!mounted) return;
    result.when(
      success: (_) => AppToast.showSuccess(
        context,
        title: 'Order Ready',
        message: 'Order #${order.orderNumber} marked ready for courier pickup.',
      ),
      failure: (msg, _) => AppToast.showError(context, title: 'Error', message: msg),
    );
  }

  void _handleDeclineOrder(OrderModel order) async {
    final orderController = context.read<OrderController>();
    final result = await orderController.updateStatus(orderId: order.id, newStatus: OrderStatus.cancelled);

    if (!mounted) return;
    result.when(
      success: (_) => AppToast.showWarning(
        context,
        title: 'Order Declined',
        message: 'Order #${order.orderNumber} has been rejected.',
      ),
      failure: (msg, _) => AppToast.showError(context, title: 'Error', message: msg),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final orderController = context.watch<OrderController>();
    final allOrders = orderController.allOrders;

    final activeOrders = allOrders.where((o) => o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled).toList();
    final completedOrders = allOrders.where((o) => o.status == OrderStatus.delivered).toList();
    final cancelledOrders = allOrders.where((o) => o.status == OrderStatus.cancelled).toList();

    List<OrderModel> currentList;
    String screenTitle;
    if (_selectedFilterIndex == 0) {
      currentList = activeOrders;
      screenTitle = 'Active Orders';
    } else if (_selectedFilterIndex == 1) {
      currentList = completedOrders;
      screenTitle = 'Completed Orders';
    } else {
      currentList = cancelledOrders;
      screenTitle = 'Cancelled Orders';
    }

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        bottom: false,
        child: orderController.isLoading && allOrders.isEmpty
            ? const _OrderListSkeleton()
            : orderController.hasError && allOrders.isEmpty
                ? ErrorStateView(
                    message: orderController.errorMessage ?? 'Failed to load orders.',
                    onRetry: _loadOrders,
                  )
                : RefreshIndicator(
                    onRefresh: () async => _loadOrders(),
                    color: colors.primary,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 120),
                      children: [
                        // Page Header matching Stitch: "Active Orders" + "Manage and process live incoming requests."
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  screenTitle,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: colors.textPrimary,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Manage and process live incoming requests.',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        AppSpacing.vGap16,

                        // Segmented Control Pill Container matching Stitch
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: colors.borderSubtle),
                          ),
                          child: Row(
                            children: [
                              _buildSegmentTab(
                                index: 0,
                                label: 'Active',
                                count: activeOrders.length,
                                isSelected: _selectedFilterIndex == 0,
                                colors: colors,
                              ),
                              _buildSegmentTab(
                                index: 1,
                                label: 'Completed',
                                count: completedOrders.length,
                                isSelected: _selectedFilterIndex == 1,
                                colors: colors,
                              ),
                              _buildSegmentTab(
                                index: 2,
                                label: 'Cancelled',
                                count: cancelledOrders.length,
                                isSelected: _selectedFilterIndex == 2,
                                colors: colors,
                              ),
                            ],
                          ),
                        ),

                        AppSpacing.vGap16,

                        // Orders List / Empty State
                        if (currentList.isEmpty)
                          _buildEmptyState(colors)
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: currentList.length,
                            separatorBuilder: (_, __) => AppSpacing.vGap12,
                            itemBuilder: (context, index) {
                              final order = currentList[index];
                              return OrderCard(
                                order: order,
                                onTap: () => _openOrderDetails(order),
                                onAccept: () => _handleAcceptOrder(order),
                                onReady: () => _handleMarkReady(order),
                                onDecline: () => _handleDeclineOrder(order),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildSegmentTab({
    required int index,
    required String label,
    required int count,
    required bool isSelected,
    required AppSemanticColors colors,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilterIndex = index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? colors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF15171C).withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? colors.textPrimary : colors.textSecondary,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.primaryContainer.withValues(alpha: 0.15) : colors.borderSubtle,
                    borderRadius: AppRadius.full,
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: isSelected ? colors.primary : colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppSemanticColors colors) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.primaryContainer.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.receipt_long_outlined, size: 28, color: colors.primary),
          ),
          AppSpacing.vGap16,
          Text(
            'No Orders Found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'There are currently no orders under this filter category.',
            style: TextStyle(
              fontSize: 12.5,
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Skeleton loading layout for orders screen
class _OrderListSkeleton extends StatelessWidget {
  const _OrderListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 96),
      children: const [
        ShimmerSkeleton(width: 140, height: 24),
        SizedBox(height: 6),
        ShimmerSkeleton(width: 220, height: 14),
        AppSpacing.vGap16,
        ShimmerSkeleton(width: double.infinity, height: 42, borderRadius: BorderRadius.all(Radius.circular(14))),
        AppSpacing.vGap16,
        ShimmerSkeleton(width: double.infinity, height: 130, borderRadius: BorderRadius.all(Radius.circular(18))),
        AppSpacing.vGap12,
        ShimmerSkeleton(width: double.infinity, height: 130, borderRadius: BorderRadius.all(Radius.circular(18))),
      ],
    );
  }
}
