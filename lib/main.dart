import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/routing/navigation_service.dart';
import 'core/di/service_locator.dart';
import 'core/storage/session_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set Preferred Orientations (Phone & Tablet)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize Core Services (Storage, Session, Routing)
  await ServiceLocator.initCoreServices();

  runApp(const VendorApp());
}

class VendorApp extends StatelessWidget {
  const VendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionStorage = locate<SessionStorage>();
    final isDark = sessionStorage.isDarkMode();
    final isAuthenticated = sessionStorage.isAuthenticated;

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.instance.navigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: isAuthenticated ? AppRoutes.dashboard : AppRoutes.login,
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
    );
  }
}
