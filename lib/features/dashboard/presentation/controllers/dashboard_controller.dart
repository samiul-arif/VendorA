import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/dashboard_metrics.dart';
import '../../domain/models/sales_chart_point.dart';
import '../../domain/usecases/get_dashboard_metrics_usecase.dart';
import '../../domain/usecases/get_sales_chart_usecase.dart';

// Dashboard & Analytics Controller
class DashboardController extends BaseController {
  final GetDashboardMetricsUseCase _getMetricsUseCase;
  final GetSalesChartUseCase _getSalesChartUseCase;

  DashboardMetrics? _metrics;
  List<SalesChartPoint> _chartData = [];
  String _selectedPeriod = 'weekly';
  String? _activeShopId;

  DashboardController({
    required GetDashboardMetricsUseCase getMetricsUseCase,
    required GetSalesChartUseCase getSalesChartUseCase,
  })  : _getMetricsUseCase = getMetricsUseCase,
        _getSalesChartUseCase = getSalesChartUseCase;

  // Getters
  DashboardMetrics? get metrics => _metrics;
  List<SalesChartPoint> get chartData => _chartData;
  String get selectedPeriod => _selectedPeriod;

  // Load Initial Dashboard State
  Future<void> loadDashboard({required String shopId}) async {
    _activeShopId = shopId;

    await runWithState<void>(() async {
      final metricsResult = await _getMetricsUseCase.execute(shopId: shopId);
      final chartResult = await _getSalesChartUseCase.execute(
        shopId: shopId,
        period: _selectedPeriod,
      );

      if (metricsResult is Success<DashboardMetrics>) {
        _metrics = metricsResult.data;
      }
      if (chartResult is Success<List<SalesChartPoint>>) {
        _chartData = chartResult.data;
      }

      if (metricsResult is Failure) {
        return Failure(metricsResult.message);
      }
      return const Success(null);
    });
  }

  // Pull-to-Refresh Dashboard
  Future<void> refreshDashboard() async {
    if (_activeShopId == null) return;

    final metricsResult = await _getMetricsUseCase.execute(
      shopId: _activeShopId!,
      forceRefresh: true,
    );

    if (metricsResult is Success<DashboardMetrics>) {
      _metrics = metricsResult.data;
      notifyListeners();
    }
  }

  // Switch Chart Period (Weekly vs Monthly)
  Future<void> setPeriod(String period) async {
    if (_selectedPeriod == period || _activeShopId == null) return;
    _selectedPeriod = period;

    final chartResult = await _getSalesChartUseCase.execute(
      shopId: _activeShopId!,
      period: period,
    );

    if (chartResult is Success<List<SalesChartPoint>>) {
      _chartData = chartResult.data;
      notifyListeners();
    }
  }
}
