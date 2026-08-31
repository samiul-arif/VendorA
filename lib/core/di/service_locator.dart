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
import '../../features/dashboard/domain/repositories/dashboard_repository_interface.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_metrics_usecase.dart';
import '../../features/dashboard/domain/usecases/get_sales_chart_usecase.dart';
import '../../features/dashboard/data/repositories/mock_dashboard_repository.dart';
import '../../features/dashboard/presentation/controllers/dashboard_controller.dart';
import '../../features/shop/domain/repositories/shop_repository_interface.dart';
import '../../features/shop/domain/usecases/toggle_shop_status_usecase.dart';
import '../../features/shop/domain/usecases/update_shop_info_usecase.dart';
import '../../features/shop/data/repositories/mock_shop_repository.dart';
import '../../features/shop/presentation/controllers/shop_controller.dart';
import '../../features/products/domain/repositories/product_repository_interface.dart';
import '../../features/products/domain/usecases/get_products_usecase.dart';
import '../../features/products/domain/usecases/add_product_usecase.dart';
import '../../features/products/domain/usecases/update_product_usecase.dart';
import '../../features/products/domain/usecases/delete_product_usecase.dart';
import '../../features/products/domain/usecases/toggle_product_availability_usecase.dart';
import '../../features/products/domain/usecases/restock_product_usecase.dart';
import '../../features/products/data/repositories/mock_product_repository.dart';
import '../../features/products/presentation/controllers/product_controller.dart';
import '../../features/categories/domain/repositories/category_repository_interface.dart';
import '../../features/categories/domain/usecases/get_categories_usecase.dart';
import '../../features/categories/domain/usecases/add_category_usecase.dart';
import '../../features/categories/domain/usecases/update_category_usecase.dart';
import '../../features/categories/domain/usecases/delete_category_usecase.dart';
import '../../features/categories/data/repositories/mock_category_repository.dart';
import '../../features/categories/presentation/controllers/category_controller.dart';
import '../../features/orders/domain/repositories/order_repository_interface.dart';
import '../../features/orders/domain/usecases/get_orders_usecase.dart';
import '../../features/orders/domain/usecases/get_order_details_usecase.dart';
import '../../features/orders/domain/usecases/update_order_status_usecase.dart';
import '../../features/orders/data/repositories/mock_order_repository.dart';
import '../../features/orders/presentation/controllers/order_controller.dart';

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

    // Dashboard Module Services & Use Cases
    final dashboardRepository = MockDashboardRepository();
    instance.register<IDashboardRepository>(dashboardRepository);

    final getMetricsUseCase = GetDashboardMetricsUseCase(dashboardRepository);
    instance.register<GetDashboardMetricsUseCase>(getMetricsUseCase);

    final getSalesChartUseCase = GetSalesChartUseCase(dashboardRepository);
    instance.register<GetSalesChartUseCase>(getSalesChartUseCase);

    final dashboardController = DashboardController(
      getMetricsUseCase: getMetricsUseCase,
      getSalesChartUseCase: getSalesChartUseCase,
    );
    instance.register<DashboardController>(dashboardController);

    // Shop Module Services & Use Cases
    final shopRepository = MockShopRepository();
    instance.register<IShopRepository>(shopRepository);

    final toggleStatusUseCase = ToggleShopStatusUseCase(shopRepository);
    instance.register<ToggleShopStatusUseCase>(toggleStatusUseCase);

    final updateInfoUseCase = UpdateShopInfoUseCase(shopRepository);
    instance.register<UpdateShopInfoUseCase>(updateInfoUseCase);

    final shopController = ShopController(
      toggleStatusUseCase: toggleStatusUseCase,
      updateInfoUseCase: updateInfoUseCase,
    );
    if (authController.activeShop != null) {
      shopController.setActiveShop(authController.activeShop!);
    }
    instance.register<ShopController>(shopController);

    // Product Module Services & Use Cases
    final productRepository = MockProductRepository();
    instance.register<IProductRepository>(productRepository);

    final getProductsUseCase = GetProductsUseCase(productRepository);
    instance.register<GetProductsUseCase>(getProductsUseCase);

    final addProductUseCase = AddProductUseCase(productRepository);
    instance.register<AddProductUseCase>(addProductUseCase);

    final updateProductUseCase = UpdateProductUseCase(productRepository);
    instance.register<UpdateProductUseCase>(updateProductUseCase);

    final deleteProductUseCase = DeleteProductUseCase(productRepository);
    instance.register<DeleteProductUseCase>(deleteProductUseCase);

    final toggleAvailabilityUseCase = ToggleProductAvailabilityUseCase(productRepository);
    instance.register<ToggleProductAvailabilityUseCase>(toggleAvailabilityUseCase);

    final restockProductUseCase = RestockProductUseCase(productRepository);
    instance.register<RestockProductUseCase>(restockProductUseCase);

    final productController = ProductController(
      getProductsUseCase: getProductsUseCase,
      addProductUseCase: addProductUseCase,
      updateProductUseCase: updateProductUseCase,
      deleteProductUseCase: deleteProductUseCase,
      toggleAvailabilityUseCase: toggleAvailabilityUseCase,
      restockProductUseCase: restockProductUseCase,
    );
    instance.register<ProductController>(productController);

    // Category Module Services & Use Cases
    final categoryRepository = MockCategoryRepository();
    instance.register<ICategoryRepository>(categoryRepository);

    final getCategoriesUseCase = GetCategoriesUseCase(categoryRepository);
    instance.register<GetCategoriesUseCase>(getCategoriesUseCase);

    final addCategoryUseCase = AddCategoryUseCase(categoryRepository);
    instance.register<AddCategoryUseCase>(addCategoryUseCase);

    final updateCategoryUseCase = UpdateCategoryUseCase(categoryRepository);
    instance.register<UpdateCategoryUseCase>(updateCategoryUseCase);

    final deleteCategoryUseCase = DeleteCategoryUseCase(categoryRepository);
    instance.register<DeleteCategoryUseCase>(deleteCategoryUseCase);

    final categoryController = CategoryController(
      getCategoriesUseCase: getCategoriesUseCase,
      addCategoryUseCase: addCategoryUseCase,
      updateCategoryUseCase: updateCategoryUseCase,
      deleteCategoryUseCase: deleteCategoryUseCase,
    );
    instance.register<CategoryController>(categoryController);

    // Order Module Services & Use Cases
    final orderRepository = MockOrderRepository();
    instance.register<IOrderRepository>(orderRepository);

    final getOrdersUseCase = GetOrdersUseCase(orderRepository);
    instance.register<GetOrdersUseCase>(getOrdersUseCase);

    final getOrderDetailsUseCase = GetOrderDetailsUseCase(orderRepository);
    instance.register<GetOrderDetailsUseCase>(getOrderDetailsUseCase);

    final updateOrderStatusUseCase = UpdateOrderStatusUseCase(orderRepository);
    instance.register<UpdateOrderStatusUseCase>(updateOrderStatusUseCase);

    final orderController = OrderController(
      getOrdersUseCase: getOrdersUseCase,
      getOrderDetailsUseCase: getOrderDetailsUseCase,
      updateOrderStatusUseCase: updateOrderStatusUseCase,
    );
    instance.register<OrderController>(orderController);
  }
}

// Shorthand locator function
T locate<T extends Object>() => ServiceLocator.instance.get<T>();
