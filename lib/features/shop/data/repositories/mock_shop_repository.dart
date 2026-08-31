import '../../../../core/network/base_mock_repository.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/models/shop_model.dart';
import '../../domain/repositories/shop_repository_interface.dart';

// Mock Shop Repository with In-Memory Store Status Management
class MockShopRepository extends BaseMockRepository implements IShopRepository {
  final Map<String, ShopModel> _shops = {};

  MockShopRepository() {
    _initDefaultShops();
  }

  void _initDefaultShops() {
    final defaultShop = ShopModel(
      id: 'shop_01',
      vendorId: 'vendor_001',
      name: 'Foodie Hub Express',
      description: 'Signature Burgers, Crispy Fries & Shakes',
      address: '142 Market Street, Downtown',
      city: 'San Francisco',
      phone: '+1 (555) 234-5678',
      isOpen: true,
      autoAcceptOrders: true,
      deliveryFee: 2.99,
      minimumOrderAmount: 12.00,
      rating: 4.9,
      totalReviews: 328,
      openingTime: '08:30 AM',
      closingTime: '11:00 PM',
      primaryCategory: 'Fast Food & Burgers',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    );
    _shops[defaultShop.id] = defaultShop;
  }

  @override
  Future<Result<ShopModel>> getShopDetails({
    required String shopId,
  }) async {
    return executeMock(
      operation: () async {
        final shop = _shops[shopId];
        if (shop == null) {
          throw Exception('Shop $shopId not found.');
        }
        return shop;
      },
      customDelayMs: 300,
    );
  }

  @override
  Future<Result<ShopModel>> toggleShopStatus({
    required String shopId,
    required bool isOpen,
  }) async {
    return executeMock(
      operation: () async {
        final shop = _shops[shopId] ??
            ShopModel(
              id: shopId,
              vendorId: 'vendor_001',
              name: 'Foodie Hub Express',
              description: 'Signature Burgers',
              address: 'Downtown',
              city: 'San Francisco',
              phone: '+1 (555) 234-5678',
              isOpen: isOpen,
              createdAt: DateTime.now().subtract(const Duration(days: 90)),
            );

        final updated = shop.copyWith(isOpen: isOpen);
        _shops[shopId] = updated;
        return updated;
      },
      customDelayMs: 250,
    );
  }

  @override
  Future<Result<ShopModel>> updateAutoAcceptOrders({
    required String shopId,
    required bool autoAccept,
  }) async {
    return executeMock(
      operation: () async {
        final shop = _shops[shopId];
        if (shop == null) throw Exception('Shop not found.');
        final updated = shop.copyWith(autoAcceptOrders: autoAccept);
        _shops[shopId] = updated;
        return updated;
      },
      customDelayMs: 250,
    );
  }

  @override
  Future<Result<ShopModel>> updateOperatingHours({
    required String shopId,
    required String openingTime,
    required String closingTime,
  }) async {
    return executeMock(
      operation: () async {
        final shop = _shops[shopId];
        if (shop == null) throw Exception('Shop not found.');
        final updated = shop.copyWith(
          openingTime: openingTime,
          closingTime: closingTime,
        );
        _shops[shopId] = updated;
        return updated;
      },
      customDelayMs: 350,
    );
  }

  @override
  Future<Result<ShopModel>> updateShopInfo({
    required ShopModel shop,
  }) async {
    return executeMock(
      operation: () async {
        _shops[shop.id] = shop;
        return shop;
      },
      customDelayMs: 400,
    );
  }
}
