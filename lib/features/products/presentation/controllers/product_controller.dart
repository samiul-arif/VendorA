import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/models/pagination_model.dart';
import '../../data/repositories/mock_product_repository.dart';
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

// Product & Inventory Controller with Enterprise Pagination
class ProductController extends BaseController {
  final GetProductsUseCase _getProductsUseCase;
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final ToggleProductAvailabilityUseCase _toggleAvailabilityUseCase;
  final RestockProductUseCase _restockProductUseCase;

  PaginatedList<ProductModel> _paginatedProducts = PaginatedList.empty();
  int _currentPage = 1;
  int _pageSize = 20;
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  String? _activeShopId;

  // Cached global category totals for accurate filter tab counts
  final List<ProductModel> _allCatalogSnapshot = MockProductRepository.createDefaultProducts();

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
  PaginatedList<ProductModel> get paginatedProducts => _paginatedProducts;
  List<ProductModel> get products => _paginatedProducts.items;
  List<ProductModel> get filteredProducts => _paginatedProducts.items;
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  int get totalItems => _paginatedProducts.totalItems;
  int get totalPages => _paginatedProducts.totalPages;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  String? get activeShopId => _activeShopId;

  // Calculated Category list with counts across the full catalog
  List<CategoryFilterItem> get categories {
    final Map<String, int> counts = {};
    final Map<String, String> names = {
      'cat_01': 'Burgers & Sandwiches',
      'cat_02': 'Sides & Appetizers',
      'cat_03': 'Beverages & Drinks',
      'cat_04': 'Pizzas & Calzones',
      'cat_05': 'Desserts & Sweets',
      'cat_06': 'Combos & Deals',
    };

    for (final p in _allCatalogSnapshot) {
      counts[p.categoryId] = (counts[p.categoryId] ?? 0) + 1;
      names[p.categoryId] = p.categoryName;
    }

    final items = [
      CategoryFilterItem(
        id: 'all',
        name: 'All Items',
        itemCount: _allCatalogSnapshot.length,
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

  // Load Products for Active Shop with Pagination
  Future<void> loadProducts({
    required String shopId,
    int? page,
    int? pageSize,
    bool isSilent = false,
  }) async {
    _activeShopId = shopId;
    if (page != null) _currentPage = page;
    if (pageSize != null) _pageSize = pageSize;

    await runWithState<PaginatedList<ProductModel>>(() async {
      final result = await _getProductsUseCase.execute(
        shopId: shopId,
        page: _currentPage,
        pageSize: _pageSize,
        categoryId: _selectedCategoryId,
        searchQuery: _searchQuery,
      );

      if (result is Success<PaginatedList<ProductModel>>) {
        _paginatedProducts = result.data;
        _currentPage = result.data.currentPage;
      }
      return result;
    }, isUpdate: isSilent);
  }

  // Go to specific Page
  Future<void> goToPage(int page) async {
    if (_activeShopId == null || page == _currentPage || page < 1) return;
    await loadProducts(shopId: _activeShopId!, page: page, isSilent: false);
  }

  // Set Page Size (e.g. 10, 20, 50, 100)
  Future<void> setPageSize(int size) async {
    if (_activeShopId == null || size == _pageSize) return;
    _pageSize = size;
    _currentPage = 1;
    await loadProducts(shopId: _activeShopId!, page: 1, pageSize: size);
  }

  // Next Page
  Future<void> nextPage() async {
    if (_paginatedProducts.hasNextPage) {
      await goToPage(_currentPage + 1);
    }
  }

  // Previous Page
  Future<void> previousPage() async {
    if (_paginatedProducts.hasPreviousPage) {
      await goToPage(_currentPage - 1);
    }
  }

  // Category Filter Select
  void setCategoryFilter(String categoryId) {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    _currentPage = 1;
    if (_activeShopId != null) {
      loadProducts(shopId: _activeShopId!, page: 1);
    } else {
      notifyListeners();
    }
  }

  // Search Filter
  void setSearchQuery(String query) {
    _searchQuery = query;
    _currentPage = 1;
    if (_activeShopId != null) {
      loadProducts(shopId: _activeShopId!, page: 1);
    } else {
      notifyListeners();
    }
  }

  // Clear Search
  void clearSearch() {
    _searchQuery = '';
    _currentPage = 1;
    if (_activeShopId != null) {
      loadProducts(shopId: _activeShopId!, page: 1);
    } else {
      notifyListeners();
    }
  }

  // 1-Tap Toggle Availability (Optimistic Offline Sync)
  Future<Result<ProductModel>> toggleAvailability(
    String productId,
    bool isAvailable,
  ) async {
    final currentItems = List<ProductModel>.from(_paginatedProducts.items);
    final index = currentItems.indexWhere((p) => p.id == productId);
    if (index == -1) {
      return const Failure('Product not found in current view.');
    }

    // Optimistic Update
    final original = currentItems[index];
    currentItems[index] = original.copyWith(
      isAvailable: isAvailable,
      isManualOutOfStock: !isAvailable,
    );
    _paginatedProducts = _paginatedProducts.copyWith(items: currentItems);
    notifyListeners();

    final result = await _toggleAvailabilityUseCase.execute(
      productId: productId,
      isAvailable: isAvailable,
    );

    result.when(
      success: (updated) {
        currentItems[index] = updated;
        _paginatedProducts = _paginatedProducts.copyWith(items: currentItems);
        notifyListeners();
      },
      failure: (message, _) {
        // Rollback
        currentItems[index] = original;
        _paginatedProducts = _paginatedProducts.copyWith(items: currentItems);
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
          final currentItems = List<ProductModel>.from(_paginatedProducts.items);
          final index = currentItems.indexWhere((p) => p.id == productId);
          if (index != -1) {
            currentItems[index] = result.data;
            _paginatedProducts = _paginatedProducts.copyWith(items: currentItems);
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
          if (_activeShopId != null) {
            await loadProducts(shopId: _activeShopId!, page: 1, isSilent: true);
          }
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
          final currentItems = List<ProductModel>.from(_paginatedProducts.items);
          final index = currentItems.indexWhere((p) => p.id == product.id);
          if (index != -1) {
            currentItems[index] = result.data;
            _paginatedProducts = _paginatedProducts.copyWith(items: currentItems);
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
          if (_activeShopId != null) {
            await loadProducts(shopId: _activeShopId!, page: _currentPage, isSilent: true);
          }
        }
        return result;
      },
      isUpdate: true,
    );
  }
}
