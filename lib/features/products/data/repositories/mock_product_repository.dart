import 'package:uuid/uuid.dart';
import '../../../../core/network/base_mock_repository.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/models/pagination_model.dart';
import '../../domain/models/product_model.dart';
import '../../domain/repositories/product_repository_interface.dart';

// Mock Product Repository with 2,483 Products, Inventory Tracking and Paginated Queries
class MockProductRepository extends BaseMockRepository implements IProductRepository {
  static const Uuid _uuid = Uuid();
  final List<ProductModel> _inMemoryProducts = [];

  MockProductRepository() {
    _inMemoryProducts.addAll(createDefaultProducts());
  }

  static List<ProductModel> createDefaultProducts() {
    final List<ProductModel> products = [
      ProductModel(
        id: 'prod_01',
        shopId: 'shop_01',
        name: 'Truffle Smash Burger',
        description: 'Double Angus beef patty, melted aged cheddar, black truffle aioli & brioche bun.',
        price: 14.99,
        originalPrice: 17.99,
        stockQuantity: 24,
        lowStockThreshold: 4,
        isAvailable: true,
        isManualOutOfStock: false,
        categoryId: 'cat_01',
        categoryName: 'Burgers & Sandwiches',
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        preparationTimeMinutes: 15,
        isPopular: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ProductModel(
        id: 'prod_02',
        shopId: 'shop_01',
        name: 'Double Bacon Cheeseburger',
        description: 'Smoked hardwood bacon, double cheddar, crisp lettuce, red onion & house relish.',
        price: 12.50,
        originalPrice: 14.00,
        stockQuantity: 18,
        lowStockThreshold: 3,
        isAvailable: true,
        isManualOutOfStock: false,
        categoryId: 'cat_01',
        categoryName: 'Burgers & Sandwiches',
        imageUrl: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=400',
        preparationTimeMinutes: 12,
        isPopular: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ProductModel(
        id: 'prod_03',
        shopId: 'shop_01',
        name: 'Crispy Chicken Rice Bowl',
        description: 'Golden buttermilk fried chicken breast over fragrant jasmine rice with sesame slaw.',
        price: 11.00,
        originalPrice: null,
        stockQuantity: 2, // Low stock edge case
        lowStockThreshold: 3,
        isAvailable: true,
        isManualOutOfStock: false,
        categoryId: 'cat_01',
        categoryName: 'Burgers & Sandwiches',
        imageUrl: 'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=400',
        preparationTimeMinutes: 14,
        isPopular: false,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'prod_04',
        shopId: 'shop_01',
        name: 'Loaded Bacon Cheese Fries',
        description: 'Hand-cut russet fries smothered in melted Monterey Jack, crispy bacon crumbles & chives.',
        price: 8.50,
        originalPrice: null,
        stockQuantity: 0, // Auto out of stock edge case
        lowStockThreshold: 3,
        isAvailable: false,
        isManualOutOfStock: false,
        categoryId: 'cat_02',
        categoryName: 'Sides & Appetizers',
        imageUrl: 'https://images.unsplash.com/photo-1585109649139-366815a0d713?w=400',
        preparationTimeMinutes: 8,
        isPopular: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'prod_05',
        shopId: 'shop_01',
        name: 'Golden Onion Rings',
        description: 'Beer-battered sweet yellow onions fried to golden perfection with zesty dip.',
        price: 6.50,
        originalPrice: null,
        stockQuantity: 15,
        lowStockThreshold: 3,
        isAvailable: true,
        isManualOutOfStock: false,
        categoryId: 'cat_02',
        categoryName: 'Sides & Appetizers',
        imageUrl: 'https://images.unsplash.com/photo-1639024471287-035186f55a1c?w=400',
        preparationTimeMinutes: 6,
        isPopular: false,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'prod_06',
        shopId: 'shop_01',
        name: 'Specialty Vanilla Milkshake',
        description: 'Hand-spun Madagascar bourbon vanilla ice cream topped with fresh whipped cream.',
        price: 5.50,
        originalPrice: null,
        stockQuantity: 30,
        lowStockThreshold: 5,
        isAvailable: true,
        isManualOutOfStock: false,
        categoryId: 'cat_03',
        categoryName: 'Beverages & Drinks',
        imageUrl: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400',
        preparationTimeMinutes: 5,
        isPopular: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'prod_07',
        shopId: 'shop_01',
        name: 'Warm Chocolate Lava Cake',
        description: 'Decadent dark chocolate molten center served with powdered sugar & cocoa drizzle.',
        price: 7.50,
        originalPrice: 9.00,
        stockQuantity: 10,
        lowStockThreshold: 2,
        isAvailable: true,
        isManualOutOfStock: false,
        categoryId: 'cat_04',
        categoryName: 'Desserts & Sweets',
        imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400',
        preparationTimeMinutes: 10,
        isPopular: true,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now(),
      ),
    ];

    // Category profiles for deterministic generation of 2,483 products
    final categories = [
      {
        'id': 'cat_01',
        'name': 'Burgers & Sandwiches',
        'prefixes': ['Artisan', 'Smoked', 'Gourmet', 'Crispy', 'BBQ', 'Double', 'Classic', 'Spicy', 'Truffle', 'Cheesy', 'Grilled', 'Fiery', 'Honey Glazed', 'Loaded'],
        'items': ['Angus Burger', 'Chicken Club', 'Brisket Melt', 'Smashed Patty', 'Philly Cheesesteak', 'Veggie Stack', 'Slider Trio', 'Bacon Melt', 'Buffalo Burger', 'Avocado Wrap'],
        'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        'basePrice': 11.50,
      },
      {
        'id': 'cat_02',
        'name': 'Sides & Appetizers',
        'prefixes': ['Seasoned', 'Loaded', 'Golden', 'Crispy', 'Spicy', 'Herb', 'Garlic', 'Truffle', 'Zesty', 'Cheesy', 'Cajun', 'Smoky'],
        'items': ['Curly Fries', 'Mozzarella Sticks', 'Truffle Tots', 'Buffalo Wings', 'Garlic Bread Bites', 'Jalapeño Poppers', 'Sweet Potato Fries', 'Corn Ribs', 'Nachos Supreme'],
        'image': 'https://images.unsplash.com/photo-1585109649139-366815a0d713?w=400',
        'basePrice': 6.50,
      },
      {
        'id': 'cat_03',
        'name': 'Beverages & Drinks',
        'prefixes': ['Iced', 'Fresh', 'Sparkling', 'Chilled', 'Cold Brew', 'Signature', 'Tropical', 'Organic', 'Hand-Crafted', 'Artisanal'],
        'items': ['Lemon Iced Tea', 'Mango Peach Slush', 'Vanilla Bean Shake', 'Espresso Tonic', 'Strawberry Sparkler', 'Matcha Latte', 'Passionfruit Fizz', 'Cold Brew Coffee', 'Chocolate Malt'],
        'image': 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=400',
        'basePrice': 4.75,
      },
      {
        'id': 'cat_04',
        'name': 'Pizzas & Calzones',
        'prefixes': ['Stone Baked', 'Artisan', 'Rustic', 'Cheesy', 'Truffle', 'Spicy', 'Classic', 'Wood Fired', 'Supreme', 'Stuffed Crust'],
        'items': ['Pepperoni Feast XL', 'Margherita D.O.P.', 'Truffle Mushroom Pizza', 'BBQ Chicken Pizza', 'Four Cheese Calzone', 'Meat Lovers Supreme', 'Diavola Hot Pizza', 'Pesto Veggie Pizza'],
        'image': 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
        'basePrice': 16.00,
      },
      {
        'id': 'cat_05',
        'name': 'Desserts & Sweets',
        'prefixes': ['Warm', 'Decadent', 'Fluffy', 'Rich', 'Belgian', 'Velvet', 'Homemade', 'Artisan', 'Glazed', 'Creamy'],
        'items': ['Lava Cake', 'New York Cheesecake', 'Cinnamon Rolls', 'Churro Bites', 'Berry Tiramisu', 'Fudge Brownie', 'Apple Crumble', 'Macaron Box', 'Caramel Pudding'],
        'image': 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400',
        'basePrice': 6.99,
      },
      {
        'id': 'cat_06',
        'name': 'Combos & Deals',
        'prefixes': ['Super Saver', 'Mega', 'Duo', 'Family', 'Midnight', 'Office Feast', 'Weekend Party', 'Student', 'Chef Special'],
        'items': ['Burger & Wings Box', 'Pizza & Drink Feast', 'Duo Smash Combo', 'Lunch Delight Pack', 'Game Day Platter', 'Family Meal Deal'],
        'image': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=400',
        'basePrice': 22.50,
      },
    ];

    const targetTotal = 2483; // Exactly 2,483 products requirement
    int index = products.length + 1;

    while (products.length < targetTotal) {
      final cat = categories[index % categories.length];
      final prefixes = cat['prefixes'] as List<String>;
      final items = cat['items'] as List<String>;

      final prefix = prefixes[(index * 7) % prefixes.length];
      final item = items[(index * 13) % items.length];
      final basePrice = cat['basePrice'] as double;
      final price = (basePrice + (index % 15) * 1.25);
      final hasDiscount = index % 5 == 0;
      final stock = (index % 17 == 0) ? 0 : ((index % 7 == 0) ? 2 : (10 + (index % 45)));

      products.add(
        ProductModel(
          id: 'prod_${index.toString().padLeft(4, '0')}',
          shopId: 'shop_01',
          name: '$prefix $item #${index.toString().padLeft(3, '0')}',
          description: 'Specialty crafted $item with premium fresh ingredients and house seasoning.',
          price: double.parse(price.toStringAsFixed(2)),
          originalPrice: hasDiscount ? double.parse((price * 1.20).toStringAsFixed(2)) : null,
          stockQuantity: stock,
          lowStockThreshold: 3,
          isAvailable: stock > 0 && index % 23 != 0,
          isManualOutOfStock: index % 23 == 0,
          categoryId: cat['id'] as String,
          categoryName: cat['name'] as String,
          imageUrl: cat['image'] as String,
          preparationTimeMinutes: 5 + (index % 25),
          isPopular: index % 8 == 0,
          createdAt: DateTime.now().subtract(Duration(days: (index % 120) + 1)),
          updatedAt: DateTime.now().subtract(Duration(hours: (index % 48) + 1)),
        ),
      );
      index++;
    }

    return products;
  }

  @override
  Future<Result<PaginatedList<ProductModel>>> getProducts({
    required String shopId,
    int page = 1,
    int pageSize = 20,
    String? categoryId,
    String? searchQuery,
  }) async {
    return executeMock(
      operation: () async {
        var list = _inMemoryProducts.where((p) => p.shopId == shopId || p.shopId == 'shop_01').toList();
        if (list.isEmpty) {
          list = _inMemoryProducts;
        }

        if (categoryId != null && categoryId != 'all' && categoryId.isNotEmpty) {
          list = list.where((p) => p.categoryId == categoryId).toList();
        }

        if (searchQuery != null && searchQuery.trim().isNotEmpty) {
          final query = searchQuery.toLowerCase().trim();
          list = list.where((p) =>
              p.name.toLowerCase().contains(query) ||
              p.description.toLowerCase().contains(query) ||
              p.categoryName.toLowerCase().contains(query)).toList();
        }

        return PaginatedList<ProductModel>.fromAllItems(
          allItems: list,
          page: page,
          pageSize: pageSize,
        );
      },
      customDelayMs: 250,
    );
  }

  @override
  Future<Result<ProductModel>> getProductById({
    required String productId,
  }) async {
    return executeMock(
      operation: () async {
        final product = _inMemoryProducts.firstWhere(
          (p) => p.id == productId,
          orElse: () => throw Exception('Product $productId not found.'),
        );
        return product;
      },
      customDelayMs: 200,
    );
  }

  @override
  Future<Result<ProductModel>> addProduct({
    required ProductModel product,
  }) async {
    return executeMock(
      operation: () async {
        final newProduct = product.copyWith(
          id: 'prod_${_uuid.v4().substring(0, 8)}',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _inMemoryProducts.insert(0, newProduct);
        return newProduct;
      },
      customDelayMs: 400,
    );
  }

  @override
  Future<Result<ProductModel>> updateProduct({
    required ProductModel product,
  }) async {
    return executeMock(
      operation: () async {
        final index = _inMemoryProducts.indexWhere((p) => p.id == product.id);
        if (index == -1) {
          throw Exception('Product ${product.id} not found.');
        }

        final updated = product.copyWith(updatedAt: DateTime.now());
        _inMemoryProducts[index] = updated;
        return updated;
      },
      customDelayMs: 350,
    );
  }

  @override
  Future<Result<void>> deleteProduct({
    required String productId,
    bool softDelete = false,
  }) async {
    return executeMock(
      operation: () async {
        if (softDelete) {
          final index = _inMemoryProducts.indexWhere((p) => p.id == productId);
          if (index != -1) {
            _inMemoryProducts[index] = _inMemoryProducts[index].copyWith(
              isAvailable: false,
              isManualOutOfStock: true,
              stockQuantity: 0,
            );
          }
        } else {
          _inMemoryProducts.removeWhere((p) => p.id == productId);
        }
      },
      customDelayMs: 300,
    );
  }

  @override
  Future<Result<ProductModel>> toggleProductAvailability({
    required String productId,
    required bool isAvailable,
  }) async {
    return executeMock(
      operation: () async {
        final index = _inMemoryProducts.indexWhere((p) => p.id == productId);
        if (index == -1) {
          throw Exception('Product $productId not found.');
        }

        final current = _inMemoryProducts[index];
        final updated = current.copyWith(
          isAvailable: isAvailable,
          isManualOutOfStock: !isAvailable,
          updatedAt: DateTime.now(),
        );
        _inMemoryProducts[index] = updated;
        return updated;
      },
      customDelayMs: 200,
    );
  }

  @override
  Future<Result<ProductModel>> restockProduct({
    required String productId,
    required int addQuantity,
  }) async {
    return executeMock(
      operation: () async {
        final index = _inMemoryProducts.indexWhere((p) => p.id == productId);
        if (index == -1) {
          throw Exception('Product $productId not found.');
        }

        final current = _inMemoryProducts[index];
        final newQuantity = current.stockQuantity + addQuantity;
        final updated = current.copyWith(
          stockQuantity: newQuantity,
          isAvailable: true,
          isManualOutOfStock: false,
          updatedAt: DateTime.now(),
        );
        _inMemoryProducts[index] = updated;
        return updated;
      },
      customDelayMs: 250,
    );
  }
}
