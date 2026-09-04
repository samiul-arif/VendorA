import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_button.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../controllers/analytics_controller.dart';
import '../widgets/interactive_bar_chart.dart';
import '../widgets/payout_breakdown_bottom_sheet.dart';
import '../widgets/period_selector_pill.dart';
import '../widgets/top_performer_tile.dart';

// Standalone Analytics & Revenue Portal View matching Stitch Brief
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late final AnalyticsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ServiceLocator.instance.get<AnalyticsController>();
    if (_controller.summary == null) {
      _controller.loadAnalytics();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canvasBg = isDark ? const Color(0xFF101318) : const Color(0xFFF9F9FF);
    final surfaceColor = colors.surface;
    final borderColor = isDark ? const Color(0xFF2C3039) : const Color(0xFFDFE2EE);

    return Scaffold(
      backgroundColor: canvasBg,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: const Color.fromRGBO(21, 23, 28, 0.04),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Analytics',
          style: AppTypography.headlineSmall.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.file_download_outlined,
              color: colors.textSecondary,
            ),
            tooltip: 'Export Report',
            onPressed: () {
              final summary = _controller.summary;
              if (summary != null) {
                PayoutBreakdownBottomSheet.show(context, summary: summary);
              }
            },
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isLoading && _controller.summary == null) {
            return _buildSkeletonLoader(context, isDark);
          }

          final summary = _controller.summary;
          if (summary == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: colors.error,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _controller.errorMessage ?? 'Failed to load analytics',
                    style: AppTypography.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    text: 'Retry',
                    onPressed: () => _controller.loadAnalytics(),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _controller.refresh,
            color: colors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Period Selector Pill
                  Center(
                    child: PeriodSelectorPill(
                      selectedRange: _controller.selectedRange,
                      onRangeSelected: (range) => _controller.setPeriod(range),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // 2. Gross Revenue Hero Card
                  _buildGrossRevenueHeroCard(context, summary, isDark, colors, surfaceColor, borderColor),
                  const SizedBox(height: AppSpacing.lg),

                  // 3. Secondary Stats Grid
                  _buildSecondaryStatsGrid(context, summary, isDark, colors, surfaceColor, borderColor),
                  const SizedBox(height: AppSpacing.xl),

                  // 4. Interactive Revenue Bar Chart
                  InteractiveBarChart(
                    points: summary.chartPoints,
                    selectedIndex: _controller.selectedBarIndex,
                    onBarTapped: (index) => _controller.setSelectedBarIndex(index),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // 5. Top Performers Breakdown
                  _buildTopPerformersCard(context, summary, isDark, colors, surfaceColor, borderColor),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrossRevenueHeroCard(
    BuildContext context,
    dynamic summary,
    bool isDark,
    AppSemanticColors colors,
    Color surfaceColor,
    Color borderColor,
  ) {
    final emeraldBg = isDark ? const Color(0xFF00382C) : const Color(0xFFE0FAF2);
    final emeraldText = isDark ? const Color(0xFF75F9D6) : const Color(0xFF006B57);

    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: AppRadius.lg,
        border: Border.all(color: borderColor.withValues(alpha: 0.7), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(21, 23, 28, 0.04),
            offset: Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GROSS REVENUE',
            style: AppTypography.labelSmall.copyWith(
              color: colors.textSecondary,
              fontSize: 11.5,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              Formatters.formatCurrency(summary.grossRevenue),
              style: AppTypography.displayLarge.copyWith(
                color: colors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: emeraldBg,
                  borderRadius: AppRadius.full,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 15,
                      color: emeraldText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+${summary.revenueGrowthPercent.toStringAsFixed(1)}%',
                      style: AppTypography.labelSmall.copyWith(
                        color: emeraldText,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  summary.range.comparisonLabel,
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryStatsGrid(
    BuildContext context,
    dynamic summary,
    bool isDark,
    AppSemanticColors colors,
    Color surfaceColor,
    Color borderColor,
  ) {
    final emeraldText = isDark ? const Color(0xFF75F9D6) : const Color(0xFF006B57);
    final errorText = isDark ? const Color(0xFFFFB4AB) : const Color(0xFFBA1A1A);

    return Column(
      children: [
        // 2-Col row: Total Orders & Avg Order Value (Responsive)
        Row(
          children: [
            // Total Orders
            Expanded(
              child: Container(
                padding: AppSpacing.cardPadding,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: AppRadius.lg,
                  border: Border.all(color: borderColor.withValues(alpha: 0.7), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(21, 23, 28, 0.04),
                      offset: Offset(0, 4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'TOTAL ORDERS',
                            style: AppTypography.labelSmall.copyWith(
                              color: colors.textSecondary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 16,
                          color: colors.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${summary.totalOrders}',
                        style: AppTypography.headlineMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                          fontSize: 20,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          summary.isOrdersGrowthPositive
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 13,
                          color: summary.isOrdersGrowthPositive ? emeraldText : errorText,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${summary.ordersGrowthPercent.toStringAsFixed(0)}%',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 11,
                            color: summary.isOrdersGrowthPositive ? emeraldText : errorText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14.0),

            // Avg Order Value
            Expanded(
              child: Container(
                padding: AppSpacing.cardPadding,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: AppRadius.lg,
                  border: Border.all(color: borderColor.withValues(alpha: 0.7), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(21, 23, 28, 0.04),
                      offset: Offset(0, 4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'AVG ORDER VALUE',
                            style: AppTypography.labelSmall.copyWith(
                              color: colors.textSecondary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 16,
                          color: colors.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Formatters.formatCurrency(summary.avgOrderValue),
                        style: AppTypography.headlineMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                          fontSize: 20,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          summary.isAovGrowthPositive
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 13,
                          color: summary.isAovGrowthPositive ? emeraldText : errorText,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${summary.aovGrowthPercent.toStringAsFixed(1)}%',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 11,
                            color: summary.isAovGrowthPositive ? emeraldText : errorText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14.0),

        // Total Payouts (Pending) Card with "VIEW DETAILS" (Responsive & No Overlap)
        Container(
          width: double.infinity,
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: AppRadius.lg,
            border: Border.all(color: borderColor.withValues(alpha: 0.7), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(21, 23, 28, 0.04),
                offset: Offset(0, 4),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL PAYOUTS (PENDING)',
                    style: AppTypography.labelSmall.copyWith(
                      color: colors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Icon(
                    Icons.account_balance_outlined,
                    size: 17,
                    color: colors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Formatters.formatCurrency(summary.pendingPayouts),
                        style: AppTypography.headlineMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                          fontSize: 22,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => PayoutBreakdownBottomSheet.show(context, summary: summary),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Text(
                        'VIEW DETAILS',
                        style: AppTypography.labelSmall.copyWith(
                          color: colors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopPerformersCard(
    BuildContext context,
    dynamic summary,
    bool isDark,
    AppSemanticColors colors,
    Color surfaceColor,
    Color borderColor,
  ) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: AppRadius.lg,
        border: Border.all(color: borderColor.withValues(alpha: 0.7), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(21, 23, 28, 0.04),
            offset: Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Performers',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              Flexible(
                child: Text(
                  'THIS ${summary.range.label.toUpperCase()}',
                  style: AppTypography.labelSmall.copyWith(
                    color: colors.textSecondary,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Divider(color: borderColor.withValues(alpha: 0.5)),
          const SizedBox(height: AppSpacing.sm),

          // Items List
          ...summary.topPerformers.map<Widget>((item) => TopPerformerTile(item: item)),
          const SizedBox(height: AppSpacing.md),

          // View All Products Button
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.products);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(64, 46),
                side: BorderSide(color: borderColor, width: 1),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.md,
                ),
              ),
              child: Text(
                'VIEW ALL PRODUCTS',
                style: AppTypography.labelSmall.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader(BuildContext context, bool isDark) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          ShimmerSkeleton(height: 42, width: 240, borderRadius: AppRadius.full),
          SizedBox(height: AppSpacing.xl),
          ShimmerSkeleton(height: 140, width: double.infinity, borderRadius: AppRadius.card),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: ShimmerSkeleton(height: 110, borderRadius: AppRadius.card)),
              SizedBox(width: AppSpacing.md),
              Expanded(child: ShimmerSkeleton(height: 110, borderRadius: AppRadius.card)),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          ShimmerSkeleton(height: 220, width: double.infinity, borderRadius: AppRadius.card),
        ],
      ),
    );
  }
}
