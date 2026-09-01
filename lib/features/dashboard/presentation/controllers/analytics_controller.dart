import '../../../../core/base/base_controller.dart';
import '../../domain/models/analytics_summary_model.dart';
import '../../domain/models/analytics_time_range.dart';
import '../../domain/usecases/get_analytics_summary_usecase.dart';

// Analytics & Performance Portal Controller
class AnalyticsController extends BaseController {
  final GetAnalyticsSummaryUseCase _getAnalyticsSummaryUseCase;

  AnalyticsTimeRange _selectedRange = AnalyticsTimeRange.week;
  AnalyticsSummaryModel? _summary;
  int? _selectedBarIndex;
  String _activeShopId = 'shop_001';

  AnalyticsController({
    required GetAnalyticsSummaryUseCase getAnalyticsSummaryUseCase,
  }) : _getAnalyticsSummaryUseCase = getAnalyticsSummaryUseCase;

  AnalyticsTimeRange get selectedRange => _selectedRange;
  AnalyticsSummaryModel? get summary => _summary;
  int? get selectedBarIndex => _selectedBarIndex;
  String get activeShopId => _activeShopId;

  void setActiveShopId(String shopId) {
    if (_activeShopId != shopId) {
      _activeShopId = shopId;
      loadAnalytics(range: _selectedRange);
    }
  }

  void setSelectedBarIndex(int? index) {
    if (_selectedBarIndex != index) {
      _selectedBarIndex = index;
      notifyListeners();
    }
  }

  // Load or change active period
  Future<void> setPeriod(AnalyticsTimeRange range) async {
    if (_selectedRange == range && _summary != null) return;
    _selectedRange = range;
    _selectedBarIndex = null;
    notifyListeners();
    await loadAnalytics(range: range);
  }

  // Fetch summary
  Future<void> loadAnalytics({AnalyticsTimeRange? range}) async {
    final targetRange = range ?? _selectedRange;
    setLoading();
    clearError();

    final result = await _getAnalyticsSummaryUseCase.execute(
      shopId: _activeShopId,
      range: targetRange,
    );

    result.when(
      success: (data) {
        _summary = data;
        _selectedRange = targetRange;
        // Default select the highlight bar if available
        final highlightIdx = data.chartPoints.indexWhere((p) => p.isHighlight);
        if (highlightIdx != -1) {
          _selectedBarIndex = highlightIdx;
        } else if (data.chartPoints.isNotEmpty) {
          _selectedBarIndex = data.chartPoints.length - 1;
        }
        setSuccess();
      },
      failure: (message, exception) {
        setError(message);
      },
    );
  }

  // Pull-to-refresh
  Future<void> refresh() async {
    await loadAnalytics(range: _selectedRange);
  }
}
