import '../../../../core/utils/result.dart';
import '../repositories/category_repository_interface.dart';

// Delete Category Use Case
class DeleteCategoryUseCase {
  final ICategoryRepository _repository;

  DeleteCategoryUseCase(this._repository);

  Future<Result<void>> execute({
    required String categoryId,
  }) async {
    if (categoryId.trim().isEmpty) {
      return const Failure('Invalid category identifier.');
    }

    return await _repository.deleteCategory(categoryId: categoryId);
  }
}
