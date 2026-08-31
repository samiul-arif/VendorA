import '../utils/result.dart';
import 'mock_network_delay.dart';
import 'api_exceptions.dart';

/// Base Class for Mock Repositories providing common simulation helpers
abstract class BaseMockRepository {
  /// Executes a mock operation with simulated network delay and error handling
  Future<Result<T>> executeMock<T>({
    required Future<T> Function() operation,
    int? customDelayMs,
    double failureRate = 0.0,
    String? customErrorMessage,
  }) async {
    try {
      await MockNetworkDelay.simulate(customDelayMs);

      if (MockNetworkDelay.shouldFail(failureRate)) {
        return Failure(customErrorMessage ?? 'Network request failed unexpectedly.');
      }

      final result = await operation();
      return Success(result);
    } on AppException catch (e) {
      return Failure(e.message, exception: e);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
