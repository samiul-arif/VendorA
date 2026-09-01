/// Core Application Constants
class AppConstants {
  AppConstants._();

  // App Metadata
  static const String appName = 'Vendor Partner';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Merchant & Store Management';

  // Currency & Locale
  static const String defaultCurrencySymbol = '৳';
  static const String defaultCurrencyCode = 'BDT';
  static const String defaultLocale = 'bn_BD';

  // Mock Network Latency Simulation (ms)
  static const int mockShortDelayMs = 400;
  static const int mockStandardDelayMs = 700;
  static const int mockLongDelayMs = 1200;

  // Pagination Defaults
  static const int defaultPageSize = 20;

  // Touch Target Minimums (ui-ux-pro-max standard)
  static const double minTouchTargetIOS = 44.0;
  static const double minTouchTargetAndroid = 48.0;

  // Responsive Breakpoints
  static const double mobileMaxBreakpoint = 600.0;
  static const double tabletMaxBreakpoint = 1024.0;

  // Animation Timing (ms)
  static const int fastAnimDurationMs = 150;
  static const int standardAnimDurationMs = 250;
  static const int exitAnimDurationMs = 180;
}
