import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../../shared/components/error_state_view.dart';
import '../../../../shared/components/shared_select_modal.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../orders/presentation/controllers/order_controller.dart';
import '../../../shop/presentation/controllers/shop_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/store_status_header.dart';
import '../widgets/hero_earnings_card.dart';
import '../widgets/metric_stats_grid.dart';
import '../widgets/incoming_orders_stream.dart';

// Vendor Dashboard Screen (modern_ui_arif Card-First Architecture - Revenue Chart Removed)
class DashboardScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;

  const DashboardScreen({
    super.key,
    this.onNavigateTab,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  void _loadDashboardData() {
    final authController = context.read<AuthController>();
    final dashboardController = context.read<DashboardController>();
    final shopController = context.read<ShopController>();
    final orderController = context.read<OrderController>();

    final shopId = authController.activeShop?.id ?? 'shop_01';
    final activeShop = authController.activeShop;

    if (activeShop != null) {
      shopController.setActiveShop(activeShop);
    }
    dashboardController.loadDashboard(shopId: shopId);
    orderController.loadOrders(shopId: shopId);
  }

  void _showShopSwitcherModal() async {
    final authController = context.read<AuthController>();
    final shopController = context.read<ShopController>();
    final availableShops = authController.availableShops;
    final currentShopId = shopController.currentShop?.id ?? authController.activeShop?.id ?? 'shop_01';

    final options = availableShops.map((s) {
      return SelectOptionItem<String>(
        value: s.id,
        title: s.name,
        subtitle: s.description,
        icon: Icons.storefront_rounded,
      );
    }).toList();

    final selectedId = await SharedSelectModal.show<String>(
      context: context,
      title: 'Active Shop Switcher',
      subtitle: 'Switch between stores in your merchant portfolio',
      options: options,
      selectedValue: currentShopId,
    );

    if (selectedId != null && selectedId != currentShopId) {
      final result = await authController.switchShop(selectedId);
      result.when(
        success: (session) {
          if (session.activeShop != null) {
            shopController.setActiveShop(session.activeShop!);
            context.read<DashboardController>().loadDashboard(shopId: session.activeShop!.id);
            context.read<OrderController>().loadOrders(shopId: session.activeShop!.id);
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Switched store to "${session.activeShop?.name ?? ''}"'),
                backgroundColor: AppColors.statusSuccess,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        failure: (msg, _) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: AppColors.statusError,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dashboardController = context.watch<DashboardController>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
      body: SafeArea(
        bottom: false,
        child: dashboardController.isLoading && dashboardController.metrics == null
            ? const _DashboardSkeletonLoading()
            : dashboardController.hasError && dashboardController.metrics == null
                ? ErrorStateView(
                    message: dashboardController.errorMessage ?? 'Failed to load store metrics.',
                    onRetry: _loadDashboardData,
                  )
                : RefreshIndicator(
                    onRefresh: () => dashboardController.refreshDashboard(),
                    color: AppColors.primary,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                      children: [
                        // Store Header & Status Toggle
                        StoreStatusHeader(
                          onSwitchShopRequested: _showShopSwitcherModal,
                        ),

                        AppSpacing.vGap16,

                        // Hero Net Revenue Banner
                        HeroEarningsCard(
                          metrics: dashboardController.metrics,
                          onAnalyticsTapped: () => widget.onNavigateTab?.call(0),
                        ),

                        AppSpacing.vGap16,

                        // 2-Column Stat Cards (Active Orders, Next Payout)
                        MetricStatsGrid(
                          metrics: dashboardController.metrics,
                          onOrdersTapped: () => widget.onNavigateTab?.call(1),
                          onPayoutsTapped: () => widget.onNavigateTab?.call(0),
                        ),

                        AppSpacing.vGap20,

                        // Incoming Orders Live Stream
                        IncomingOrdersStream(
                          onViewAllTapped: () => widget.onNavigateTab?.call(1),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

// Skeleton Placeholder during initial load
class _DashboardSkeletonLoading extends StatelessWidget {
  const _DashboardSkeletonLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        Row(
          children: [
            const ShimmerSkeleton(width: 44, height: 44, borderRadius: AppRadius.md),
            AppSpacing.hGap12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerSkeleton(width: 100, height: 12),
                  SizedBox(height: 6),
                  ShimmerSkeleton(width: 180, height: 18),
                ],
              ),
            ),
            const ShimmerSkeleton(width: 70, height: 32, borderRadius: AppRadius.full),
          ],
        ),
        AppSpacing.vGap16,
        const ShimmerSkeleton(width: double.infinity, height: 180, borderRadius: AppRadius.card),
        AppSpacing.vGap16,
        Row(
          children: const [
            Expanded(child: ShimmerSkeleton(width: double.infinity, height: 110, borderRadius: AppRadius.card)),
            SizedBox(width: 12),
            Expanded(child: ShimmerSkeleton(width: double.infinity, height: 110, borderRadius: AppRadius.card)),
          ],
        ),
      ],
    );
  }
}
