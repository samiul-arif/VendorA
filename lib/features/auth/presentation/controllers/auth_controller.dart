import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/models/vendor_model.dart';
import '../../../../shared/models/shop_model.dart';
import '../../../../shared/models/user_session.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_session_usecase.dart';
import '../../domain/usecases/switch_shop_usecase.dart';

// Authentication & Session Controller
class AuthController extends BaseController {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetSessionUseCase _getSessionUseCase;
  final SwitchShopUseCase _switchShopUseCase;

  UserSession? _session;
  bool _isSessionInitialized = false;

  AuthController({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetSessionUseCase getSessionUseCase,
    required SwitchShopUseCase switchShopUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _getSessionUseCase = getSessionUseCase,
        _switchShopUseCase = switchShopUseCase;

  // Getters
  UserSession? get session => _session;
  VendorModel? get vendor => _session?.vendor;
  ShopModel? get activeShop => _session?.activeShop;
  List<ShopModel> get availableShops => _session?.availableShops ?? [];
  bool get isAuthenticated => _session != null && !_session!.isExpired;
  bool get isSessionInitialized => _isSessionInitialized;

  // Initialize Session from Local Storage on Launch
  Future<void> initSession() async {
    final result = await _getSessionUseCase.execute();
    result.when(
      success: (session) {
        _session = session;
        _isSessionInitialized = true;
        setSuccess();
      },
      failure: (msg, ex) {
        _session = null;
        _isSessionInitialized = true;
        setError(msg);
      },
    );
  }

  // Login Action
  Future<Result<UserSession>> login({
    required String email,
    required String password,
  }) async {
    return await runWithState<UserSession>(() async {
      final result = await _loginUseCase.execute(
        email: email,
        password: password,
      );

      if (result is Success<UserSession>) {
        _session = result.data;
      }
      return result;
    });
  }

  // Switch Shop Action
  Future<Result<UserSession>> switchShop(String shopId) async {
    return await runWithState<UserSession>(
      () async {
        final result = await _switchShopUseCase.execute(shopId: shopId);
        if (result is Success<UserSession>) {
          _session = result.data;
        }
        return result;
      },
      isUpdate: true,
    );
  }

  // Update Active Shop and Available Shops in Session
  void updateActiveShop(ShopModel updatedShop) {
    if (_session == null) return;
    final updatedList = _session!.availableShops.map((s) {
      return s.id == updatedShop.id ? updatedShop : s;
    }).toList();

    _session = _session!.copyWith(
      activeShop: updatedShop,
      availableShops: updatedList,
    );
    notifyListeners();
  }

  // Logout Action
  Future<Result<void>> logout() async {
    return await runWithState<void>(() async {
      final result = await _logoutUseCase.execute();
      if (result is Success<void>) {
        _session = null;
      }
      return result;
    });
  }
}
