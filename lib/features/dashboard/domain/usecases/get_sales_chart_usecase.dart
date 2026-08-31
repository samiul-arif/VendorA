import '../../../../core/utils/result.dart';
import '../models/sales_chart_point.dart';
import '../repositories/dashboard_repository_interface.dart';

// Get Sales Chart Analytics Use Case
class GetSalesChartUseCase {
  final IDashboardRepository _repository;

  GetSalesChartUseCase(this._repository);

  Future<Result<List<SalesChartPoint>>> execute({
    required String shopId,
    String period = 'weekly',
  }) async {
    if (shopId.trim().isEmpty) {
      return const Failure('Valid Shop ID is required to fetch sales chart.');
    }
    return await _repository.getSalesAnalytics(
      shopId: shopId.trim(),
      period: period,
    );
  }
}
