import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/navigation_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Pixel-Perfect Welcome Screen strictly adhering to the centralized design system
/// (`stitch_merchant_hub_app_brief/welcome_screen/code.html`)
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _onGetStarted(BuildContext context) {
    NavigationService.instance.navigateTo(AppRoutes.onboarding);
  }

  void _onSkip(BuildContext context) {
    NavigationService.instance.clearStackAndNavigateTo(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final size = MediaQuery.of(context).size;
    final isDark = context.isDark;
    final topHeroHeight = (size.height * 0.52).clamp(340.0, 480.0);

    return Scaffold(
      backgroundColor: colors.canvas,
      body: Stack(
        children: [
          // 1. Top Gradient Hero Background (Primary to Light Accent Gradient with Hero Bottom Curvature)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topHeroHeight,
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: AppRadius.heroBottom,
                boxShadow: AppShadows.heroGlow,
              ),
              child: Stack(
                children: [
                  // Subtle ambient grid pattern overlay
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _DotPatternPainter(
                        dotColor: colors.textInverse.withValues(alpha: 0.12),
                      ),
                    ),
                  ),

                  // Centered Frosted Glass Icon Card
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.massive),
                      child: ClipRRect(
                        borderRadius: AppRadius.lg,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: colors.textInverse.withValues(alpha: 0.15),
                              borderRadius: AppRadius.lg,
                              border: Border.all(
                                color: colors.textInverse.withValues(alpha: 0.25),
                                width: 1.5,
                              ),
                              boxShadow: AppShadows.frostedGlass,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.storefront_rounded,
                                size: 84,
                                color: colors.textInverse,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Safe Area Top Navigation Bar (Branding & Skip Pill)
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Identity: Shopping bag + Merchant text
                    Row(
                      children: [
                        Icon(
                          Icons.shopping_bag_rounded,
                          color: colors.textInverse,
                          size: 26,
                        ),
                        AppSpacing.hGap8,
                        Text(
                          'Merchant',
                          style: AppTypography.headlineSmall.copyWith(
                            color: colors.textInverse,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),

                    // Top Right "Skip" Pill Action
                    InkWell(
                      onTap: () => _onSkip(context),
                      borderRadius: AppRadius.full,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: colors.textInverse.withValues(alpha: 0.20),
                          borderRadius: AppRadius.full,
                          border: Border.all(
                            color: colors.textInverse.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Skip',
                          style: AppTypography.labelSmall.copyWith(
                            color: colors.textInverse,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Scrollable Content Body with Floating Welcome Card
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: Column(
                children: [
                  // Space offset matching top hero graphic
                  SizedBox(height: topHeroHeight - 110),

                  // Floating Welcome Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: AppRadius.lg,
                      border: Border.all(
                        color: colors.borderSubtle,
                        width: 1,
                      ),
                      boxShadow: isDark ? AppShadows.darkCard : AppShadows.stitchCard,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Headline
                        Text(
                          'Run your shop, your way.',
                          style: AppTypography.headlineMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                            fontSize: 24,
                            letterSpacing: -0.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.vGap6,

                        // Subtitle
                        Text(
                          'Everything your shop needs, in one app.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.vGap20,

                        // Feature Strip 1: Manage products
                        _buildFeatureStrip(
                          context: context,
                          icon: Icons.inventory_2_rounded,
                          iconColor: colors.primary,
                          iconBgColor: colors.primary.withValues(alpha: 0.12),
                          title: 'Manage products in seconds',
                          colors: colors,
                        ),
                        AppSpacing.vGap10,

                        // Feature Strip 2: Track orders & earnings
                        _buildFeatureStrip(
                          context: context,
                          icon: Icons.insights_rounded,
                          iconColor: colors.secondary,
                          iconBgColor: colors.secondaryContainer.withValues(alpha: 0.25),
                          title: 'Track orders & earnings in real time',
                          colors: colors,
                        ),
                        AppSpacing.vGap10,

                        // Feature Strip 3: Never miss an order
                        _buildFeatureStrip(
                          context: context,
                          icon: Icons.notifications_active_rounded,
                          iconColor: colors.error,
                          iconBgColor: colors.errorBg,
                          title: 'Never miss a new order',
                          colors: colors,
                        ),
                        AppSpacing.vGap24,

                        // Solid CTA Button: "Get Started"
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () => _onGetStarted(context),
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
                                color: colors.ctaPrimaryText,
                                fontWeight: FontWeight.w700,
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
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureStrip({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required AppSemanticColors colors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: colors.borderSubtle.withValues(alpha: 0.6),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          AppSpacing.hGap14,
          Expanded(
            child: Text(
              title,
              style: AppTypography.titleSmall.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ambient dotted background texture painter
class _DotPatternPainter extends CustomPainter {
  final Color dotColor;

  _DotPatternPainter({required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    const spacing = 24.0;
    const dotRadius = 1.2;

    for (double x = 12; x < size.width; x += spacing) {
      for (double y = 12; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotPatternPainter oldDelegate) =>
      oldDelegate.dotColor != dotColor;
}
