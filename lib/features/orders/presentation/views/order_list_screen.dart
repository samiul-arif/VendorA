import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_dialog.dart';
import '../../../../shared/components/empty_state_view.dart';
import '../../../../shared/components/error_state_view.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_status.dart';
import '../controllers/order_controller.dart';
import '../widgets/order_card.dart';
import '../widgets/order_status_tab_bar.dart';
import 'order_details_screen.dart';
import '../../../notifications/presentation/widgets/notification_badge_icon.dart';

// Order Dispatch & Kitchen Live Queue Screen (Tab 1 in Main Shell)
class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  void _handleQuickStatusChange(OrderModel order, OrderStatus newStatus) async {
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
            content: Text('Order #${order.orderNumber} moved to ${newStatus.label}!'),
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
  }

  void _handleDeclineOrder(OrderModel order) async {
    final confirmed = await AppDialog.showConfirmation(
      context: context,
      title: 'Decline Order #${order.orderNumber}',
      message: 'Are you sure you want to reject this incoming order?',
      confirmText: 'Decline Order',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      final orderController = context.read<OrderController>();
      final result = await orderController.cancelOrder(
        order.id,
        reason: 'Merchant unable to prepare at this time.',
      );

      if (!mounted) return;

      result.when(
        success: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order #${order.orderNumber} declined.'),
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
    final orders = orderController.filteredOrders;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
      appBar: AppBar(
        title: const Text('Live Orders'),
        actions: const [
          NotificationBadgeIcon(),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: orderController.isLoading && orderController.allOrders.isEmpty
            ? const _OrderListSkeleton()
            : orderController.hasError && orderController.allOrders.isEmpty
                ? ErrorStateView(
                    message: orderController.errorMessage ?? 'Failed to load order queue.',
                    onRetry: _loadOrders,
                  )
                : RefreshIndicator(
                    onRefresh: () async => _loadOrders(),
                    color: AppColors.primary,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                      children: [
                        // Search Bar
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : Colors.white,
                            borderRadius: AppRadius.full,
                            border: Border.all(
                              color: isDark ? const Color(0xFF2D3748) : AppColors.borderLight,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => orderController.setSearchQuery(val),
                            decoration: InputDecoration(
                              hintText: 'Search by order #, customer, item...',
                              prefixIcon: const Icon(Icons.search_rounded, size: 20),
                              suffixIcon: orderController.searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close_rounded, size: 18),
                                      onPressed: () {
                                        _searchController.clear();
                                        orderController.clearSearch();
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),

                        AppSpacing.vGap12,

                        // Horizontal Status Tabs Bar
                        OrderStatusTabBar(
                          selectedStatus: orderController.selectedStatus,
                          onStatusSelected: (status) =>
                              orderController.setStatusFilter(status),
                          countGetter: (status) =>
                              orderController.getCount(status),
                        ),

                        AppSpacing.vGap16,

                        // Empty State if no orders found
                        if (orders.isEmpty)
                          EmptyStateView(
                            icon: Icons.receipt_long_rounded,
                            title: 'No Orders Found',
                            description: orderController.searchQuery.isNotEmpty
                                ? 'No orders match "${orderController.searchQuery}".'
                                : 'No orders in ${orderController.selectedStatus.label.toLowerCase()} status.',
                            actionButtonText: orderController.searchQuery.isNotEmpty
                                ? 'Clear Search'
                                : null,
                            onActionButtonPressed: orderController.searchQuery.isNotEmpty
                                ? () {
                                    _searchController.clear();
                                    orderController.clearSearch();
                                  }
                                : null,
                          )
                        else
                          // Orders List View
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orders.length,
                            separatorBuilder: (_, __) => AppSpacing.vGap12,
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              return OrderCard(
                                order: order,
                                onTap: () => _openOrderDetails(order),
                                onQuickAction: (nextStatus) =>
                                    _handleQuickStatusChange(order, nextStatus),
                                onReject: () => _handleDeclineOrder(order),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

// Skeleton Placeholder during initial load
class _OrderListSkeleton extends StatelessWidget {
  const _OrderListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        const ShimmerSkeleton(width: double.infinity, height: 48, borderRadius: AppRadius.full),
        AppSpacing.vGap12,
        Row(
          children: const [
            ShimmerSkeleton(width: 80, height: 38, borderRadius: AppRadius.full),
            SizedBox(width: 8),
            ShimmerSkeleton(width: 90, height: 38, borderRadius: AppRadius.full),
            SizedBox(width: 8),
            ShimmerSkeleton(width: 90, height: 38, borderRadius: AppRadius.full),
          ],
        ),
        AppSpacing.vGap16,
        ...List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: const ShimmerSkeleton(
              width: double.infinity,
              height: 180,
              borderRadius: AppRadius.card,
            ),
          ),
        ),
      ],
    );
  }
}
