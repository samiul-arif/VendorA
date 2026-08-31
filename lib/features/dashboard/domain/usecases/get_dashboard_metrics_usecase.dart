import '../../../../core/utils/result.dart';
import '../models/dashboard_metrics.dart';
import '../repositories/dashboard_repository_interface.dart';

// Get Dashboard Metrics Use Case
class GetDashboardMetricsUseCase {
  final IDashboardRepository _repository;

  GetDashboardMetricsUseCase(this._repository);

  Future<Result<DashboardMetrics>> execute({
    required String shopId,
    bool forceRefresh = false,
  }) async {
    if (shopId.trim().isEmpty) {
      return const Failure('Valid Shop ID is required to fetch dashboard metrics.');
    }

    if (forceRefresh) {
      return await _repository.refreshMetrics(shopId: shopId.trim());
    }
    return await _repository.getDashboardSummary(shopId: shopId.trim());
  }
}
