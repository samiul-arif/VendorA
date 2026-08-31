import '../../../../core/utils/result.dart';
import '../../../../shared/models/shop_model.dart';

// Shop Management Repository Contract
abstract class IShopRepository {
  // Get shop details by ID
  Future<Result<ShopModel>> getShopDetails({
    required String shopId,
  });

  // Toggle store open/closed status
  Future<Result<ShopModel>> toggleShopStatus({
    required String shopId,
    required bool isOpen,
  });

  // Update auto-accept orders setting
  Future<Result<ShopModel>> updateAutoAcceptOrders({
    required String shopId,
    required bool autoAccept,
  });

  // Update operating hours
  Future<Result<ShopModel>> updateOperatingHours({
    required String shopId,
    required String openingTime,
    required String closingTime,
  });

  // Update shop profile information
  Future<Result<ShopModel>> updateShopInfo({
    required ShopModel shop,
  });
}
