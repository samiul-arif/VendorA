import '../storage/storage_service.dart';
import '../storage/session_storage.dart';
import '../routing/navigation_service.dart';
import '../../features/auth/domain/repositories/auth_repository_interface.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_session_usecase.dart';
import '../../features/auth/domain/usecases/switch_shop_usecase.dart';
import '../../features/auth/data/repositories/mock_auth_repository.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

// Lightweight Service Locator for Dependency Injection
class ServiceLocator {
  ServiceLocator._();
  static final ServiceLocator instance = ServiceLocator._();

  final Map<Type, dynamic> _registry = {};

  // Register a singleton instance
  void register<T extends Object>(T service) {
    _registry[T] = service;
  }

  // Resolve a registered service
  T get<T extends Object>() {
    final service = _registry[T];
    if (service == null) {
      throw Exception('Service of type $T is not registered in ServiceLocator.');
    }
    return service as T;
  }

  // Check if a service is registered
  bool isRegistered<T extends Object>() {
    return _registry.containsKey(T);
  }

  // Unregister a service
  void unregister<T extends Object>() {
    _registry.remove(T);
  }

  // Clear all registered services
  void reset() {
    _registry.clear();
  }

  // Initialize all core and feature singleton services
  static Future<void> initCoreServices() async {
    // Core Storage Services
    final storageService = StorageService();
    await storageService.init();
    instance.register<IStorageService>(storageService);

    final sessionStorage = SessionStorage(storageService);
    instance.register<SessionStorage>(sessionStorage);

    // Core Navigation Service
    instance.register<NavigationService>(NavigationService.instance);

    // Auth Module Services & Use Cases
    final authRepository = MockAuthRepository(sessionStorage);
    instance.register<IAuthRepository>(authRepository);

    final loginUseCase = LoginUseCase(authRepository);
    instance.register<LoginUseCase>(loginUseCase);

    final logoutUseCase = LogoutUseCase(authRepository);
    instance.register<LogoutUseCase>(logoutUseCase);

    final getSessionUseCase = GetSessionUseCase(authRepository);
    instance.register<GetSessionUseCase>(getSessionUseCase);

    final switchShopUseCase = SwitchShopUseCase(authRepository);
    instance.register<SwitchShopUseCase>(switchShopUseCase);

    // Auth Controller
    final authController = AuthController(
      loginUseCase: loginUseCase,
      logoutUseCase: logoutUseCase,
      getSessionUseCase: getSessionUseCase,
      switchShopUseCase: switchShopUseCase,
    );
    await authController.initSession();
    instance.register<AuthController>(authController);
  }
}

// Shorthand locator function
T locate<T extends Object>() => ServiceLocator.instance.get<T>();
