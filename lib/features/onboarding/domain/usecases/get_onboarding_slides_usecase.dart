import '../../../../core/utils/result.dart';
import '../models/onboarding_item_model.dart';
import '../repositories/onboarding_repository_interface.dart';

/// UseCase to retrieve onboarding feature showcase slides
class GetOnboardingSlidesUseCase {
  final IOnboardingRepository _repository;

  GetOnboardingSlidesUseCase(this._repository);

  Future<Result<List<OnboardingItemModel>>> execute() async {
    return _repository.getOnboardingSlides();
  }
}
