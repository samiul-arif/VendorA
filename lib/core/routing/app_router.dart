import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../features/auth/presentation/views/login_screen.dart';
import '../../features/navigation/views/main_shell_screen.dart';
import '../../features/products/domain/models/product_model.dart';
import '../../features/products/presentation/views/add_edit_product_screen.dart';

// Central Route Generator with custom page transitions
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.initial:
      case AppRoutes.splash:
      case AppRoutes.login:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );

      case AppRoutes.mainShell:
      case AppRoutes.dashboard:
        final initialTab = args is int ? args : 0;
        return _buildPageRoute(
          settings: settings,
          builder: (_) => MainShellScreen(initialIndex: initialTab),
        );

      case AppRoutes.orders:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const MainShellScreen(initialIndex: 1),
        );

      case AppRoutes.orderDetails:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => _PlaceholderScreen(title: 'Order Details', subtitle: 'Args: $args'),
        );

      case AppRoutes.products:
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

      case AppRoutes.categories:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const _PlaceholderScreen(title: 'Categories'),
        );

      case AppRoutes.shopManagement:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const MainShellScreen(initialIndex: 3),
        );

      case AppRoutes.notifications:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const _PlaceholderScreen(title: 'Notifications'),
        );

      case AppRoutes.profile:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const MainShellScreen(initialIndex: 4),
        );

      case AppRoutes.editProfile:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const _PlaceholderScreen(title: 'Edit Profile'),
        );

      case AppRoutes.settings:
        return _buildPageRoute(
          settings: settings,
          builder: (_) => const _PlaceholderScreen(title: 'Settings'),
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

// Temporary Scaffolding Placeholder Screen for Route Verification
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _PlaceholderScreen({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.storefront_outlined,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
