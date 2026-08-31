import '../storage/storage_service.dart';
import '../storage/session_storage.dart';
import '../routing/navigation_service.dart';

/// Lightweight Service Locator for Dependency Injection
class ServiceLocator {
  ServiceLocator._();
  static final ServiceLocator instance = ServiceLocator._();

  final Map<Type, dynamic> _registry = {};

  /// Register a singleton instance
  void register<T extends Object>(T service) {
    _registry[T] = service;
  }

  /// Resolve a registered service
  T get<T extends Object>() {
    final service = _registry[T];
    if (service == null) {
      throw Exception('Service of type $T is not registered in ServiceLocator.');
    }
    return service as T;
  }

  /// Check if a service is registered
  bool isRegistered<T extends Object>() {
    return _registry.containsKey(T);
  }

  /// Unregister a service
  void unregister<T extends Object>() {
    _registry.remove(T);
  }

  /// Clear all registered services
  void reset() {
    _registry.clear();
  }

  /// Initialize all core singleton services
  static Future<void> initCoreServices() async {
    final storageService = StorageService();
    await storageService.init();
    instance.register<IStorageService>(storageService);

    final sessionStorage = SessionStorage(storageService);
    instance.register<SessionStorage>(sessionStorage);

    instance.register<NavigationService>(NavigationService.instance);
  }
}

/// Shorthand locator function
T locate<T extends Object>() => ServiceLocator.instance.get<T>();
