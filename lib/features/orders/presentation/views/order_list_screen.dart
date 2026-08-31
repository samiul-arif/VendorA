import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/empty_state_view.dart';
import '../../../../shared/components/error_state_view.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_status.dart';
import '../controllers/order_controller.dart';
import '../widgets/order_card.dart';
import '../../../../shared/components/app_toast.dart';
import 'order_details_screen.dart';

// Order Management Screen (Content-First Merchant Layout)
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
    final result = await orderController.updateStatus(orderId: order.id, newStatus: OrderStatus.accepted);
    
    if (!mounted) return;
    result.when(
      success: (_) => AppToast.showSuccess(context, title: 'Order Accepted', message: 'Order #${order.orderNumber} moved to preparation.'),
      failure: (msg, _) => AppToast.showError(context, title: 'Error', message: msg),
    );
  }

  void _handleMarkReady(OrderModel order) async {
    final orderController = context.read<OrderController>();
    final result = await orderController.updateStatus(orderId: order.id, newStatus: OrderStatus.ready);
    
    if (!mounted) return;
    result.when(
      success: (_) => AppToast.showSuccess(context, title: 'Order Ready', message: 'Order #${order.orderNumber} is ready for pickup.'),
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
    if (_selectedFilterIndex == 0) {
      currentList = activeOrders;
    } else if (_selectedFilterIndex == 1) {
      currentList = completedOrders;
    } else {
      currentList = cancelledOrders;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: orderController.isLoading && allOrders.isEmpty
            ? const _OrderListSkeleton()
            : orderController.hasError && allOrders.isEmpty
                ? ErrorStateView(
                    message: orderController.errorMessage ?? 'Failed to load order queue.',
                    onRetry: _loadOrders,
                  )
                : RefreshIndicator(
                    onRefresh: () async => _loadOrders(),
                    color: colors.primary,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                      children: [
                        // Content-First Header (Scrollable Merchant Title)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Order Management',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.4,
                                color: colors.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: colors.successBg,
                                borderRadius: AppRadius.full,
                              ),
                              child: Text(
                                '${activeOrders.length} Active',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: colors.success,
                                ),
                              ),
                            ),
                          ],
                        ),

                        AppSpacing.vGap16,

                        // Filter Pills: Active | Completed | Cancelled
                        Row(
                          children: [
                            _buildFilterPill(
                              label: 'Active (${activeOrders.length})',
                              isSelected: _selectedFilterIndex == 0,
                              colors: colors,
                              onTap: () => setState(() => _selectedFilterIndex = 0),
                            ),
                            const SizedBox(width: 8),
                            _buildFilterPill(
                              label: 'Completed (${completedOrders.length})',
                              isSelected: _selectedFilterIndex == 1,
                              colors: colors,
                              onTap: () => setState(() => _selectedFilterIndex = 1),
                            ),
                            const SizedBox(width: 8),
                            _buildFilterPill(
                              label: 'Cancelled (${cancelledOrders.length})',
                              isSelected: _selectedFilterIndex == 2,
                              colors: colors,
                              onTap: () => setState(() => _selectedFilterIndex = 2),
                            ),
                          ],
                        ),

                        AppSpacing.vGap16,

                        // Orders List
                        if (currentList.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: EmptyStateView(
                              icon: Icons.receipt_long_outlined,
                              title: _selectedFilterIndex == 0
                                  ? 'No Active Orders'
                                  : _selectedFilterIndex == 1
                                      ? 'No Completed Orders'
                                      : 'No Cancelled Orders',
                              description: _selectedFilterIndex == 0
                                  ? 'New orders placed by customers will appear here.'
                                  : 'Completed order history will be shown here.',
                            ),
                          )
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
                                onAccept: order.isPending
                                    ? () => _handleAcceptOrder(order)
                                    : null,
                                onReady: order.isPreparing
                                    ? () => _handleMarkReady(order)
                                    : null,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildFilterPill({
    required String label,
    required bool isSelected,
    required AppSemanticColors colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.ctaPrimary
              : colors.surface,
          borderRadius: AppRadius.full,
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : colors.borderSubtle,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: isSelected
                ? colors.ctaPrimaryText
                : colors.textSecondary,
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
        const Row(
          children: [
            ShimmerSkeleton(width: 90, height: 36, borderRadius: AppRadius.full),
            SizedBox(width: 8),
            ShimmerSkeleton(width: 90, height: 36, borderRadius: AppRadius.full),
            SizedBox(width: 8),
            ShimmerSkeleton(width: 90, height: 36, borderRadius: AppRadius.full),
          ],
        ),
        AppSpacing.vGap16,
        ...List.generate(
          3,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: ShimmerSkeleton(
              width: double.infinity,
              height: 160,
              borderRadius: AppRadius.card,
            ),
          ),
        ),
      ],
    );
  }
}
