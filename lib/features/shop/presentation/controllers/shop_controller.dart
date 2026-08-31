import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/models/shop_model.dart';
import '../../domain/usecases/toggle_shop_status_usecase.dart';
import '../../domain/usecases/update_shop_info_usecase.dart';

// Shop Management & Status Controller
class ShopController extends BaseController {
  final ToggleShopStatusUseCase _toggleStatusUseCase;
  final UpdateShopInfoUseCase _updateInfoUseCase;

  ShopModel? _currentShop;

  ShopController({
    required ToggleShopStatusUseCase toggleStatusUseCase,
    required UpdateShopInfoUseCase updateInfoUseCase,
  })  : _toggleStatusUseCase = toggleStatusUseCase,
        _updateInfoUseCase = updateInfoUseCase;

  // Getters
  ShopModel? get currentShop => _currentShop;
  bool get isStoreOpen => _currentShop?.isOpen ?? false;

  // Set Active Shop Reference
  void setActiveShop(ShopModel shop) {
    _currentShop = shop;
    notifyListeners();
  }

  // Instant Store Open/Close Toggle Action (Optimistic Update)
  Future<Result<ShopModel>> toggleStoreStatus(bool isOpen) async {
    if (_currentShop == null) {
      return const Failure('No active shop selected.');
    }

    // Optimistic Update
    final previousState = _currentShop!.isOpen;
    _currentShop = _currentShop!.copyWith(isOpen: isOpen);
    notifyListeners();

    final result = await _toggleStatusUseCase.execute(
      shopId: _currentShop!.id,
      isOpen: isOpen,
    );

    result.when(
      success: (updated) {
        _currentShop = updated;
        notifyListeners();
      },
      failure: (message, _) {
        // Rollback on failure
        _currentShop = _currentShop!.copyWith(isOpen: previousState);
        notifyListeners();
      },
    );

    return result;
  }

  // Update Shop Information
  Future<Result<ShopModel>> updateShop(ShopModel updatedShop) async {
    return await runWithState<ShopModel>(
      () async {
        final result = await _updateInfoUseCase.execute(shop: updatedShop);
        if (result is Success<ShopModel>) {
          _currentShop = result.data;
        }
        return result;
      },
      isUpdate: true,
    );
  }
}
