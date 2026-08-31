import '../../../../core/utils/result.dart';
import '../models/product_model.dart';
import '../repositories/product_repository_interface.dart';

// 1-Tap Toggle Product Availability (Offline Kitchen Stock Out Sync)
class ToggleProductAvailabilityUseCase {
  final IProductRepository _repository;

  ToggleProductAvailabilityUseCase(this._repository);

  Future<Result<ProductModel>> execute({
    required String productId,
    required bool isAvailable,
  }) async {
    if (productId.trim().isEmpty) {
      return const Failure('Product ID cannot be empty.');
    }
    return await _repository.toggleProductAvailability(
      productId: productId.trim(),
      isAvailable: isAvailable,
    );
  }
}
