import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/navigation_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_page_item.dart';

/// Onboarding & Feature Showcase Screen (Phase K Implementation)
class OnboardingScreen extends StatefulWidget {
  final bool isTourMode;

  const OnboardingScreen({
    super.key,
    this.isTourMode = false,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingController>().resetTour();
    });
  }

  Future<void> _handleFinish() async {
    final controller = context.read<OnboardingController>();
    await controller.completeOnboarding();

    if (!mounted) return;

    if (widget.isTourMode) {
      Navigator.of(context).pop();
    } else {
      final authController = context.read<AuthController>();
      if (authController.isAuthenticated) {
        NavigationService.instance.clearStackAndNavigateTo(AppRoutes.mainShell);
      } else {
        NavigationService.instance.clearStackAndNavigateTo(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final controller = context.watch<OnboardingController>();
    final slides = controller.slides;
    final currentItem = slides.isNotEmpty && controller.currentPage < slides.length
        ? slides[controller.currentPage]
        : slides.first;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Brand Identifier + Skip / Close Action
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // App Brand Logo & Title
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.restaurant_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      AppSpacing.hGap10,
                      Text(
                        'Foodie Partner',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),

                  // Skip or Close Action Button
                  TextButton(
                    onPressed: _handleFinish,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      backgroundColor: colors.surfaceSubtle,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.full,
                      ),
                    ),
                    child: Text(
                      widget.isTourMode ? 'Close' : 'Skip',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Carousel PageView
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  return OnboardingPageItem(item: slides[index]);
                },
              ),
            ),

            // Bottom Navigation Controls
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(
                  top: BorderSide(color: colors.borderSubtle, width: 1.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Smooth Indicator Dots
                  OnboardingIndicator(
                    count: slides.length,
                    currentIndex: controller.currentPage,
                    activeColor: currentItem.accentColor,
                    onDotTapped: controller.goToPage,
                  ),

                  AppSpacing.vGap16,

                  // Action Buttons
                  Row(
                    children: [
                      if (!controller.isFirstPage) ...[
                        InkWell(
                          onTap: controller.previousPage,
                          borderRadius: AppRadius.full,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: colors.surfaceSubtle,
                              shape: BoxShape.circle,
                              border: Border.all(color: colors.borderSubtle),
                            ),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: colors.textPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                        AppSpacing.hGap12,
                      ],

                      // Primary Forward / Get Started Button
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (controller.isLastPage) {
                                _handleFinish();
                              } else {
                                controller.nextPage();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: currentItem.accentColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: const RoundedRectangleBorder(
                                borderRadius: AppRadius.full,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.isLastPage
                                      ? (widget.isTourMode ? 'Finish Tour' : 'Get Started as Merchant')
                                      : 'Next Feature',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  controller.isLastPage ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
