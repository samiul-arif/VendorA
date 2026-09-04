import '../../../../core/network/base_mock_repository.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/models/pagination_model.dart';
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

    final List<OrderModel> orders = [
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

    final firstNames = [
      'Liam', 'Emma', 'Noah', 'Olivia', 'Lucas', 'Ava', 'Ethan', 'Sophia',
      'Mason', 'Isabella', 'Alex', 'Mia', 'James', 'Charlotte', 'Daniel',
      'Harper', 'Logan', 'Evelyn', 'Benjamin', 'Amelia', 'Oliver', 'Harper',
    ];

    final lastNames = [
      'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller',
      'Davis', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez',
      'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin',
    ];

    final addresses = [
      '742 Evergreen Terrace, Apt 4B', '120 Howard St, Suite 500',
      '88 King St, Apt 1402', '350 Mission St, 12th Floor',
      '500 Pine St, Apt 3A', '220 Montgomery St, Floor 8',
      '150 California St, Downtown', '789 Market St, Apt 21B',
      '415 Castro St, Unit 302', '620 Folsom St, Apt 8C',
      '1010 Bush St, Apt 15', '450 Sutter St, Suite 900',
    ];

    final productPool = [
      const OrderItemModel(
        productId: 'prod_01',
        productName: 'Truffle Smash Burger',
        unitPrice: 14.99,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
      ),
      const OrderItemModel(
        productId: 'prod_02',
        productName: 'Double Bacon Cheeseburger',
        unitPrice: 12.50,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=400',
      ),
      const OrderItemModel(
        productId: 'prod_03',
        productName: 'Crispy Chicken Rice Bowl',
        unitPrice: 11.00,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=400',
      ),
      const OrderItemModel(
        productId: 'prod_04',
        productName: 'Loaded Bacon Cheese Fries',
        unitPrice: 8.50,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1585109649139-366815a0d713?w=400',
      ),
      const OrderItemModel(
        productId: 'prod_05',
        productName: 'Golden Onion Rings',
        unitPrice: 6.50,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1639024471287-035186f55a1c?w=400',
      ),
      const OrderItemModel(
        productId: 'prod_06',
        productName: 'Specialty Vanilla Milkshake',
        unitPrice: 5.50,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400',
      ),
      const OrderItemModel(
        productId: 'prod_07',
        productName: 'Warm Chocolate Lava Cake',
        unitPrice: 7.50,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400',
      ),
    ];

    const targetTotal = 12581; // Exactly 12,581 orders requirement
    int index = orders.length + 1;

    while (orders.length < targetTotal) {
      final firstName = firstNames[(index * 3) % firstNames.length];
      final lastName = lastNames[(index * 7) % lastNames.length];
      final address = addresses[(index * 11) % addresses.length];

      final p1 = productPool[(index * 5) % productPool.length];
      final p2 = productPool[(index * 13) % productPool.length];
      final items = (index % 3 == 0) ? [p1] : [p1, p2];

      final subtotal = items.fold<double>(0.0, (sum, i) => sum + (i.unitPrice * i.quantity));
      final deliveryFee = (index % 4 == 0) ? 0.0 : 2.99;
      final tax = double.parse((subtotal * 0.085).toStringAsFixed(2));
      final discount = (index % 6 == 0) ? 3.0 : 0.0;
      final total = double.parse((subtotal + deliveryFee + tax - discount).toStringAsFixed(2));

      // Status distribution
      OrderStatus status;
      DateTime createdAt;
      int prepMinutes = 0;

      if (index <= 30) {
        status = OrderStatus.pending;
        createdAt = now.subtract(Duration(minutes: 1 + (index * 2)));
        prepMinutes = 15;
      } else if (index <= 65) {
        status = OrderStatus.accepted;
        createdAt = now.subtract(Duration(minutes: 5 + (index * 2)));
        prepMinutes = 20;
      } else if (index <= 110) {
        status = OrderStatus.preparing;
        createdAt = now.subtract(Duration(minutes: 10 + (index * 2)));
        prepMinutes = 12;
      } else if (index <= 170) {
        status = OrderStatus.ready;
        createdAt = now.subtract(Duration(minutes: 15 + (index * 2)));
        prepMinutes = 0;
      } else if (index % 19 == 0) {
        status = OrderStatus.cancelled;
        createdAt = now.subtract(Duration(hours: 2 + (index % 720)));
      } else {
        status = OrderStatus.delivered;
        createdAt = now.subtract(Duration(hours: 1 + (index % 1440)));
      }

      orders.add(
        OrderModel(
          id: 'ord_${index.toString().padLeft(5, '0')}',
          orderNumber: 'FP-${(8400 + index)}',
          shopId: 'shop_01',
          customerName: '$firstName $lastName',
          customerPhone: '+1 (555) ${(100 + index % 900)}-${(1000 + index % 9000)}',
          deliveryAddress: address,
          items: items,
          subtotal: double.parse(subtotal.toStringAsFixed(2)),
          deliveryFee: deliveryFee,
          tax: tax,
          discount: discount,
          totalAmount: total,
          status: status,
          paymentMethod: index % 2 == 0 ? 'Foodpanda Wallet' : 'Credit Card',
          isPaid: status != OrderStatus.cancelled,
          estimatedPrepMinutes: prepMinutes,
          rejectionReason: status == OrderStatus.cancelled ? 'Item out of stock during peak hour' : null,
          createdAt: createdAt,
          updatedAt: createdAt.add(Duration(minutes: (index % 20) + 2)),
        ),
      );
      index++;
    }

    return orders;
  }

  void _initDefaultOrders() {
    for (final order in createDefaultOrders()) {
      _orders[order.id] = order;
    }
  }

  @override
  Future<Result<PaginatedList<OrderModel>>> getOrders({
    required String shopId,
    int page = 1,
    int pageSize = 20,
    OrderStatus status = OrderStatus.all,
    String? searchQuery,
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

        if (searchQuery != null && searchQuery.trim().isNotEmpty) {
          final q = searchQuery.toLowerCase().trim();
          list = list.where((o) {
            return o.orderNumber.toLowerCase().contains(q) ||
                o.customerName.toLowerCase().contains(q) ||
                o.itemsSummary.toLowerCase().contains(q);
          }).toList();
        }

        // Sort by creation time (most recent first)
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return PaginatedList<OrderModel>.fromAllItems(
          allItems: list,
          page: page,
          pageSize: pageSize,
        );
      },
      customDelayMs: forceRefresh ? 350 : 150,
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
