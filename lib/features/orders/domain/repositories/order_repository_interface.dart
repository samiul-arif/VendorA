import '../../../../core/utils/result.dart';
import '../models/order_model.dart';
import '../models/order_status.dart';

// Order Repository Interface Definition
abstract class IOrderRepository {
  // Fetch list of orders filtered optionally by status
  Future<Result<List<OrderModel>>> getOrders({
    required String shopId,
    OrderStatus status = OrderStatus.all,
    bool forceRefresh = false,
  });

  // Get full order details by ID
  Future<Result<OrderModel>> getOrderById({
    required String orderId,
  });

  // Update order workflow status
  Future<Result<OrderModel>> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
    String? rejectionReason,
  });

  // Update estimated preparation minutes
  Future<Result<OrderModel>> updatePrepTime({
    required String orderId,
    required int estimatedMinutes,
  });
}
