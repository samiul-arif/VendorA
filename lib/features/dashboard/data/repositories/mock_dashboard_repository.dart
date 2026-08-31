import '../../../../core/network/base_mock_repository.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/dashboard_metrics.dart';
import '../../domain/models/sales_chart_point.dart';
import '../../domain/repositories/dashboard_repository_interface.dart';

// Mock Dashboard Repository with Realistic Analytics Engine
class MockDashboardRepository extends BaseMockRepository implements IDashboardRepository {
  DashboardMetrics _inMemoryMetrics = DashboardMetrics(
    totalEarningsToday: 1420.50,
    earningsGrowthPercentage: 14.2,
    totalOrdersToday: 24,
    activeOrdersCount: 18,
    averageTicketSize: 59.18,
    weeklyEarnings: 8940.00,
    nextPayoutAmount: 8940.00,
    storeRating: 4.9,
    totalReviews: 328,
    lastUpdated: DateTime.now(),
  );

  static final List<SalesChartPoint> _weeklyChartData = [
    const SalesChartPoint(label: 'Mon', amount: 980.00, orderCount: 16),
    const SalesChartPoint(label: 'Tue', amount: 1150.00, orderCount: 19),
    const SalesChartPoint(label: 'Wed', amount: 1420.50, orderCount: 24, isCurrentDay: true),
    const SalesChartPoint(label: 'Thu', amount: 890.00, orderCount: 14),
    const SalesChartPoint(label: 'Fri', amount: 1680.00, orderCount: 28),
    const SalesChartPoint(label: 'Sat', amount: 2140.00, orderCount: 36),
    const SalesChartPoint(label: 'Sun', amount: 1890.00, orderCount: 31),
  ];

  static final List<SalesChartPoint> _monthlyChartData = [
    const SalesChartPoint(label: 'Week 1', amount: 7450.00, orderCount: 120),
    const SalesChartPoint(label: 'Week 2', amount: 8200.00, orderCount: 138),
    const SalesChartPoint(label: 'Week 3', amount: 8940.00, orderCount: 152, isCurrentDay: true),
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
