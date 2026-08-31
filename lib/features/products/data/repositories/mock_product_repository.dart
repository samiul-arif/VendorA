import 'package:uuid/uuid.dart';
import '../../../../core/network/base_mock_repository.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/product_model.dart';
import '../../domain/repositories/product_repository_interface.dart';

// Mock Product Repository with Inventory Tracking and Offline Stock-Out Logic
class MockProductRepository extends BaseMockRepository implements IProductRepository {
  static const Uuid _uuid = Uuid();
  final List<ProductModel> _inMemoryProducts = [];

  MockProductRepository() {
    _initDefaultProducts();
  }

  void _initDefaultProducts() {
    _inMemoryProducts.addAll([
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
    ]);
  }

  @override
  Future<Result<List<ProductModel>>> getProducts({
    required String shopId,
    String? categoryId,
    String? searchQuery,
  }) async {
    return executeMock(
      operation: () async {
        var list = _inMemoryProducts.where((p) => p.shopId == shopId).toList();

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

        return list;
      },
      customDelayMs: 300,
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
