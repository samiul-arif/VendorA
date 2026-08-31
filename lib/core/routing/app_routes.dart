/// Named Route Definitions for Vendor App
class AppRoutes {
  AppRoutes._();

  // Root & Splash
  static const String initial = '/';
  static const String splash = '/splash';

  // Authentication Flow
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';

  // Main Shell & Dashboard
  static const String mainShell = '/main';
  static const String dashboard = '/dashboard';

  // Orders Flow
  static const String orders = '/orders';
  static const String orderDetails = '/orders/details';

  // Products Flow
  static const String products = '/products';
  static const String addProduct = '/products/add';
  static const String editProduct = '/products/edit';
  static const String productDetails = '/products/details';

  // Categories Flow
  static const String categories = '/categories';
  static const String addCategory = '/categories/add';
  static const String editCategory = '/categories/edit';

  // Shop Management
  static const String shopManagement = '/shop';
  static const String editShopInfo = '/shop/edit';

  // Notifications Flow
  static const String notifications = '/notifications';
  static const String notificationDetails = '/notifications/details';

  // Profile & Settings Flow
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String accountSettings = '/settings/account';
  static const String notificationPreferences = '/settings/notifications';
  static const String languageSettings = '/settings/language';
  static const String privacySettings = '/settings/privacy';
  static const String permissions = '/settings/permissions';
}
