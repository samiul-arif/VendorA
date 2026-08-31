import '../../../../core/utils/result.dart';
import '../../../../shared/models/shop_model.dart';
import '../repositories/shop_repository_interface.dart';

// Toggle Shop Open/Closed Status Use Case
class ToggleShopStatusUseCase {
  final IShopRepository _repository;

  ToggleShopStatusUseCase(this._repository);

  Future<Result<ShopModel>> execute({
    required String shopId,
    required bool isOpen,
  }) async {
    if (shopId.trim().isEmpty) {
      return const Failure('Valid Shop ID is required to update store status.');
    }
    return await _repository.toggleShopStatus(
      shopId: shopId.trim(),
      isOpen: isOpen,
    );
  }
}
