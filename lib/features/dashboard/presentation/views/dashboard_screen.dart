import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../../shared/components/error_state_view.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../orders/presentation/controllers/order_controller.dart';
import '../../../shop/presentation/controllers/shop_controller.dart';
import '../../../shop/presentation/widgets/shop_switcher_bottom_sheet.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/store_status_header.dart';
import '../widgets/hero_earnings_card.dart';
import '../widgets/metric_stats_grid.dart';
import '../widgets/quick_actions_bar.dart';
import '../widgets/incoming_orders_stream.dart';

/// Vendor Dashboard Screen strictly matching Stitch brief (`dashboard/code.html`)
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
    final notifController = context.watch<NotificationController>();
    final unreadCount = notifController.unreadCount;

    return Scaffold(
      backgroundColor: colors.surface,
      // Stitch Mobile Top App Bar
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
                Icons.storefront_rounded,
                size: 20,
                color: colors.primary,
              ),
            ),
          ),
        ),
        title: Text(
          'Merchant Portal',
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
      body: dashboardController.isLoading && dashboardController.metrics == null
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
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      120, // clearance for floating nav dock
                    ),
                    children: [
                      // 1. Store Header & Open/Closed Status Toggle
                      StoreStatusHeader(
                        onSwitchShopRequested: _showShopSwitcherModal,
                      ),

                      AppSpacing.vGap16,

                      // 2. Hero Earnings Card with Mini Bar Chart Graphic
                      HeroEarningsCard(
                        metrics: dashboardController.metrics,
                        onAnalyticsTapped: () => Navigator.of(context).pushNamed(AppRoutes.analytics),
                      ),

                      AppSpacing.vGap16,

                      // 3. 2-Column Stat Cards (Total Orders, Total Payouts)
                      MetricStatsGrid(
                        metrics: dashboardController.metrics,
                        onOrdersTapped: () => widget.onNavigateTab?.call(1),
                        onPayoutsTapped: () => Navigator.of(context).pushNamed(AppRoutes.analytics),
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
    );
  }
}

// Skeleton Loading placeholder matching Stitch Card layout
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
          ],
        ),
        AppSpacing.vGap16,
        ShimmerSkeleton(width: double.infinity, height: 50, borderRadius: AppRadius.md),
        AppSpacing.vGap16,
        ShimmerSkeleton(width: double.infinity, height: 180, borderRadius: AppRadius.lg),
        AppSpacing.vGap16,
        Row(
          children: [
            Expanded(child: ShimmerSkeleton(width: double.infinity, height: 100, borderRadius: AppRadius.md)),
            SizedBox(width: 14),
            Expanded(child: ShimmerSkeleton(width: double.infinity, height: 100, borderRadius: AppRadius.md)),
          ],
        ),
        AppSpacing.vGap16,
        ShimmerSkeleton(width: double.infinity, height: 42, borderRadius: AppRadius.full),
        AppSpacing.vGap20,
        ShimmerSkeleton(width: double.infinity, height: 140, borderRadius: AppRadius.md),
      ],
    );
  }
}
