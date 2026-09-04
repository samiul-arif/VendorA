import '../../../../core/utils/result.dart';
import '../../../../shared/models/pagination_model.dart';
import '../models/product_model.dart';
import '../repositories/product_repository_interface.dart';

// Get Paginated Products with Category and Search Filter Use Case
class GetProductsUseCase {
  final IProductRepository _repository;

  GetProductsUseCase(this._repository);

  Future<Result<PaginatedList<ProductModel>>> execute({
    required String shopId,
    int page = 1,
    int pageSize = 20,
    String? categoryId,
    String? searchQuery,
  }) async {
    if (shopId.trim().isEmpty) {
      return const Failure('Valid Shop ID is required to fetch catalog.');
    }
    return await _repository.getProducts(
      shopId: shopId.trim(),
      page: page,
      pageSize: pageSize,
      categoryId: categoryId,
      searchQuery: searchQuery,
    );
  }
}
