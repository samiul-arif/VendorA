import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_status.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/get_order_details_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';

// Order Management Controller
class OrderController extends BaseController {
  final GetOrdersUseCase _getOrdersUseCase;
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;

  List<OrderModel> _allOrders = [];
  OrderStatus _selectedStatus = OrderStatus.all;
  String _searchQuery = '';
  String? _activeShopId;
  OrderModel? _selectedOrder;

  OrderController({
    required GetOrdersUseCase getOrdersUseCase,
    required GetOrderDetailsUseCase getOrderDetailsUseCase,
    required UpdateOrderStatusUseCase updateOrderStatusUseCase,
  })  : _getOrdersUseCase = getOrdersUseCase,
        _getOrderDetailsUseCase = getOrderDetailsUseCase,
        _updateOrderStatusUseCase = updateOrderStatusUseCase;

  // Getters
  List<OrderModel> get allOrders => _allOrders;
  OrderStatus get selectedStatus => _selectedStatus;
  String get searchQuery => _searchQuery;
  OrderModel? get selectedOrder => _selectedOrder;

  List<OrderModel> get filteredOrders {
    var list = _allOrders;

    // Filter by status tab
    if (_selectedStatus != OrderStatus.all) {
      list = list.where((o) => o.status == _selectedStatus).toList();
    }

    // Filter by search query
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      list = list.where((o) {
        return o.orderNumber.toLowerCase().contains(q) ||
            o.customerName.toLowerCase().contains(q) ||
            o.itemsSummary.toLowerCase().contains(q);
      }).toList();
    }

    return list;
  }

  // Count by status
  int getCount(OrderStatus status) {
    if (status == OrderStatus.all) return _allOrders.length;
    return _allOrders.where((o) => o.status == status).length;
  }

  // Load Orders
  Future<void> loadOrders({required String shopId, bool forceRefresh = false}) async {
    _activeShopId = shopId;

    await runWithState<void>(() async {
      final result = await _getOrdersUseCase.execute(
        shopId: shopId,
        forceRefresh: forceRefresh,
      );

      if (result is Success<List<OrderModel>>) {
        _allOrders = result.data;
        return const Success<void>(null);
      } else if (result is Failure<List<OrderModel>>) {
        return Failure<void>(result.message);
      }
      return const Success<void>(null);
    });
  }

  // Set Status Tab
  void setStatusFilter(OrderStatus status) {
    _selectedStatus = status;
    notifyListeners();
  }

  // Search
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Load Single Order Details
  Future<void> loadOrderDetails(String orderId) async {
    final cached = _allOrders.where((o) => o.id == orderId).firstOrNull;
    if (cached != null) {
      _selectedOrder = cached;
      notifyListeners();
    }

    final result = await _getOrderDetailsUseCase.execute(orderId: orderId);
    if (result is Success<OrderModel>) {
      _selectedOrder = result.data;
      notifyListeners();
    }
  }

  // Transition Order Status
  Future<Result<OrderModel>> updateStatus({
    required String orderId,
    required OrderStatus newStatus,
    String? rejectionReason,
  }) async {
    final result = await _updateOrderStatusUseCase.execute(
      orderId: orderId,
      newStatus: newStatus,
      rejectionReason: rejectionReason,
    );

    if (result is Success<OrderModel>) {
      final updated = result.data;
      final index = _allOrders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _allOrders[index] = updated;
      }
      if (_selectedOrder?.id == orderId) {
        _selectedOrder = updated;
      }
      notifyListeners();
    }

    return result;
  }

  // Action Shortcuts
  Future<Result<OrderModel>> acceptOrder(String orderId) =>
      updateStatus(orderId: orderId, newStatus: OrderStatus.accepted);

  Future<Result<OrderModel>> startPreparing(String orderId) =>
      updateStatus(orderId: orderId, newStatus: OrderStatus.preparing);

  Future<Result<OrderModel>> markReady(String orderId) =>
      updateStatus(orderId: orderId, newStatus: OrderStatus.ready);

  Future<Result<OrderModel>> markDelivered(String orderId) =>
      updateStatus(orderId: orderId, newStatus: OrderStatus.delivered);

  Future<Result<OrderModel>> cancelOrder(String orderId, {String? reason}) =>
      updateStatus(orderId: orderId, newStatus: OrderStatus.cancelled, rejectionReason: reason);
}
