import '../../../../core/utils/result.dart';
import '../models/category_model.dart';
import '../repositories/category_repository_interface.dart';

// Add Category Use Case
class AddCategoryUseCase {
  final ICategoryRepository _repository;

  AddCategoryUseCase(this._repository);

  Future<Result<CategoryModel>> execute({
    required CategoryModel category,
  }) async {
    if (category.name.trim().isEmpty) {
      return const Failure('Category name cannot be empty.');
    }
    if (category.shopId.trim().isEmpty) {
      return const Failure('Category must be associated with a valid shop.');
    }

    return await _repository.addCategory(category: category);
  }
}
