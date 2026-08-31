import '../../../../core/utils/result.dart';
import '../models/category_model.dart';
import '../repositories/category_repository_interface.dart';

// Get Categories Use Case
class GetCategoriesUseCase {
  final ICategoryRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<Result<List<CategoryModel>>> execute({
    required String shopId,
    bool forceRefresh = false,
  }) async {
    if (shopId.trim().isEmpty) {
      return const Failure('Invalid shop identifier.');
    }

    return await _repository.getCategories(
      shopId: shopId,
      forceRefresh: forceRefresh,
    );
  }
}
