import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/product_model.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/toggle_product_availability_usecase.dart';
import '../../domain/usecases/restock_product_usecase.dart';

// Category metadata helper for filter bar
class CategoryFilterItem {
  final String id;
  final String name;
  final int itemCount;

  const CategoryFilterItem({
    required this.id,
    required this.name,
    required this.itemCount,
  });
}

// Product & Inventory Controller
class ProductController extends BaseController {
  final GetProductsUseCase _getProductsUseCase;
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final ToggleProductAvailabilityUseCase _toggleAvailabilityUseCase;
  final RestockProductUseCase _restockProductUseCase;

  List<ProductModel> _allProducts = [];
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  String? _activeShopId;

  ProductController({
    required GetProductsUseCase getProductsUseCase,
    required AddProductUseCase addProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
    required ToggleProductAvailabilityUseCase toggleAvailabilityUseCase,
    required RestockProductUseCase restockProductUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        _addProductUseCase = addProductUseCase,
        _updateProductUseCase = updateProductUseCase,
        _deleteProductUseCase = deleteProductUseCase,
        _toggleAvailabilityUseCase = toggleAvailabilityUseCase,
        _restockProductUseCase = restockProductUseCase;

  // Getters
  List<ProductModel> get products => _allProducts;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;

  // Filtered Products based on search query and category
  List<ProductModel> get filteredProducts {
    var list = _allProducts;

    if (_selectedCategoryId != 'all') {
      list = list.where((p) => p.categoryId == _selectedCategoryId).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      list = list.where((p) =>
          p.name.toLowerCase().contains(query) ||
          p.description.toLowerCase().contains(query) ||
          p.categoryName.toLowerCase().contains(query)).toList();
    }

    return list;
  }

  // Calculated Category list with counts
  List<CategoryFilterItem> get categories {
    final Map<String, int> counts = {};
    final Map<String, String> names = {};

    for (final p in _allProducts) {
      counts[p.categoryId] = (counts[p.categoryId] ?? 0) + 1;
      names[p.categoryId] = p.categoryName;
    }

    final items = [
      CategoryFilterItem(
        id: 'all',
        name: 'All Items',
        itemCount: _allProducts.length,
      ),
    ];

    counts.forEach((catId, count) {
      items.add(
        CategoryFilterItem(
          id: catId,
          name: names[catId] ?? 'Category',
          itemCount: count,
        ),
      );
    });

    return items;
  }

  // Load Products for Active Shop
  Future<void> loadProducts({required String shopId}) async {
    _activeShopId = shopId;

    await runWithState<List<ProductModel>>(() async {
      final result = await _getProductsUseCase.execute(shopId: shopId);
      if (result is Success<List<ProductModel>>) {
        _allProducts = result.data;
      }
      return result;
    });
  }

  // Category Filter Select
  void setCategoryFilter(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  // Search Filter
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Clear Search
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // 1-Tap Toggle Availability (Optimistic Offline Sync)
  Future<Result<ProductModel>> toggleAvailability(
    String productId,
    bool isAvailable,
  ) async {
    final index = _allProducts.indexWhere((p) => p.id == productId);
    if (index == -1) {
      return const Failure('Product not found in current view.');
    }

    // Optimistic Update
    final original = _allProducts[index];
    _allProducts[index] = original.copyWith(
      isAvailable: isAvailable,
      isManualOutOfStock: !isAvailable,
    );
    notifyListeners();

    final result = await _toggleAvailabilityUseCase.execute(
      productId: productId,
      isAvailable: isAvailable,
    );

    result.when(
      success: (updated) {
        _allProducts[index] = updated;
        notifyListeners();
      },
      failure: (message, _) {
        // Rollback
        _allProducts[index] = original;
        notifyListeners();
      },
    );

    return result;
  }

  // Quick Restock Action
  Future<Result<ProductModel>> restockProduct(
    String productId,
    int addQuantity,
  ) async {
    return await runWithState<ProductModel>(
      () async {
        final result = await _restockProductUseCase.execute(
          productId: productId,
          addQuantity: addQuantity,
        );

        if (result is Success<ProductModel>) {
          final index = _allProducts.indexWhere((p) => p.id == productId);
          if (index != -1) {
            _allProducts[index] = result.data;
          }
        }
        return result;
      },
      isUpdate: true,
    );
  }

  // Add New Product
  Future<Result<ProductModel>> addProduct(ProductModel product) async {
    return await runWithState<ProductModel>(
      () async {
        final result = await _addProductUseCase.execute(product: product);
        if (result is Success<ProductModel>) {
          _allProducts.insert(0, result.data);
        }
        return result;
      },
      isUpdate: true,
    );
  }

  // Update Existing Product
  Future<Result<ProductModel>> updateProduct(ProductModel product) async {
    return await runWithState<ProductModel>(
      () async {
        final result = await _updateProductUseCase.execute(product: product);
        if (result is Success<ProductModel>) {
          final index = _allProducts.indexWhere((p) => p.id == product.id);
          if (index != -1) {
            _allProducts[index] = result.data;
          }
        }
        return result;
      },
      isUpdate: true,
    );
  }

  // Delete Product
  Future<Result<void>> deleteProduct(String productId) async {
    return await runWithState<void>(
      () async {
        final result = await _deleteProductUseCase.execute(productId: productId);
        if (result is Success<void>) {
          _allProducts.removeWhere((p) => p.id == productId);
        }
        return result;
      },
      isUpdate: true,
    );
  }
}
