import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../../shared/components/error_state_view.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../orders/presentation/controllers/order_controller.dart';
import '../../../shop/presentation/controllers/shop_controller.dart';
import '../../../shop/presentation/widgets/shop_switcher_bottom_sheet.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/store_status_header.dart';
import '../widgets/hero_earnings_card.dart';
import '../widgets/metric_stats_grid.dart';
import '../widgets/quick_actions_bar.dart';
import '../widgets/incoming_orders_stream.dart';

/// Vendor Dashboard Screen matching Stitch brief (`dashboard/code.html`)
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

  void _showShopSwitcherModal() {
    ShopSwitcherBottomSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final dashboardController = context.watch<DashboardController>();

    return Scaffold(
      backgroundColor: colors.surface,
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
                    color: colors.primary,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 120),
                      children: [
                        // 1. Store Header & Open/Closed Status Toggle
                        StoreStatusHeader(
                          onSwitchShopRequested: _showShopSwitcherModal,
                        ),

                        AppSpacing.vGap16,

                        // 2. Hero Earnings Card with Mini Bar Chart Graphic
                        HeroEarningsCard(
                          metrics: dashboardController.metrics,
                          onAnalyticsTapped: () => widget.onNavigateTab?.call(0),
                        ),

                        AppSpacing.vGap16,

                        // 3. 2-Column Stat Cards (Total Orders, Total Payouts)
                        MetricStatsGrid(
                          metrics: dashboardController.metrics,
                          onOrdersTapped: () => widget.onNavigateTab?.call(1),
                          onPayoutsTapped: () => widget.onNavigateTab?.call(0),
                        ),

                        AppSpacing.vGap16,

                        // 4. Quick Action Chips (Add Product, View Products, Categories)
                        QuickActionsBar(
                          onNavigateTab: widget.onNavigateTab,
                        ),

                        AppSpacing.vGap20,

                        // 5. Active Orders Section
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
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 96),
      children: const [
        Row(
          children: [
            ShimmerSkeleton(width: 48, height: 48, borderRadius: AppRadius.full),
            AppSpacing.hGap12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerSkeleton(width: 100, height: 12),
                  SizedBox(height: 6),
                  ShimmerSkeleton(width: 180, height: 18),
                ],
              ),
            ),
            ShimmerSkeleton(width: 40, height: 40, borderRadius: AppRadius.full),
          ],
        ),
        AppSpacing.vGap16,
        ShimmerSkeleton(width: double.infinity, height: 180, borderRadius: AppRadius.card),
        AppSpacing.vGap16,
        Row(
          children: [
            Expanded(child: ShimmerSkeleton(width: double.infinity, height: 100, borderRadius: AppRadius.card)),
            SizedBox(width: 14),
            Expanded(child: ShimmerSkeleton(width: double.infinity, height: 100, borderRadius: AppRadius.card)),
          ],
        ),
        AppSpacing.vGap16,
        ShimmerSkeleton(width: double.infinity, height: 42, borderRadius: AppRadius.full),
        AppSpacing.vGap20,
        ShimmerSkeleton(width: double.infinity, height: 140, borderRadius: AppRadius.card),
      ],
    );
  }
}
