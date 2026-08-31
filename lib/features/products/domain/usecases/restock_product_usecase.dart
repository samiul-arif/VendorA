import '../../../../core/utils/result.dart';
import '../models/product_model.dart';
import '../repositories/product_repository_interface.dart';

// Quick Restock Product Quantity Use Case
class RestockProductUseCase {
  final IProductRepository _repository;

  RestockProductUseCase(this._repository);

  Future<Result<ProductModel>> execute({
    required String productId,
    required int addQuantity,
  }) async {
    if (productId.trim().isEmpty) {
      return const Failure('Valid Product ID is required.');
    }
    if (addQuantity <= 0) {
      return const Failure('Restock amount must be greater than zero.');
    }
    return await _repository.restockProduct(
      productId: productId.trim(),
      addQuantity: addQuantity,
    );
  }
}
