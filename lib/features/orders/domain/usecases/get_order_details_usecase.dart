import '../../../../core/utils/result.dart';
import '../models/order_model.dart';
import '../repositories/order_repository_interface.dart';

// Get Order Details Use Case
class GetOrderDetailsUseCase {
  final IOrderRepository _repository;

  GetOrderDetailsUseCase(this._repository);

  Future<Result<OrderModel>> execute({
    required String orderId,
  }) async {
    if (orderId.trim().isEmpty) {
      return const Failure('Invalid order identifier.');
    }

    return await _repository.getOrderById(orderId: orderId);
  }
}
