import '../../../../core/utils/result.dart';
import '../repositories/onboarding_repository_interface.dart';

/// UseCase to mark onboarding tour as finished
class CompleteOnboardingUseCase {
  final IOnboardingRepository _repository;

  CompleteOnboardingUseCase(this._repository);

  Future<Result<void>> execute() async {
    return _repository.completeOnboarding();
  }
}
