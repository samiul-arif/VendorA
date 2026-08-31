/// Local Storage & SharedPreferences Keys
class StorageKeys {
  StorageKeys._();

  static const String authToken = 'vendor_auth_token';
  static const String refreshToken = 'vendor_refresh_token';
  static const String currentVendor = 'vendor_current_user';
  static const String currentShop = 'vendor_current_shop';
  static const String userSession = 'vendor_user_session';
  static const String isDarkMode = 'vendor_pref_dark_mode';
  static const String selectedLanguage = 'vendor_pref_language';
  static const String orderAlertSoundEnabled = 'vendor_pref_order_sound';
  static const String pushNotificationsEnabled = 'vendor_pref_push_notifications';
  static const String autoAcceptOrders = 'vendor_pref_auto_accept_orders';
  static const String onboardingCompleted = 'vendor_pref_onboarding_completed';
}
