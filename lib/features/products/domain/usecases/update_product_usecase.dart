import '../../../../core/utils/result.dart';
import '../models/product_model.dart';
import '../repositories/product_repository_interface.dart';

// Update Live/Published Product Details Use Case
class UpdateProductUseCase {
  final IProductRepository _repository;

  UpdateProductUseCase(this._repository);

  Future<Result<ProductModel>> execute({
    required ProductModel product,
  }) async {
    if (product.name.trim().isEmpty) {
      return const Failure('Product name cannot be empty.');
    }
    if (product.price <= 0) {
      return const Failure('Price must be greater than zero.');
    }
    if (product.stockQuantity < 0) {
      return const Failure('Stock count cannot be negative.');
    }

    return await _repository.updateProduct(product: product);
  }
}