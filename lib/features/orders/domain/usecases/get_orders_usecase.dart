import '../../../../core/utils/result.dart';
import '../../../../shared/models/pagination_model.dart';
import '../models/order_model.dart';
import '../models/order_status.dart';
import '../repositories/order_repository_interface.dart';

// Get Paginated Orders Use Case
class GetOrdersUseCase {
  final IOrderRepository _repository;

  GetOrdersUseCase(this._repository);

  Future<Result<PaginatedList<OrderModel>>> execute({
    required String shopId,
    int page = 1,
    int pageSize = 20,
    OrderStatus status = OrderStatus.all,
    String? searchQuery,
    bool forceRefresh = false,
  }) async {
    final effectiveShopId = shopId.trim().isEmpty ? 'shop_01' : shopId.trim();

    return await _repository.getOrders(
      shopId: effectiveShopId,
      page: page,
      pageSize: pageSize,
      status: status,
      searchQuery: searchQuery,
      forceRefresh: forceRefresh,
    );
  }
}
