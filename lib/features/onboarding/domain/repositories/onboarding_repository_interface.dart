import '../../../../core/utils/result.dart';
import '../models/onboarding_item_model.dart';

/// Contract for Onboarding & Feature Showcase Repository
abstract class IOnboardingRepository {
  /// Checks whether the merchant has completed or dismissed the onboarding showcase
  Future<Result<bool>> isOnboardingCompleted();

  /// Marks the onboarding tour as completed in persistent storage
  Future<Result<void>> completeOnboarding();

  /// Resets onboarding status (e.g. for testing or replaying the tour from profile)
  Future<Result<void>> resetOnboarding();

  /// Retrieves the list of feature slides
  Future<Result<List<OnboardingItemModel>>> getOnboardingSlides();
}
