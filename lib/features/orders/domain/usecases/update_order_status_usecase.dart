import '../../../../core/utils/result.dart';
import '../models/order_model.dart';
import '../models/order_status.dart';
import '../repositories/order_repository_interface.dart';

// Update Order Status Use Case
class UpdateOrderStatusUseCase {
  final IOrderRepository _repository;

  UpdateOrderStatusUseCase(this._repository);

  Future<Result<OrderModel>> execute({
    required String orderId,
    required OrderStatus newStatus,
    String? rejectionReason,
  }) async {
    if (orderId.trim().isEmpty) {
      return const Failure('Invalid order identifier.');
    }

    return await _repository.updateOrderStatus(
      orderId: orderId,
      newStatus: newStatus,
      rejectionReason: rejectionReason,
    );
  }
}
