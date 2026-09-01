import '../../../../core/network/base_mock_repository.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/analytics_summary_model.dart';
import '../../domain/models/analytics_time_range.dart';
import '../../domain/models/dashboard_metrics.dart';
import '../../domain/models/sales_chart_point.dart';
import '../../domain/repositories/dashboard_repository_interface.dart';

// Mock Dashboard Repository with Realistic Analytics Engine
class MockDashboardRepository extends BaseMockRepository
    implements IDashboardRepository {
  DashboardMetrics _inMemoryMetrics = DashboardMetrics(
    totalEarningsToday: 1420.50,
    earningsGrowthPercentage: 14.2,
    totalOrdersToday: 24,
    activeOrdersCount: 18,
    averageTicketSize: 59.18,
    weeklyEarnings: 8940.00,
    nextPayoutAmount: 8940.00,
    fulfillmentRate: 98.5,
    lastUpdated: DateTime.now(),
  );

  static final List<SalesChartPoint> _weeklyChartData = [
    const SalesChartPoint(label: 'Mon', amount: 980.00, orderCount: 16),
    const SalesChartPoint(label: 'Tue', amount: 1150.00, orderCount: 19),
    const SalesChartPoint(
        label: 'Wed', amount: 1420.50, orderCount: 24, isCurrentDay: true),
    const SalesChartPoint(label: 'Thu', amount: 890.00, orderCount: 14),
    const SalesChartPoint(label: 'Fri', amount: 1680.00, orderCount: 28),
    const SalesChartPoint(label: 'Sat', amount: 2140.00, orderCount: 36),
    const SalesChartPoint(label: 'Sun', amount: 1890.00, orderCount: 31),
  ];

  static final List<SalesChartPoint> _monthlyChartData = [
    const SalesChartPoint(label: 'Week 1', amount: 7450.00, orderCount: 120),
    const SalesChartPoint(label: 'Week 2', amount: 8200.00, orderCount: 138),
    const SalesChartPoint(
        label: 'Week 3', amount: 8940.00, orderCount: 152, isCurrentDay: true),
    const SalesChartPoint(label: 'Week 4', amount: 9100.00, orderCount: 160),
  ];

  @override
  Future<Result<DashboardMetrics>> getDashboardSummary({
    required String shopId,
  }) async {
    return executeMock(
      operation: () async => _inMemoryMetrics,
      customDelayMs: 450,
    );
  }

  @override
  Future<Result<List<SalesChartPoint>>> getSalesAnalytics({
    required String shopId,
    String period = 'weekly',
  }) async {
    return executeMock(
      operation: () async {
        if (period == 'monthly') {
          return _monthlyChartData;
        }
        return _weeklyChartData;
      },
      customDelayMs: 350,
    );
  }

  @override
  Future<Result<AnalyticsSummaryModel>> getAnalyticsSummary({
    required String shopId,
    required AnalyticsTimeRange range,
  }) async {
    return executeMock(
      operation: () async {
        switch (range) {
          case AnalyticsTimeRange.today:
            return const AnalyticsSummaryModel(
              range: AnalyticsTimeRange.today,
              grossRevenue: 1420.50,
              revenueGrowthPercent: 12.4,
              isRevenueGrowthPositive: true,
              totalOrders: 48,
              ordersGrowthPercent: 9.5,
              isOrdersGrowthPositive: true,
              avgOrderValue: 29.60,
              aovGrowthPercent: 3.1,
              isAovGrowthPositive: true,
              pendingPayouts: 1420.50,
              settledPayouts: 12850.00,
              nextPayoutDate: 'Tomorrow, 10:00 AM',
              bankAccountMasked: 'City Bank •••• 4892',
              chartPoints: [
                RevenueBarPoint(label: '8AM', amount: 120.0, targetPercentage: 0.25),
                RevenueBarPoint(label: '11AM', amount: 340.0, targetPercentage: 0.65),
                RevenueBarPoint(label: '2PM', amount: 520.5, targetPercentage: 0.95, isHighlight: true),
                RevenueBarPoint(label: '5PM', amount: 280.0, targetPercentage: 0.50),
                RevenueBarPoint(label: '8PM', amount: 160.0, targetPercentage: 0.35),
              ],
              topPerformers: [
                TopPerformerItem(
                  id: 'p1',
                  title: 'Classic Artisan Burger',
                  imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
                  ordersCount: 22,
                  totalRevenue: 286.00,
                  growthPercentage: 18.0,
                  isGrowthPositive: true,
                ),
                TopPerformerItem(
                  id: 'p2',
                  title: 'Spicy Pepperoni Pizza XL',
                  imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400&q=80',
                  ordersCount: 15,
                  totalRevenue: 240.00,
                  growthPercentage: 6.5,
                  isGrowthPositive: true,
                ),
              ],
            );
          case AnalyticsTimeRange.week:
            return const AnalyticsSummaryModel(
              range: AnalyticsTimeRange.week,
              grossRevenue: 12450.00,
              revenueGrowthPercent: 18.5,
              isRevenueGrowthPositive: true,
              totalOrders: 342,
              ordersGrowthPercent: 12.0,
              isOrdersGrowthPositive: true,
              avgOrderValue: 36.40,
              aovGrowthPercent: 2.1,
              isAovGrowthPositive: false,
              pendingPayouts: 9850.50,
              settledPayouts: 34200.00,
              nextPayoutDate: 'Friday, Oct 24',
              bankAccountMasked: 'City Bank •••• 4892',
              chartPoints: [
                RevenueBarPoint(label: 'Mon', amount: 1200.0, targetPercentage: 0.40),
                RevenueBarPoint(label: 'Tue', amount: 2550.0, targetPercentage: 0.85, isHighlight: true),
                RevenueBarPoint(label: 'Wed', amount: 1800.0, targetPercentage: 0.60),
                RevenueBarPoint(label: 'Thu', amount: 2250.0, targetPercentage: 0.75),
                RevenueBarPoint(label: 'Fri', amount: 2850.0, targetPercentage: 0.95),
                RevenueBarPoint(label: 'Sat', amount: 3000.0, targetPercentage: 1.00),
                RevenueBarPoint(label: 'Sun', amount: 1500.0, targetPercentage: 0.50),
              ],
              topPerformers: [
                TopPerformerItem(
                  id: 'p1',
                  title: 'Classic Artisan Burger',
                  imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
                  ordersCount: 142,
                  totalRevenue: 1846.00,
                  growthPercentage: 14.0,
                  isGrowthPositive: true,
                ),
                TopPerformerItem(
                  id: 'p2',
                  title: 'Spicy Pepperoni Pizza XL',
                  imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400&q=80',
                  ordersCount: 98,
                  totalRevenue: 1568.00,
                  growthPercentage: 8.0,
                  isGrowthPositive: true,
                ),
                TopPerformerItem(
                  id: 'p3',
                  title: 'Summer Green Salad',
                  imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&q=80',
                  ordersCount: 85,
                  totalRevenue: 765.00,
                  growthPercentage: 0.0,
                  isGrowthPositive: true,
                ),
              ],
            );
          case AnalyticsTimeRange.month:
            return const AnalyticsSummaryModel(
              range: AnalyticsTimeRange.month,
              grossRevenue: 48920.00,
              revenueGrowthPercent: 22.8,
              isRevenueGrowthPositive: true,
              totalOrders: 1480,
              ordersGrowthPercent: 16.4,
              isOrdersGrowthPositive: true,
              avgOrderValue: 33.05,
              aovGrowthPercent: 4.5,
              isAovGrowthPositive: true,
              pendingPayouts: 14200.00,
              settledPayouts: 112500.00,
              nextPayoutDate: 'Nov 1, 2026',
              bankAccountMasked: 'City Bank •••• 4892',
              chartPoints: [
                RevenueBarPoint(label: 'W1', amount: 11200.0, targetPercentage: 0.65),
                RevenueBarPoint(label: 'W2', amount: 12800.0, targetPercentage: 0.75),
                RevenueBarPoint(label: 'W3', amount: 14920.0, targetPercentage: 0.95, isHighlight: true),
                RevenueBarPoint(label: 'W4', amount: 10000.0, targetPercentage: 0.60),
              ],
              topPerformers: [
                TopPerformerItem(
                  id: 'p1',
                  title: 'Classic Artisan Burger',
                  imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
                  ordersCount: 560,
                  totalRevenue: 7280.00,
                  growthPercentage: 21.0,
                  isGrowthPositive: true,
                ),
                TopPerformerItem(
                  id: 'p2',
                  title: 'Spicy Pepperoni Pizza XL',
                  imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400&q=80',
                  ordersCount: 410,
                  totalRevenue: 6560.00,
                  growthPercentage: 11.2,
                  isGrowthPositive: true,
                ),
                TopPerformerItem(
                  id: 'p3',
                  title: 'Summer Green Salad',
                  imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&q=80',
                  ordersCount: 310,
                  totalRevenue: 2790.00,
                  growthPercentage: 5.0,
                  isGrowthPositive: true,
                ),
              ],
            );
          case AnalyticsTimeRange.custom:
            return const AnalyticsSummaryModel(
              range: AnalyticsTimeRange.custom,
              grossRevenue: 28400.00,
              revenueGrowthPercent: 14.1,
              isRevenueGrowthPositive: true,
              totalOrders: 820,
              ordersGrowthPercent: 8.9,
              isOrdersGrowthPositive: true,
              avgOrderValue: 34.63,
              aovGrowthPercent: 1.8,
              isAovGrowthPositive: true,
              pendingPayouts: 8400.00,
              settledPayouts: 65000.00,
              nextPayoutDate: 'Custom Cycle',
              bankAccountMasked: 'City Bank •••• 4892',
              chartPoints: [
                RevenueBarPoint(label: 'P1', amount: 6200.0, targetPercentage: 0.55),
                RevenueBarPoint(label: 'P2', amount: 8900.0, targetPercentage: 0.85, isHighlight: true),
                RevenueBarPoint(label: 'P3', amount: 7300.0, targetPercentage: 0.70),
                RevenueBarPoint(label: 'P4', amount: 6000.0, targetPercentage: 0.50),
              ],
              topPerformers: [
                TopPerformerItem(
                  id: 'p1',
                  title: 'Classic Artisan Burger',
                  imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
                  ordersCount: 340,
                  totalRevenue: 4420.00,
                  growthPercentage: 15.0,
                  isGrowthPositive: true,
                ),
              ],
            );
        }
      },
      customDelayMs: 400,
    );
  }

  @override
  Future<Result<DashboardMetrics>> refreshMetrics({
    required String shopId,
  }) async {
    return executeMock(
      operation: () async {
        _inMemoryMetrics = _inMemoryMetrics.copyWith(
          totalEarningsToday: _inMemoryMetrics.totalEarningsToday + 34.50,
          totalOrdersToday: _inMemoryMetrics.totalOrdersToday + 1,
          lastUpdated: DateTime.now(),
        );
        return _inMemoryMetrics;
      },
      customDelayMs: 500,
    );
  }
}
