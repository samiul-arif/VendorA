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
    if (shopId.trim().isEmpty) {
      return const Failure('Invalid shop identifier.');
    }

    return await _repository.getOrders(
      shopId: shopId,
      status: status,
      forceRefresh: forceRefresh,
    );
  }
}
