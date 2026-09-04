import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/components/app_pagination_bar.dart';
import '../../../../shared/components/error_state_view.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_status.dart';
import '../controllers/order_controller.dart';
import '../widgets/order_card.dart';
import 'order_details_screen.dart';

/// Order Management Screen strictly matching Stitch brief (`orders_list/code.html` & `orders_empty_state/code.html`)
/// with Fixed Top App Bar & Filter Bar, Paginated Orders List, and Bottom Pagination Bar.
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
    if (!mounted) return;
    final authController = context.read<AuthController>();
    final orderController = context.read<OrderController>();
    final shopId = authController.activeShop?.id ?? 'shop_01';
    orderController.loadOrders(shopId: shopId);
  }

  void _onFilterTabChanged(int index) {
    setState(() => _selectedFilterIndex = index);
    final orderController = context.read<OrderController>();
    if (index == 0) {
      orderController.setStatusFilter(OrderStatus.all);
    } else if (index == 1) {
      orderController.setStatusFilter(OrderStatus.delivered);
    } else {
      orderController.setStatusFilter(OrderStatus.cancelled);
    }
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
        message: 'Order #${order.orderNumber} marked ready for pickup.',
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
    final isDark = context.isDark;
    final orderController = context.watch<OrderController>();
    final notifController = context.watch<NotificationController>();
    final unreadCount = notifController.unreadCount;
    final currentOrders = orderController.filteredOrders;

    final activeCount = orderController.getCount(OrderStatus.pending) +
        orderController.getCount(OrderStatus.accepted) +
        orderController.getCount(OrderStatus.preparing) +
        orderController.getCount(OrderStatus.ready);
    final completedCount = orderController.getCount(OrderStatus.delivered);
    final cancelledCount = orderController.getCount(OrderStatus.cancelled);

    return Scaffold(
      backgroundColor: colors.surface,
      // 1. Top App Bar with Order Related Logo & "Orders" title
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                size: 20,
                color: colors.primary,
              ),
            ),
          ),
        ),
        title: Text(
          'Orders',
          style: AppTypography.headlineMedium.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.notifications);
            },
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: colors.textPrimary,
                  size: 24,
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colors.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.surface, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.hGap8,
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 2. Fixed/Pinned Segmented Control Filter (Active / Completed / Cancelled)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xs,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.surfaceLow,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Row(
                  children: [
                    _buildSegmentTab(
                      index: 0,
                      label: 'Active',
                      count: activeCount,
                      isSelected: _selectedFilterIndex == 0,
                      colors: colors,
                      isDark: isDark,
                    ),
                    _buildSegmentTab(
                      index: 1,
                      label: 'Completed',
                      count: completedCount,
                      isSelected: _selectedFilterIndex == 1,
                      colors: colors,
                      isDark: isDark,
                    ),
                    _buildSegmentTab(
                      index: 2,
                      label: 'Cancelled',
                      count: cancelledCount,
                      isSelected: _selectedFilterIndex == 2,
                      colors: colors,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),

            // 3. Scrollable Order List + Bottom Pagination Bar
            Expanded(
              child: orderController.isLoading && currentOrders.isEmpty
                  ? const _OrderListSkeleton()
                  : orderController.hasError && currentOrders.isEmpty
                      ? ErrorStateView(
                          message: orderController.errorMessage ?? 'Failed to load orders.',
                          onRetry: _loadOrders,
                        )
                      : RefreshIndicator(
                          onRefresh: () async => _loadOrders(),
                          color: colors.primary,
                          child: currentOrders.isEmpty
                              ? ListView(
                                  padding: const EdgeInsets.fromLTRB(
                                    AppSpacing.lg,
                                    AppSpacing.xs,
                                    AppSpacing.lg,
                                    120,
                                  ),
                                  children: [
                                    _buildEmptyState(colors, isDark),
                                  ],
                                )
                              : CustomScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  slivers: [
                                    SliverPadding(
                                      padding: const EdgeInsets.fromLTRB(
                                        AppSpacing.lg,
                                        AppSpacing.xs,
                                        AppSpacing.lg,
                                        AppSpacing.xs,
                                      ),
                                      sliver: SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            final order = currentOrders[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 12.0),
                                              child: OrderCard(
                                                order: order,
                                                onTap: () => _openOrderDetails(order),
                                                onAccept: () => _handleAcceptOrder(order),
                                                onReady: () => _handleMarkReady(order),
                                                onDecline: () => _handleDeclineOrder(order),
                                              ),
                                            );
                                          },
                                          childCount: currentOrders.length,
                                        ),
                                      ),
                                    ),
                                    SliverPadding(
                                      padding: const EdgeInsets.fromLTRB(
                                        AppSpacing.lg,
                                        0,
                                        AppSpacing.lg,
                                        130, // clearance for floating nav dock
                                      ),
                                      sliver: SliverToBoxAdapter(
                                        child: AppPaginationBar(
                                          pagination: orderController.paginatedOrders,
                                          itemLabelPlural: 'orders',
                                          isLoading: orderController.isLoading,
                                          onPageChanged: (newPage) => orderController.goToPage(newPage),
                                          onPageSizeChanged: (newSize) => orderController.setPageSize(newSize),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
            ),
          ],
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
    required bool isDark,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onFilterTabChanged(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? colors.surface : Colors.transparent,
            borderRadius: AppRadius.sm,
            boxShadow: isSelected ? (isDark ? AppShadows.darkCard : AppShadows.card) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? colors.textPrimary : colors.textSecondary,
                    fontSize: 12.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.primary.withValues(alpha: 0.12) : colors.surfaceSubtle,
                    borderRadius: AppRadius.full,
                  ),
                  child: Text(
                    count >= 1000 ? '${(count / 1000).toStringAsFixed(1)}k' : '$count',
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 9.5,
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

  Widget _buildEmptyState(AppSemanticColors colors, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: colors.borderSubtle),
        boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Illustration Circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.surfaceLow,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 40,
              color: colors.textMuted,
            ),
          ),
          AppSpacing.vGap20,
          Text(
            'No active orders yet',
            style: AppTypography.headlineMedium.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.vGap6,
          Text(
            'When you receive new orders, they\'ll appear here for you to manage and process.',
            style: AppTypography.bodyMedium.copyWith(
              color: colors.textSecondary,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.vGap24,
          ElevatedButton(
            onPressed: _loadOrders,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.ctaPrimary,
              foregroundColor: colors.ctaPrimaryText,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.full,
              ),
              elevation: 0,
            ),
            child: Text(
              'Refresh Status',
              style: AppTypography.labelMedium.copyWith(
                color: colors.ctaPrimaryText,
                fontWeight: FontWeight.w700,
              ),
            ),
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
        ShimmerSkeleton(width: double.infinity, height: 130, borderRadius: AppRadius.md),
        AppSpacing.vGap12,
        ShimmerSkeleton(width: double.infinity, height: 130, borderRadius: AppRadius.md),
        AppSpacing.vGap12,
        ShimmerSkeleton(width: double.infinity, height: 130, borderRadius: AppRadius.md),
      ],
    );
  }
}
