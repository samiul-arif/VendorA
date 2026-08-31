import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/category_model.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/add_category_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';
import '../../domain/usecases/delete_category_usecase.dart';

// Category State & Management Controller
class CategoryController extends BaseController {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final AddCategoryUseCase _addCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;

  List<CategoryModel> _categories = [];
  String _searchQuery = '';
  String? _activeShopId;

  CategoryController({
    required GetCategoriesUseCase getCategoriesUseCase,
    required AddCategoryUseCase addCategoryUseCase,
    required UpdateCategoryUseCase updateCategoryUseCase,
    required DeleteCategoryUseCase deleteCategoryUseCase,
  })  : _getCategoriesUseCase = getCategoriesUseCase,
        _addCategoryUseCase = addCategoryUseCase,
        _updateCategoryUseCase = updateCategoryUseCase,
        _deleteCategoryUseCase = deleteCategoryUseCase;

  // Getters
  List<CategoryModel> get categories => _categories;
  String get searchQuery => _searchQuery;

  List<CategoryModel> get filteredCategories {
    if (_searchQuery.trim().isEmpty) return _categories;
    final q = _searchQuery.toLowerCase().trim();
    return _categories.where((cat) {
      return cat.name.toLowerCase().contains(q) ||
          cat.description.toLowerCase().contains(q);
    }).toList();
  }

  // Load Categories for Active Shop
  Future<void> loadCategories({required String shopId, bool forceRefresh = false}) async {
    _activeShopId = shopId;

    await runWithState<void>(() async {
      final result = await _getCategoriesUseCase.execute(
        shopId: shopId,
        forceRefresh: forceRefresh,
      );

      if (result is Success<List<CategoryModel>>) {
        _categories = result.data;
        return const Success<void>(null);
      } else if (result is Failure<List<CategoryModel>>) {
        return Failure<void>(result.message);
      }
      return const Success<void>(null);
    });
  }

  // Search Filter
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Add Category
  Future<Result<CategoryModel>> addCategory({
    required String name,
    required String description,
  }) async {
    if (_activeShopId == null) {
      return const Failure('No active shop session found.');
    }

    final newCategory = CategoryModel(
      id: '',
      shopId: _activeShopId!,
      name: name.trim(),
      description: description.trim(),
      itemCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await _addCategoryUseCase.execute(category: newCategory);

    if (result is Success<CategoryModel>) {
      _categories.add(result.data);
      notifyListeners();
    }

    return result;
  }

  // Update Category
  Future<Result<CategoryModel>> updateCategory({
    required CategoryModel category,
    required String newName,
    required String newDescription,
  }) async {
    final updated = category.copyWith(
      name: newName.trim(),
      description: newDescription.trim(),
    );

    final result = await _updateCategoryUseCase.execute(category: updated);

    if (result is Success<CategoryModel>) {
      final index = _categories.indexWhere((c) => c.id == updated.id);
      if (index != -1) {
        _categories[index] = result.data;
        notifyListeners();
      }
    }

    return result;
  }

  // Delete Category
  Future<Result<void>> deleteCategory(String categoryId) async {
    final result = await _deleteCategoryUseCase.execute(categoryId: categoryId);

    if (result is Success<void>) {
      _categories.removeWhere((c) => c.id == categoryId);
      notifyListeners();
    }

    return result;
  }
}
