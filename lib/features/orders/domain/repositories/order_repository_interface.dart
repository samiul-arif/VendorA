import '../../../../core/utils/result.dart';
import '../../../../shared/models/pagination_model.dart';
import '../models/order_model.dart';
import '../models/order_status.dart';

// Order Repository Interface Definition
abstract class IOrderRepository {
  // Fetch paginated list of orders filtered optionally by status and search query
  Future<Result<PaginatedList<OrderModel>>> getOrders({
    required String shopId,
    int page = 1,
    int pageSize = 20,
    OrderStatus status = OrderStatus.all,
    String? searchQuery,
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
