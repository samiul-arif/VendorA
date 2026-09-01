import '../../../../core/utils/result.dart';
import '../models/analytics_summary_model.dart';
import '../models/analytics_time_range.dart';
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

  // Get full standalone analytics summary for specific time range
  Future<Result<AnalyticsSummaryModel>> getAnalyticsSummary({
    required String shopId,
    required AnalyticsTimeRange range,
  });

  // Refresh dashboard metrics
  Future<Result<DashboardMetrics>> refreshMetrics({
    required String shopId,
  });
}
