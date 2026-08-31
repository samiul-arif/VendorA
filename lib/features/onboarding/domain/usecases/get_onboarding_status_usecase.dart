import '../../../../core/utils/result.dart';
import '../repositories/onboarding_repository_interface.dart';

/// UseCase to query whether user has completed the onboarding flow
class GetOnboardingStatusUseCase {
  final IOnboardingRepository _repository;

  GetOnboardingStatusUseCase(this._repository);

  Future<Result<bool>> execute() async {
    return _repository.isOnboardingCompleted();
  }
}
