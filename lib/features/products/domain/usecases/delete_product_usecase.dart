import '../../../../core/utils/result.dart';
import '../repositories/product_repository_interface.dart';

// Delete or Archive Product Use Case
class DeleteProductUseCase {
  final IProductRepository _repository;

  DeleteProductUseCase(this._repository);

  Future<Result<void>> execute({
    required String productId,
    bool softDelete = true,
  }) async {
    if (productId.trim().isEmpty) {
      return const Failure('Valid Product ID is required.');
    }
    return await _repository.deleteProduct(
      productId: productId.trim(),
      softDelete: softDelete,
    );
  }
}
