import '../../../../core/utils/result.dart';
import '../models/dashboard_metrics.dart';
import '../models/sales_chart_point.dart';

// Dashboard Repository Contract
abstract class IDashboardRepository {
  // Get summary metrics for active shop
  Future<Result<DashboardMetrics>> getDashboardSummary({
    required String shopId,
  });

  // Get sales chart points for specific period (weekly, monthly)
  Future<Result<List<SalesChartPoint>>> getSalesAnalytics({
    required String shopId,
    String period = 'weekly',
  });

  // Refresh dashboard metrics
  Future<Result<DashboardMetrics>> refreshMetrics({
    required String shopId,
  });
}
