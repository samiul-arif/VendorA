import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../../../core/network/base_mock_repository.dart';
import '../../../../core/storage/session_storage.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/models/vendor_model.dart';
import '../../../../shared/models/shop_model.dart';
import '../../../../shared/models/user_session.dart';
import '../../domain/repositories/auth_repository_interface.dart';

// Mock Authentication Repository with Multi-Shop and Session Persistence
class MockAuthRepository extends BaseMockRepository implements IAuthRepository {
  final SessionStorage _sessionStorage;
  static const Uuid _uuid = Uuid();

  UserSession? _inMemorySession;

  MockAuthRepository(this._sessionStorage);

  // Pre-configured Mock Vendor
  static final VendorModel _defaultVendor = VendorModel(
    id: 'vendor_001',
    name: 'Samiul Arif',
    email: 'demo@vendor.com',
    phoneNumber: '+1 (555) 234-5678',
    profileImageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    businessName: 'Arif Food Enterprises LLC',
    businessRegistrationNumber: 'BN-89234710',
    shopIds: const ['shop_01', 'shop_02', 'shop_03'],
    createdAt: DateTime.now().subtract(const Duration(days: 120)),
  );

  // Pre-configured Multi-Shop Roster
  static final List<ShopModel> _mockShops = [
    ShopModel(
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
    ),
    ShopModel(
      id: 'shop_02',
      vendorId: 'vendor_001',
      name: 'Fresh Mart & Bakery',
      description: 'Artisan Breads, Pastries & Organic Groceries',
      address: '88 Green Valley Road',
      city: 'San Francisco',
      phone: '+1 (555) 876-5432',
      isOpen: false,
      autoAcceptOrders: false,
      deliveryFee: 3.50,
      minimumOrderAmount: 15.00,
      rating: 4.7,
      totalReviews: 145,
      openingTime: '07:00 AM',
      closingTime: '09:00 PM',
      primaryCategory: 'Bakery & Grocery',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    ShopModel(
      id: 'shop_03',
      vendorId: 'vendor_001',
      name: 'Sweet Delights Cafe',
      description: 'Gourmet Desserts, Specialty Coffee & Boba Tea',
      address: '502 Sunset Blvd',
      city: 'San Francisco',
      phone: '+1 (555) 345-6789',
      isOpen: true,
      autoAcceptOrders: false,
      deliveryFee: 1.99,
      minimumOrderAmount: 8.00,
      rating: 4.8,
      totalReviews: 210,
      openingTime: '10:00 AM',
      closingTime: '10:00 PM',
      primaryCategory: 'Cafe & Desserts',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
  ];

  @override
  Future<Result<UserSession>> login({
    required String email,
    required String password,
  }) async {
    return executeMock(
      operation: () async {
        // Credential validation (Demo Accounts)
        final isValidDemo = (email == 'demo@vendor.com' && password == 'vendor123') ||
            (email == 'partner@foodpanda.com' && password == 'partner123');

        if (!isValidDemo) {
          throw Exception('Invalid email or password. Please use demo@vendor.com / vendor123');
        }

        final token = 'mock_jwt_token_${_uuid.v4()}';
        final refreshToken = 'mock_refresh_token_${_uuid.v4()}';

        final session = UserSession(
          token: token,
          refreshToken: refreshToken,
          vendor: _defaultVendor.copyWith(email: email),
          activeShop: _mockShops.first,
          availableShops: _mockShops,
          expiresAt: DateTime.now().add(const Duration(days: 30)),
        );

        _inMemorySession = session;

        // Persist to local session storage
        await _sessionStorage.saveAuthToken(token);
        await _sessionStorage.saveCurrentShopId(_mockShops.first.id);
        await _sessionStorage.saveSessionData(session.toJson());

        return session;
      },
      customDelayMs: 650,
    );
  }

  @override
  Future<Result<void>> logout() async {
    return executeMock(
      operation: () async {
        _inMemorySession = null;
        await _sessionStorage.clearSession();
      },
      customDelayMs: 300,
    );
  }

  @override
  Future<Result<UserSession?>> getCurrentSession() async {
    return executeMock(
      operation: () async {
        if (_inMemorySession != null) {
          return _inMemorySession;
        }

        final sessionJson = _sessionStorage.getSessionData();
        if (sessionJson != null) {
          try {
            _inMemorySession = UserSession.fromJson(sessionJson);
            return _inMemorySession;
          } catch (_) {
            return null;
          }
        }
        return null;
      },
      customDelayMs: 150,
    );
  }

  @override
  Future<Result<UserSession>> switchShop({
    required String shopId,
  }) async {
    return executeMock(
      operation: () async {
        final current = _inMemorySession;
        if (current == null) {
          throw Exception('No active session found. Please log in.');
        }

        final selectedShop = current.availableShops.firstWhere(
          (s) => s.id == shopId,
          orElse: () => throw Exception('Shop not found in vendor portfolio.'),
        );

        final updatedSession = current.copyWith(activeShop: selectedShop);
        _inMemorySession = updatedSession;

        await _sessionStorage.saveCurrentShopId(shopId);
        await _sessionStorage.saveSessionData(updatedSession.toJson());

        return updatedSession;
      },
      customDelayMs: 400,
    );
  }

  @override
  Future<Result<void>> forgotPassword({
    required String email,
  }) async {
    return executeMock(
      operation: () async {
        // Simulated password reset trigger
        return;
      },
      customDelayMs: 500,
    );
  }

  @override
  Future<Result<UserSession>> refreshToken() async {
    return executeMock(
      operation: () async {
        final current = _inMemorySession;
        if (current == null) {
          throw Exception('Session expired.');
        }
        final refreshed = current.copyWith(
          token: 'mock_jwt_refreshed_${_uuid.v4()}',
          expiresAt: DateTime.now().add(const Duration(days: 30)),
        );
        _inMemorySession = refreshed;
        await _sessionStorage.saveAuthToken(refreshed.token);
        return refreshed;
      },
    );
  }
}
