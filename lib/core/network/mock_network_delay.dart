import 'dart:math';
import '../constants/app_constants.dart';

/// Network Simulation Helper for Mock Repositories
class MockNetworkDelay {
  MockNetworkDelay._();

  static final Random _random = Random();

  /// Simulates realistic network delay
  static Future<void> simulate([int? customDelayMs]) async {
    final delay = customDelayMs ??
        (AppConstants.mockShortDelayMs +
            _random.nextInt(AppConstants.mockStandardDelayMs - AppConstants.mockShortDelayMs));
    await Future.delayed(Duration(milliseconds: delay));
  }

  /// Simulates optional failure based on probability (0.0 to 1.0)
  static bool shouldFail([double failureRate = 0.0]) {
    if (failureRate <= 0.0) return false;
    return _random.nextDouble() < failureRate;
  }
}
