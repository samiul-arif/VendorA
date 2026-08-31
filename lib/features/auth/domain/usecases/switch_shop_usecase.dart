import '../../../../core/utils/result.dart';
import '../../../../shared/models/user_session.dart';
import '../repositories/auth_repository_interface.dart';

// Switch Active Shop Use Case (Multi-Shop Support)
class SwitchShopUseCase {
  final IAuthRepository _repository;

  SwitchShopUseCase(this._repository);

  Future<Result<UserSession>> execute({
    required String shopId,
  }) async {
    if (shopId.trim().isEmpty) {
      return const Failure('Invalid Shop ID specified.');
    }
    return await _repository.switchShop(shopId: shopId.trim());
  }
}
