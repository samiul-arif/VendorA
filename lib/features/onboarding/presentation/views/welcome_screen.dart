import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/navigation_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../controllers/onboarding_controller.dart';

/// Welcome Screen matching Stitch brief (`welcome_screen/code.html`)
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _onSkipOrGetStarted(BuildContext context) async {
    final onboardingController = context.read<OnboardingController>();
    await onboardingController.completeOnboarding();

    NavigationService.instance.clearStackAndNavigateTo(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final size = MediaQuery.of(context).size;
    final heroHeight = (size.height * 0.48).clamp(320.0, 440.0);

    return Scaffold(
      backgroundColor: colors.surface,
      body: Stack(
        children: [
          // 1. Gradient Hero Background with Rounded Bottom Curvature
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: heroHeight,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE21B70), // primary-container
                    Color(0xFFFF5E9E), // gradient accent
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33E21B70),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                // Center Frosted Glass Graphic
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.storefront_rounded,
                          size: 96,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Safe Area Content Layer
          SafeArea(
            child: Column(
              children: [
                // Top Header Actions: Brand & Skip Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Brand Identity
                      const Row(
                        children: [
                          Icon(
                            Icons.shopping_bag_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Merchant',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),

                      // Skip Pill Button
                      GestureDetector(
                        onTap: () => _onSkipOrGetStarted(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: AppRadius.full,
                          ),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // 3. Floating Welcome Card
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colors.borderSubtle),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF15171C).withValues(alpha: 0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Headline & Subtitle
                      Text(
                        'Run your shop, your way.',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                          letterSpacing: -0.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Everything your shop needs, in one app.',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      AppSpacing.vGap16,

                      // Feature Strips
                      _buildFeatureStrip(
                        icon: Icons.inventory_2_rounded,
                        iconColor: colors.primary,
                        bgColor: colors.primaryContainer.withValues(alpha: 0.12),
                        title: 'Manage products in seconds',
                        colors: colors,
                      ),
                      const SizedBox(height: 8),
                      _buildFeatureStrip(
                        icon: Icons.insights_rounded,
                        iconColor: const Color(0xFF006B57), // secondary
                        bgColor: const Color(0xFF75F9D6).withValues(alpha: 0.25),
                        title: 'Track orders & earnings in real time',
                        colors: colors,
                      ),
                      const SizedBox(height: 8),
                      _buildFeatureStrip(
                        icon: Icons.notifications_active_rounded,
                        iconColor: const Color(0xFFBA1A1A), // error
                        bgColor: const Color(0xFFFFDAD6).withValues(alpha: 0.5),
                        title: 'Never miss a new order',
                        colors: colors,
                      ),

                      AppSpacing.vGap20,

                      // Solid Black Pill CTA: "Get Started"
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _onSkipOrGetStarted(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.ctaPrimary,
                            foregroundColor: colors.ctaPrimaryText,
                            elevation: 2,
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadius.full,
                            ),
                          ),
                          child: Text(
                            'Get Started',
                            style: AppTypography.labelLarge.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: colors.ctaPrimaryText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureStrip({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required AppSemanticColors colors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceSubtle,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.borderSubtle.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          AppSpacing.hGap14,
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
