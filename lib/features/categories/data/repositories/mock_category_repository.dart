import '../../../../core/network/base_mock_repository.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/category_model.dart';
import '../../domain/repositories/category_repository_interface.dart';

// Mock Category Repository with In-Memory Storage & Food-Tech Catalog Data
class MockCategoryRepository extends BaseMockRepository implements ICategoryRepository {
  final Map<String, CategoryModel> _categories = {};

  MockCategoryRepository() {
    _initDefaultCategories();
  }

  void _initDefaultCategories() {
    final defaultList = [
      CategoryModel(
        id: 'cat_01',
        shopId: 'shop_01',
        name: 'Burgers & Sandwiches',
        description: 'Handcrafted Angus beef burgers, artisan brioche buns, and gourmet grilled sandwiches.',
        itemCount: 4,
        sortOrder: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      CategoryModel(
        id: 'cat_02',
        shopId: 'shop_01',
        name: 'Sides & Appetizers',
        description: 'Crispy seasoned fries, loaded cheese bites, onion rings, and sharing starters.',
        itemCount: 3,
        sortOrder: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      CategoryModel(
        id: 'cat_03',
        shopId: 'shop_01',
        name: 'Beverages & Drinks',
        description: 'Chilled craft sodas, thick milkshakes, freshly brewed iced teas, and mineral waters.',
        itemCount: 2,
        sortOrder: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      CategoryModel(
        id: 'cat_04',
        shopId: 'shop_01',
        name: 'Desserts & Sweets',
        description: 'Warm molten chocolate lava cakes, artisan cheesecakes, and sweet bakery delights.',
        itemCount: 1,
        sortOrder: 4,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
      CategoryModel(
        id: 'cat_05',
        shopId: 'shop_01',
        name: 'Healthy Bowls & Greens',
        description: 'Nutrient-rich grain bowls, organic farm salads, and high-protein bowls.',
        itemCount: 2,
        sortOrder: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    for (final cat in defaultList) {
      _categories[cat.id] = cat;
    }
  }

  @override
  Future<Result<List<CategoryModel>>> getCategories({
    required String shopId,
    bool forceRefresh = false,
  }) async {
    return executeMock(
      operation: () async {
        final list = _categories.values
            .where((cat) => cat.shopId == shopId || cat.shopId == 'shop_01')
            .toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        return list;
      },
      customDelayMs: forceRefresh ? 450 : 250,
    );
  }

  @override
  Future<Result<CategoryModel>> getCategoryById({
    required String categoryId,
  }) async {
    return executeMock(
      operation: () async {
        final cat = _categories[categoryId];
        if (cat == null) {
          throw Exception('Category not found.');
        }
        return cat;
      },
      customDelayMs: 200,
    );
  }

  @override
  Future<Result<CategoryModel>> addCategory({
    required CategoryModel category,
  }) async {
    return executeMock(
      operation: () async {
        final newId = category.id.isNotEmpty
            ? category.id
            : 'cat_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

        final newCategory = category.copyWith(
          id: newId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          sortOrder: _categories.length + 1,
        );

        _categories[newId] = newCategory;
        return newCategory;
      },
      customDelayMs: 350,
    );
  }

  @override
  Future<Result<CategoryModel>> updateCategory({
    required CategoryModel category,
  }) async {
    return executeMock(
      operation: () async {
        if (!_categories.containsKey(category.id)) {
          throw Exception('Category with ID ${category.id} does not exist.');
        }

        final updated = category.copyWith(
          updatedAt: DateTime.now(),
        );

        _categories[category.id] = updated;
        return updated;
      },
      customDelayMs: 300,
    );
  }

  @override
  Future<Result<void>> deleteCategory({
    required String categoryId,
  }) async {
    return executeMock(
      operation: () async {
        if (!_categories.containsKey(categoryId)) {
          throw Exception('Category does not exist.');
        }
        _categories.remove(categoryId);
      },
      customDelayMs: 250,
    );
  }
}
