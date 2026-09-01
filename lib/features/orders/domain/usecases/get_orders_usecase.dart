import '../../../../core/utils/result.dart';
import '../models/order_model.dart';
import '../models/order_status.dart';
import '../repositories/order_repository_interface.dart';

// Get Orders Use Case
class GetOrdersUseCase {
  final IOrderRepository _repository;

  GetOrdersUseCase(this._repository);

  Future<Result<List<OrderModel>>> execute({
    required String shopId,
    OrderStatus status = OrderStatus.all,
    bool forceRefresh = false,
  }) async {
    final effectiveShopId = shopId.trim().isEmpty ? 'shop_01' : shopId.trim();

    return await _repository.getOrders(
      shopId: effectiveShopId,
      status: status,
      forceRefresh: forceRefresh,
    );
  }
}
