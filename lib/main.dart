import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/routing/navigation_service.dart';
import 'core/di/service_locator.dart';
import 'core/storage/session_storage.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'features/shop/presentation/controllers/shop_controller.dart';
import 'features/products/presentation/controllers/product_controller.dart';
import 'features/categories/presentation/controllers/category_controller.dart';
import 'features/orders/presentation/controllers/order_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set Preferred Orientations (Phone & Tablet)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize Core Services & Feature Modules
  await ServiceLocator.initCoreServices();

  runApp(const VendorApp());
}

class VendorApp extends StatelessWidget {
  const VendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionStorage = locate<SessionStorage>();
    final authController = locate<AuthController>();
    final dashboardController = locate<DashboardController>();
    final shopController = locate<ShopController>();
    final productController = locate<ProductController>();
    final categoryController = locate<CategoryController>();
    final orderController = locate<OrderController>();

    final isDark = sessionStorage.isDarkMode();
    final isAuthenticated = authController.isAuthenticated;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>.value(value: authController),
        ChangeNotifierProvider<DashboardController>.value(value: dashboardController),
        ChangeNotifierProvider<ShopController>.value(value: shopController),
        ChangeNotifierProvider<ProductController>.value(value: productController),
        ChangeNotifierProvider<CategoryController>.value(value: categoryController),
        ChangeNotifierProvider<OrderController>.value(value: orderController),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.instance.navigatorKey,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        initialRoute: isAuthenticated ? AppRoutes.mainShell : AppRoutes.login,
        onGenerateRoute: AppRouter.generateRoute,
        builder: (context, child) {
          // Enforce Text Scale Bounds for Accessibility (ui-ux-pro-max)
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.of(context).textScaler.clamp(
                    minScaleFactor: 0.85,
                    maxScaleFactor: 1.30,
                  ),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
