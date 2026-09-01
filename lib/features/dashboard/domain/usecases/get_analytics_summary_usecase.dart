import '../../../../core/utils/result.dart';
import '../models/analytics_summary_model.dart';
import '../models/analytics_time_range.dart';
import '../repositories/dashboard_repository_interface.dart';

// Get Standalone Analytics Summary Use Case
class GetAnalyticsSummaryUseCase {
  final IDashboardRepository _repository;

  GetAnalyticsSummaryUseCase(this._repository);

  Future<Result<AnalyticsSummaryModel>> execute({
    required String shopId,
    required AnalyticsTimeRange range,
  }) async {
    if (shopId.trim().isEmpty) {
      return const Failure('Valid Shop ID is required to fetch analytics.');
    }
    return await _repository.getAnalyticsSummary(
      shopId: shopId.trim(),
      range: range,
    );
  }
}
