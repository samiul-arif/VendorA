import '../../../../core/network/base_mock_repository.dart';
import '../../../../core/storage/session_storage.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/onboarding_item_model.dart';
import '../../domain/repositories/onboarding_repository_interface.dart';

/// Repository Implementation for Onboarding with SharedPreferences Persistence
class MockOnboardingRepository extends BaseMockRepository implements IOnboardingRepository {
  final SessionStorage _sessionStorage;

  MockOnboardingRepository(this._sessionStorage);

  @override
  Future<Result<bool>> isOnboardingCompleted() async {
    return executeMock(
      operation: () async => _sessionStorage.isOnboardingCompleted(),
      customDelayMs: 40,
    );
  }

  @override
  Future<Result<void>> completeOnboarding() async {
    return executeMock(
      operation: () async {
        await _sessionStorage.setOnboardingCompleted(true);
      },
      customDelayMs: 60,
    );
  }

  @override
  Future<Result<void>> resetOnboarding() async {
    return executeMock(
      operation: () async {
        await _sessionStorage.setOnboardingCompleted(false);
      },
      customDelayMs: 40,
    );
  }

  @override
  Future<Result<List<OnboardingItemModel>>> getOnboardingSlides() async {
    return executeMock(
      operation: () async => OnboardingItemModel.defaultSlides,
      customDelayMs: 80,
    );
  }
}
