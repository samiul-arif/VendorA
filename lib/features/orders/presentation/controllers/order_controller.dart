import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/models/pagination_model.dart';
import '../../data/repositories/mock_order_repository.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_status.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/get_order_details_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';

// Order Management Controller with Enterprise Pagination
class OrderController extends BaseController {
  final GetOrdersUseCase _getOrdersUseCase;
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;

  PaginatedList<OrderModel> _paginatedOrders = PaginatedList.empty();
  int _currentPage = 1;
  int _pageSize = 20;
  OrderStatus _selectedStatus = OrderStatus.all;
  String _searchQuery = '';
  String? _activeShopId;
  OrderModel? _selectedOrder;

  // Snapshot of default orders for accurate total count badges
  final List<OrderModel> _allOrdersSnapshot = MockOrderRepository.createDefaultOrders();

  OrderController({
    required GetOrdersUseCase getOrdersUseCase,
    required GetOrderDetailsUseCase getOrderDetailsUseCase,
    required UpdateOrderStatusUseCase updateOrderStatusUseCase,
  })  : _getOrdersUseCase = getOrdersUseCase,
        _getOrderDetailsUseCase = getOrderDetailsUseCase,
        _updateOrderStatusUseCase = updateOrderStatusUseCase;

  // Getters
  PaginatedList<OrderModel> get paginatedOrders => _paginatedOrders;
  List<OrderModel> get allOrders => _paginatedOrders.items;
  List<OrderModel> get filteredOrders => _paginatedOrders.items;
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  int get totalItems => _paginatedOrders.totalItems;
  int get totalPages => _paginatedOrders.totalPages;
  OrderStatus get selectedStatus => _selectedStatus;
  String get searchQuery => _searchQuery;
  String? get activeShopId => _activeShopId;
  OrderModel? get selectedOrder => _selectedOrder;

  // Accurate Count by Status across the dataset
  int getCount(OrderStatus status) {
    if (status == OrderStatus.all) return _allOrdersSnapshot.length;
    return _allOrdersSnapshot.where((o) => o.status == status).length;
  }

  // Active Recent Orders for lightweight Home Dashboard Widget
  List<OrderModel> getRecentActiveOrders({int limit = 5}) {
    return _allOrdersSnapshot
        .where((o) =>
            o.status == OrderStatus.pending ||
            o.status == OrderStatus.accepted ||
            o.status == OrderStatus.preparing)
        .take(limit)
        .toList();
  }

  // Load Orders with Pagination
  Future<void> loadOrders({
    required String shopId,
    int? page,
    int? pageSize,
    bool forceRefresh = false,
    bool isSilent = false,
  }) async {
    _activeShopId = shopId;
    if (page != null) _currentPage = page;
    if (pageSize != null) _pageSize = pageSize;

    await runWithState<PaginatedList<OrderModel>>(() async {
      final result = await _getOrdersUseCase.execute(
        shopId: shopId,
        page: _currentPage,
        pageSize: _pageSize,
        status: _selectedStatus,
        searchQuery: _searchQuery,
        forceRefresh: forceRefresh,
      );

      if (result is Success<PaginatedList<OrderModel>>) {
        _paginatedOrders = result.data;
        _currentPage = result.data.currentPage;
      }
      return result;
    }, isUpdate: isSilent);
  }

  // Go to specific Page
  Future<void> goToPage(int page) async {
    if (_activeShopId == null || page == _currentPage || page < 1) return;
    await loadOrders(shopId: _activeShopId!, page: page, isSilent: false);
  }

  // Set Page Size (e.g. 10, 20, 50, 100)
  Future<void> setPageSize(int size) async {
    if (_activeShopId == null || size == _pageSize) return;
    _pageSize = size;
    _currentPage = 1;
    await loadOrders(shopId: _activeShopId!, page: 1, pageSize: size);
  }

  // Next Page
  Future<void> nextPage() async {
    if (_paginatedOrders.hasNextPage) {
      await goToPage(_currentPage + 1);
    }
  }

  // Previous Page
  Future<void> previousPage() async {
    if (_paginatedOrders.hasPreviousPage) {
      await goToPage(_currentPage - 1);
    }
  }

  // Set Status Tab
  void setStatusFilter(OrderStatus status) {
    if (_selectedStatus == status) return;
    _selectedStatus = status;
    _currentPage = 1;
    if (_activeShopId != null) {
      loadOrders(shopId: _activeShopId!, page: 1);
    } else {
      notifyListeners();
    }
  }

  // Search
  void setSearchQuery(String query) {
    _searchQuery = query;
    _currentPage = 1;
    if (_activeShopId != null) {
      loadOrders(shopId: _activeShopId!, page: 1);
    } else {
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _currentPage = 1;
    if (_activeShopId != null) {
      loadOrders(shopId: _activeShopId!, page: 1);
    } else {
      notifyListeners();
    }
  }

  // Load Single Order Details
  Future<void> loadOrderDetails(String orderId) async {
    final cached = _paginatedOrders.items.where((o) => o.id == orderId).firstOrNull ??
        _allOrdersSnapshot.where((o) => o.id == orderId).firstOrNull;
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
      final currentItems = List<OrderModel>.from(_paginatedOrders.items);
      final index = currentItems.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        currentItems[index] = updated;
        _paginatedOrders = _paginatedOrders.copyWith(items: currentItems);
      }
      final snapshotIndex = _allOrdersSnapshot.indexWhere((o) => o.id == orderId);
      if (snapshotIndex != -1) {
        _allOrdersSnapshot[snapshotIndex] = updated;
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
