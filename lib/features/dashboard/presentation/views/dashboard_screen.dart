import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/components/app_bottom_sheet.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../../shared/components/error_state_view.dart';
import '../../../../shared/models/shop_model.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../shop/presentation/controllers/shop_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/store_status_header.dart';
import '../widgets/hero_earnings_card.dart';
import '../widgets/metric_stats_grid.dart';
import '../widgets/sales_analytics_chart.dart';
import '../widgets/incoming_orders_stream.dart';

// Vendor Dashboard Screen (modern_ui_arif Card-First Architecture)
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

    final activeShop = authController.activeShop;
    if (activeShop != null) {
      shopController.setActiveShop(activeShop);
      dashboardController.loadDashboard(shopId: activeShop.id);
    }
  }

  void _showShopSwitcherModal() {
    final authController = context.read<AuthController>();
    final shopController = context.read<ShopController>();
    final availableShops = authController.availableShops;
    final currentShopId = shopController.currentShop?.id ?? authController.activeShop?.id;

    AppBottomSheet.show(
      context: context,
      title: 'Select Active Shop',
      subtitle: 'Switch between stores in your merchant portfolio',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: availableShops.map((shop) {
          final isSelected = shop.id == currentShopId;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () async {
                Navigator.of(context).pop();
                final result = await authController.switchShop(shop.id);
                result.when(
                  success: (session) {
                    shopController.setActiveShop(session.activeShop);
                    context.read<DashboardController>().loadDashboard(shopId: session.activeShop.id);
                  },
                  failure: (msg, _) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msg),
                        backgroundColor: AppColors.statusError,
                      ),
                    );
                  },
                );
              },
              borderRadius: AppRadius.md,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryTint : Colors.transparent,
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.borderLight,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.borderLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.storefront_rounded,
                        color: isSelected ? Colors.white : AppColors.inkSecondary,
                        size: 20,
                      ),
                    ),
                    AppSpacing.hGap12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shop.name,
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isSelected ? AppColors.primary : AppColors.inkPrimary,
                            ),
                          ),
                          Text(
                            shop.primaryCategory,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.inkSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
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
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
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

                        AppSpacing.vGap16,

                        // Sales Performance Bar Chart
                        SalesAnalyticsChart(
                          chartPoints: dashboardController.chartData,
                          selectedPeriod: dashboardController.selectedPeriod,
                          onPeriodChanged: (period) => dashboardController.setPeriod(period),
                        ),

                        AppSpacing.vGap16,

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
            const ShimmerSkeleton(width: 44, height: 44, borderRadius: 12),
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
            const ShimmerSkeleton(width: 70, height: 32, borderRadius: 16),
          ],
        ),
        AppSpacing.vGap16,
        const ShimmerSkeleton(width: double.infinity, height: 180, borderRadius: 24),
        AppSpacing.vGap16,
        Row(
          children: const [
            Expanded(child: ShimmerSkeleton(width: double.infinity, height: 110, borderRadius: 22)),
            SizedBox(width: 12),
            Expanded(child: ShimmerSkeleton(width: double.infinity, height: 110, borderRadius: 22)),
          ],
        ),
        AppSpacing.vGap16,
        const ShimmerSkeleton(width: double.infinity, height: 210, borderRadius: 24),
      ],
    );
  }
}
