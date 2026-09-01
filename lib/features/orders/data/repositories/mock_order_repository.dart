import '../../../../core/network/base_mock_repository.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/order_item_model.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_status.dart';
import '../../domain/repositories/order_repository_interface.dart';

// Mock Order Repository with In-Memory Kitchen Pipeline Simulation
class MockOrderRepository extends BaseMockRepository implements IOrderRepository {
  final Map<String, OrderModel> _orders = {};

  MockOrderRepository() {
    _initDefaultOrders();
  }

  static List<OrderModel> createDefaultOrders() {
    final now = DateTime.now();

    return [
      // 1. Pending (New Incoming Order)
      OrderModel(
        id: 'ord_101',
        orderNumber: 'FP-8493',
        shopId: 'shop_01',
        customerName: 'Sarah Jenkins',
        customerPhone: '+1 (555) 342-9102',
        deliveryAddress: '742 Evergreen Terrace, Apt 4B, SF',
        customerNotes: 'Please ring bell twice and leave near doorstep.',
        items: const [
          OrderItemModel(
            productId: 'prod_05',
            productName: 'Crispy Chicken Rice Bowl',
            unitPrice: 13.99,
            quantity: 1,
            imageUrl: 'https://images.unsplash.com/photo-1562967914-608f82629710?w=400',
            specialInstructions: 'Extra spicy sambal on the side please.',
            selectedAddons: ['Extra Spicy Sambal', 'Fried Egg'],
          ),
          OrderItemModel(
            productId: 'prod_03',
            productName: 'Iced Lemon Sparkler',
            unitPrice: 4.21,
            quantity: 1,
            imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=400',
            specialInstructions: 'Less ice',
          ),
        ],
        subtotal: 18.20,
        deliveryFee: 2.99,
        tax: 1.55,
        discount: 0.0,
        totalAmount: 22.74,
        status: OrderStatus.pending,
        paymentMethod: 'Credit Card (Apple Pay)',
        isPaid: true,
        estimatedPrepMinutes: 15,
        createdAt: now.subtract(const Duration(minutes: 2)),
        updatedAt: now.subtract(const Duration(minutes: 2)),
      ),

      // 2. Pending (Another New Incoming Order)
      OrderModel(
        id: 'ord_102',
        orderNumber: 'FP-8494',
        shopId: 'shop_01',
        customerName: 'Marcus Vance',
        customerPhone: '+1 (555) 882-1920',
        deliveryAddress: '120 Howard St, Suite 500, Financial District',
        customerNotes: 'Call upon arrival, elevator requires code 4910',
        items: const [
          OrderItemModel(
            productId: 'prod_01',
            productName: 'Truffle Smash Double Burger',
            unitPrice: 14.99,
            quantity: 2,
            imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
            specialInstructions: 'No pickles on both burgers.',
            selectedAddons: ['Extra Truffle Aioli', 'Brioche Bun'],
          ),
          OrderItemModel(
            productId: 'prod_02',
            productName: 'Truffle Parmesan Fries',
            unitPrice: 5.99,
            quantity: 2,
            imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400',
          ),
        ],
        subtotal: 41.96,
        deliveryFee: 0.0,
        tax: 3.56,
        discount: 5.00,
        totalAmount: 40.52,
        status: OrderStatus.pending,
        paymentMethod: 'Foodpanda Wallet',
        isPaid: true,
        estimatedPrepMinutes: 20,
        createdAt: now.subtract(const Duration(minutes: 5)),
        updatedAt: now.subtract(const Duration(minutes: 5)),
      ),

      // 3. Accepted (In Kitchen Queue)
      OrderModel(
        id: 'ord_103',
        orderNumber: 'FP-8491',
        shopId: 'shop_01',
        customerName: 'Elena Rostova',
        customerPhone: '+1 (555) 712-4493',
        deliveryAddress: '350 Mission St, 18th Floor',
        items: const [
          OrderItemModel(
            productId: 'prod_01',
            productName: 'Truffle Smash Double Burger',
            unitPrice: 14.99,
            quantity: 1,
            imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
            specialInstructions: 'Well done meat patties please',
          ),
          OrderItemModel(
            productId: 'prod_04',
            productName: 'Molten Lava Cake',
            unitPrice: 6.99,
            quantity: 1,
            imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400',
          ),
        ],
        subtotal: 21.98,
        deliveryFee: 2.99,
        tax: 1.86,
        discount: 0.0,
        totalAmount: 26.83,
        status: OrderStatus.accepted,
        paymentMethod: 'Credit Card',
        isPaid: true,
        riderName: 'Carlos M. (Panda Express #81)',
        riderPhone: '+1 (555) 991-0021',
        estimatedPrepMinutes: 15,
        createdAt: now.subtract(const Duration(minutes: 10)),
        updatedAt: now.subtract(const Duration(minutes: 8)),
      ),

      // 4. Preparing (Cooking on Grill)
      OrderModel(
        id: 'ord_104',
        orderNumber: 'FP-8492',
        shopId: 'shop_01',
        customerName: 'Alex Rivera',
        customerPhone: '+1 (555) 919-4820',
        deliveryAddress: '88 King Street, Apt 302, Mission Bay',
        items: const [
          OrderItemModel(
            productId: 'prod_01',
            productName: 'Truffle Smash Double Burger',
            unitPrice: 14.99,
            quantity: 2,
            imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
          ),
          OrderItemModel(
            productId: 'prod_02',
            productName: 'Truffle Parmesan Fries',
            unitPrice: 5.99,
            quantity: 1,
            imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400',
          ),
        ],
        subtotal: 35.97,
        deliveryFee: 2.99,
        tax: 3.05,
        discount: 3.00,
        totalAmount: 39.01,
        status: OrderStatus.preparing,
        paymentMethod: 'Google Pay',
        isPaid: true,
        riderName: 'David Zhang (Panda Express #44)',
        riderPhone: '+1 (555) 431-8910',
        estimatedPrepMinutes: 10,
        createdAt: now.subtract(const Duration(minutes: 16)),
        updatedAt: now.subtract(const Duration(minutes: 12)),
      ),

      // 5. Ready for Pickup (Packed in bag, waiting for rider)
      OrderModel(
        id: 'ord_105',
        orderNumber: 'FP-8489',
        shopId: 'shop_01',
        customerName: 'Jessica Wu',
        customerPhone: '+1 (555) 602-1188',
        deliveryAddress: '500 Folsom St, Tower 1, Apt 1404',
        items: const [
          OrderItemModel(
            productId: 'prod_04',
            productName: 'Molten Lava Cake',
            unitPrice: 6.99,
            quantity: 2,
            imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400',
            specialInstructions: 'Warm up before packing please',
          ),
          OrderItemModel(
            productId: 'prod_03',
            productName: 'Iced Lemon Sparkler',
            unitPrice: 4.21,
            quantity: 2,
            imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=400',
          ),
        ],
        subtotal: 22.40,
        deliveryFee: 1.99,
        tax: 1.90,
        discount: 0.0,
        totalAmount: 26.29,
        status: OrderStatus.ready,
        paymentMethod: 'Credit Card',
        isPaid: true,
        riderName: 'Samir Khan (Panda Express #12)',
        riderPhone: '+1 (555) 880-9921',
        estimatedPrepMinutes: 0,
        createdAt: now.subtract(const Duration(minutes: 25)),
        updatedAt: now.subtract(const Duration(minutes: 4)),
      ),

      // 6. Delivered / Completed
      OrderModel(
        id: 'ord_106',
        orderNumber: 'FP-8480',
        shopId: 'shop_01',
        customerName: 'Benjamin Carter',
        customerPhone: '+1 (555) 234-8800',
        deliveryAddress: '201 3rd Street, SoMa',
        items: const [
          OrderItemModel(
            productId: 'prod_01',
            productName: 'Truffle Smash Double Burger',
            unitPrice: 14.99,
            quantity: 3,
            imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
          ),
        ],
        subtotal: 44.97,
        deliveryFee: 2.99,
        tax: 3.82,
        discount: 0.0,
        totalAmount: 51.78,
        status: OrderStatus.delivered,
        paymentMethod: 'Credit Card',
        isPaid: true,
        riderName: 'Emily Clark (Panda Express #09)',
        riderPhone: '+1 (555) 777-1234',
        estimatedPrepMinutes: 0,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 1, minutes: 30)),
      ),

      // 7. Cancelled / Out of stock item
      OrderModel(
        id: 'ord_107',
        orderNumber: 'FP-8475',
        shopId: 'shop_01',
        customerName: 'Liam O\'Connor',
        customerPhone: '+1 (555) 901-2244',
        deliveryAddress: '150 California St, Downtown',
        items: const [
          OrderItemModel(
            productId: 'prod_05',
            productName: 'Crispy Chicken Rice Bowl',
            unitPrice: 13.99,
            quantity: 2,
            imageUrl: 'https://images.unsplash.com/photo-1562967914-608f82629710?w=400',
          ),
        ],
        subtotal: 27.98,
        deliveryFee: 2.99,
        tax: 2.37,
        discount: 0.0,
        totalAmount: 33.34,
        status: OrderStatus.cancelled,
        paymentMethod: 'Credit Card',
        isPaid: false,
        rejectionReason: 'Kitchen out of fresh chicken breast stock for the evening.',
        estimatedPrepMinutes: 0,
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(hours: 3, minutes: 55)),
      ),
    ];
  }

  void _initDefaultOrders() {
    for (final order in createDefaultOrders()) {
      _orders[order.id] = order;
    }
  }

  @override
  Future<Result<List<OrderModel>>> getOrders({
    required String shopId,
    OrderStatus status = OrderStatus.all,
    bool forceRefresh = false,
  }) async {
    return executeMock(
      operation: () async {
        var list = _orders.values.where((o) => o.shopId == shopId || o.shopId == 'shop_01').toList();
        if (list.isEmpty) {
          list = _orders.values.toList();
        }

        if (status != OrderStatus.all) {
          list = list.where((o) => o.status == status).toList();
        }

        // Sort by creation time (most recent first)
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return list;
      },
      customDelayMs: forceRefresh ? 450 : 200,
    );
  }

  @override
  Future<Result<OrderModel>> getOrderById({
    required String orderId,
  }) async {
    return executeMock(
      operation: () async {
        final order = _orders[orderId];
        if (order == null) {
          throw Exception('Order #$orderId was not found.');
        }
        return order;
      },
      customDelayMs: 250,
    );
  }

  @override
  Future<Result<OrderModel>> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
    String? rejectionReason,
  }) async {
    return executeMock(
      operation: () async {
        final existing = _orders[orderId];
        if (existing == null) {
          throw Exception('Order #$orderId not found.');
        }

        final updated = existing.copyWith(
          status: newStatus,
          rejectionReason: rejectionReason ?? existing.rejectionReason,
          updatedAt: DateTime.now(),
        );

        _orders[orderId] = updated;
        return updated;
      },
      customDelayMs: 300,
    );
  }

  @override
  Future<Result<OrderModel>> updatePrepTime({
    required String orderId,
    required int estimatedMinutes,
  }) async {
    return executeMock(
      operation: () async {
        final existing = _orders[orderId];
        if (existing == null) {
          throw Exception('Order not found.');
        }

        final updated = existing.copyWith(
          estimatedPrepMinutes: estimatedMinutes,
          updatedAt: DateTime.now(),
        );

        _orders[orderId] = updated;
        return updated;
      },
      customDelayMs: 250,
    );
  }
}
