import '../../../../core/utils/result.dart';
import '../models/product_model.dart';
import '../repositories/product_repository_interface.dart';

// Add Product to Catalog Use Case
class AddProductUseCase {
  final IProductRepository _repository;

  AddProductUseCase(this._repository);

  Future<Result<ProductModel>> execute({
    required ProductModel product,
  }) async {
    if (product.name.trim().isEmpty) {
      return const Failure('Product title cannot be empty.');
    }
    if (product.price <= 0) {
      return const Failure('Price must be greater than zero.');
    }
    if (product.stockQuantity < 0) {
      return const Failure('Stock quantity cannot be negative.');
    }
    if (product.categoryId.trim().isEmpty) {
      return const Failure('Please select a category for this product.');
    }

    return await _repository.addProduct(product: product);
  }
}
