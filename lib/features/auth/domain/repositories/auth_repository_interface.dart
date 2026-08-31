import '../../../../core/utils/result.dart';
import '../../../../shared/models/user_session.dart';
import '../../../../shared/models/shop_model.dart';

// Authentication Repository Contract (API-Ready Domain Interface)
abstract class IAuthRepository {
  // Login with email and password
  Future<Result<UserSession>> login({
    required String email,
    required String password,
  });

  // Logout and invalidate session
  Future<Result<void>> logout();

  // Get current stored session
  Future<Result<UserSession?>> getCurrentSession();

  // Switch active shop in multi-shop setup
  Future<Result<UserSession>> switchShop({
    required String shopId,
  });

  // Request password reset
  Future<Result<void>> forgotPassword({
    required String email,
  });

  // Refresh auth tokens
  Future<Result<UserSession>> refreshToken();
}
