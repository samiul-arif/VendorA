import '../../../../core/utils/result.dart';
import '../models/product_model.dart';
import '../repositories/product_repository_interface.dart';

// Get Products with Category and Search Filter Use Case
class GetProductsUseCase {
  final IProductRepository _repository;

  GetProductsUseCase(this._repository);

  Future<Result<List<ProductModel>>> execute({
    required String shopId,
    String? categoryId,
    String? searchQuery,
  }) async {
    if (shopId.trim().isEmpty) {
      return const Failure('Valid Shop ID is required to fetch catalog.');
    }
    return await _repository.getProducts(
      shopId: shopId.trim(),
      categoryId: categoryId,
      searchQuery: searchQuery,
    );
  }
}
