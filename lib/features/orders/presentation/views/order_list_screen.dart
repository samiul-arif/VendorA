import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/empty_state_view.dart';
import '../../../../shared/components/error_state_view.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_status.dart';
import '../controllers/order_controller.dart';
import '../widgets/order_card.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../notifications/domain/models/notification_type.dart';
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

  void _handleQuickStatusChange(OrderModel order, OrderStatus newStatus) async {
    final orderController = context.read<OrderController>();
    final result = await orderController.updateStatus(
      orderId: order.id,
      newStatus: newStatus,
    );

    if (!mounted) return;

    result.when(
      success: (updated) {
        String title;
        String desc;
        if (newStatus == OrderStatus.preparing || newStatus == OrderStatus.accepted) {
          title = 'Order Accepted (#${order.orderNumber})';
          desc = 'Order moved to kitchen preparation queue.';
        } else if (newStatus == OrderStatus.ready) {
          title = 'Order Ready for Pickup (#${order.orderNumber})';
          desc = 'Assigned courier notified for immediate pickup.';
        } else {
          title = 'Order Status Updated (#${order.orderNumber})';
          desc = 'Order changed to ${newStatus.label}.';
        }

        context.read<NotificationController>().dispatchNotification(
          context,
          title: title,
          message: desc,
          type: NotificationType.order,
          relatedOrderId: order.id,
          toastVariant: AppToastVariant.success,
          actionLabel: 'Details',
          onAction: () => _openOrderDetails(order),
        );
      },
      failure: (msg, _) {
        AppToast.showError(context, title: 'Update Failed', message: msg);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final orderController = context.watch<OrderController>();
    final allOrders = orderController.allOrders;

    // Filter orders based on the 3 segmented tabs: Active, Completed, Cancelled
    final activeOrders = allOrders.where((o) =>
        o.status == OrderStatus.pending ||
        o.status == OrderStatus.accepted ||
        o.status == OrderStatus.preparing ||
        o.status == OrderStatus.ready).toList();

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
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
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
                    color: AppColors.primary,
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
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0F3A2E) : const Color(0xFFECFDF5),
                                borderRadius: AppRadius.full,
                              ),
                              child: Text(
                                '${activeOrders.length} Active',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF059669),
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
                              isDark: isDark,
                              onTap: () => setState(() => _selectedFilterIndex = 0),
                            ),
                            const SizedBox(width: 8),
                            _buildFilterPill(
                              label: 'Completed',
                              isSelected: _selectedFilterIndex == 1,
                              isDark: isDark,
                              onTap: () => setState(() => _selectedFilterIndex = 1),
                            ),
                            const SizedBox(width: 8),
                            _buildFilterPill(
                              label: 'Cancelled',
                              isSelected: _selectedFilterIndex == 2,
                              isDark: isDark,
                              onTap: () => setState(() => _selectedFilterIndex = 2),
                            ),
                          ],
                        ),

                        AppSpacing.vGap16,

                        // Empty State if no orders in selected tab
                        if (currentList.isEmpty)
                          EmptyStateView(
                            icon: Icons.receipt_long_outlined,
                            title: 'No ${_selectedFilterIndex == 0 ? 'Active' : _selectedFilterIndex == 1 ? 'Completed' : 'Cancelled'} Orders',
                            description: 'Orders will automatically appear here as they progress.',
                          )
                        else
                          // Orders List View
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
                                onQuickAction: (nextStatus) =>
                                    _handleQuickStatusChange(order, nextStatus),
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
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : AppColors.ctaPrimary)
              : (isDark ? const Color(0xFF232A34) : Colors.white),
          borderRadius: AppRadius.full,
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB)),
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
                ? (isDark ? AppColors.inkPrimary : Colors.white)
                : (isDark ? AppColors.textSecondaryDark : const Color(0xFF6B7280)),
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
