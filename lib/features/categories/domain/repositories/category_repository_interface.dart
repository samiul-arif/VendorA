import '../../../../core/utils/result.dart';
import '../models/category_model.dart';

// Category Repository Interface Definition
abstract class ICategoryRepository {
  // Fetch list of categories for a specific shop
  Future<Result<List<CategoryModel>>> getCategories({
    required String shopId,
    bool forceRefresh = false,
  });

  // Fetch single category by ID
  Future<Result<CategoryModel>> getCategoryById({
    required String categoryId,
  });

  // Add a new category
  Future<Result<CategoryModel>> addCategory({
    required CategoryModel category,
  });

  // Update existing category
  Future<Result<CategoryModel>> updateCategory({
    required CategoryModel category,
  });

  // Delete category by ID
  Future<Result<void>> deleteCategory({
    required String categoryId,
  });
}
