import 'package:flutter/material.dart';
import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/onboarding_item_model.dart';
import '../../domain/usecases/get_onboarding_status_usecase.dart';
import '../../domain/usecases/complete_onboarding_usecase.dart';
import '../../domain/usecases/get_onboarding_slides_usecase.dart';

/// Presentation Controller managing Onboarding Carousel State & Navigation
class OnboardingController extends BaseController {
  final GetOnboardingStatusUseCase _getStatusUseCase;
  final CompleteOnboardingUseCase _completeUseCase;
  final GetOnboardingSlidesUseCase _getSlidesUseCase;

  PageController _pageController = PageController();
  PageController get pageController => _pageController;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  List<OnboardingItemModel> _slides = OnboardingItemModel.defaultSlides;
  List<OnboardingItemModel> get slides => _slides;

  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;

  bool get isLastPage => _currentPage == _slides.length - 1;
  bool get isFirstPage => _currentPage == 0;
  int get pageCount => _slides.length;

  OnboardingController({
    required GetOnboardingStatusUseCase getStatusUseCase,
    required CompleteOnboardingUseCase completeUseCase,
    required GetOnboardingSlidesUseCase getSlidesUseCase,
  })  : _getStatusUseCase = getStatusUseCase,
        _completeUseCase = completeUseCase,
        _getSlidesUseCase = getSlidesUseCase {
    loadOnboarding();
  }

  /// Initialize and load slides & completion status
  Future<void> loadOnboarding() async {
    setLoading();
    final statusResult = await _getStatusUseCase.execute();
    if (statusResult is Success<bool>) {
      _isCompleted = statusResult.data;
    }

    final slidesResult = await _getSlidesUseCase.execute();
    if (slidesResult is Success<List<OnboardingItemModel>>) {
      _slides = slidesResult.data;
    }
    setSuccess();
  }

  /// Reset page controller when re-opening from settings/profile tour
  void resetTour() {
    _currentPage = 0;
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    } else {
      _pageController = PageController(initialPage: 0);
    }
    notifyListeners();
  }

  /// Handle slide swipe from PageView
  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  /// Advance to next slide with smooth cubic curve
  void nextPage() {
    if (!isLastPage && _pageController.hasClients) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  /// Move to previous slide
  void previousPage() {
    if (!isFirstPage && _pageController.hasClients) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  /// Jump to a specific slide index directly
  void goToPage(int index) {
    if (index >= 0 && index < _slides.length && _pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  /// Complete onboarding & persist state
  Future<void> completeOnboarding() async {
    final result = await _completeUseCase.execute();
    if (result is Success<void>) {
      _isCompleted = true;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
