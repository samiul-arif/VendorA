import '../../../../core/utils/result.dart';
import '../models/category_model.dart';
import '../repositories/category_repository_interface.dart';

// Update Category Use Case
class UpdateCategoryUseCase {
  final ICategoryRepository _repository;

  UpdateCategoryUseCase(this._repository);

  Future<Result<CategoryModel>> execute({
    required CategoryModel category,
  }) async {
    if (category.id.trim().isEmpty) {
      return const Failure('Category ID is required for update.');
    }
    if (category.name.trim().isEmpty) {
      return const Failure('Category name cannot be empty.');
    }

    return await _repository.updateCategory(category: category);
  }
}
