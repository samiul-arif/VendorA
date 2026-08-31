import '../../../../core/utils/result.dart';
import '../../../../shared/models/shop_model.dart';
import '../repositories/shop_repository_interface.dart';

// Update Shop Profile Information Use Case
class UpdateShopInfoUseCase {
  final IShopRepository _repository;

  UpdateShopInfoUseCase(this._repository);

  Future<Result<ShopModel>> execute({
    required ShopModel shop,
  }) async {
    if (shop.name.trim().isEmpty) {
      return const Failure('Shop name cannot be empty.');
    }
    return await _repository.updateShopInfo(shop: shop);
  }
}
