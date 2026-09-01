import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../features/auth/presentation/views/splash_screen.dart';
import '../../features/auth/presentation/views/login_screen.dart';
import '../../features/auth/presentation/views/registration_screen.dart';
import '../../features/auth/presentation/views/otp_verification_screen.dart';
import '../../features/onboarding/presentation/views/welcome_screen.dart';
import '../../features/navigation/views/main_shell_screen.dart';
import '../../features/dashboard/presentation/views/analytics_screen.dart';
import '../../features/orders/presentation/views/order_details_screen.dart';
import '../../features/products/domain/models/product_model.dart';
import '../../features/products/presentation/views/add_edit_product_screen.dart';
import '../../features/profile/presentation/views/profile_screen.dart';
import '../../features/profile/presentation/views/edit_profile_screen.dart';
import '../../features/profile/presentation/views/shop_settings_screen.dart';
import '../../features/notifications/presentation/views/notification_center_screen.dart';
import '../../features/permissions/presentation/views/permissions_settings_screen.dart';
import '../../features/onboarding/presentation/views/onboarding_screen.dart';

// Central Route Generator with custom page transitions
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.initial:
      case AppRoutes.splash:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );

      case AppRoutes.welcome:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const WelcomeScreen(),
        );

      case AppRoutes.login:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );

      case AppRoutes.registration:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const RegistrationScreen(),
        );

      case AppRoutes.otpVerification:
        final phone = args is String ? args : '+1 (555) 123-4567';
        return _buildPageRoute(
          settings: settings,
          builder: (_) => OtpVerificationScreen(phoneNumber: phone),
        );

      case AppRoutes.onboarding:
        final isTourMode = args is bool ? args : false;
        return _buildPageRoute(
          settings: settings,
          builder: (_) => OnboardingScreen(isTourMode: isTourMode),
        );

      case AppRoutes.mainShell:
      case AppRoutes.dashboard:
        final initialTab = args is int ? args : 0;
        return _buildPageRoute(
          settings: settings,
          builder: (_) => MainShellScreen(initialIndex: initialTab),
        );

      case AppRoutes.analytics:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const AnalyticsScreen(),
        );

      case AppRoutes.orders:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const MainShellScreen(initialIndex: 1),
        );

      case AppRoutes.orderDetails:
        final orderId = args is String ? args : '';
        return _buildPageRoute(
          settings: settings,
          builder: (_) => OrderDetailsScreen(orderId: orderId),
        );

      case AppRoutes.products:
      case AppRoutes.categories:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const MainShellScreen(initialIndex: 2),
        );

      case AppRoutes.addProduct:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const AddEditProductScreen(),
        );

      case AppRoutes.editProduct:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => AddEditProductScreen(
            productToEdit: args is ProductModel ? args : null,
          ),
        );

      case AppRoutes.shopManagement:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const ShopSettingsScreen(),
        );

      case AppRoutes.notifications:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const NotificationCenterScreen(),
        );

      case AppRoutes.profile:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const ProfileScreen(),
        );

      case AppRoutes.editProfile:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const EditProfileScreen(),
        );

      case AppRoutes.settings:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const ProfileScreen(),
        );

      case AppRoutes.permissions:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const PermissionsSettingsScreen(),
        );

      default:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Smooth Fade & Slide Page Route Builder
  static PageRouteBuilder<T> _buildPageRoute<T>({
    required RouteSettings settings,
    required WidgetBuilder builder,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
    );
  }
}
