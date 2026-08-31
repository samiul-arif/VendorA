import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/navigation_service.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../../features/onboarding/presentation/controllers/onboarding_controller.dart';

/// Landing / Splash Screen matching Stitch design brief (`splash_screen/code.html`)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    // Entry Fade & Slide-Up Animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_fadeAnimation);

    // Pulse Animation for the 3 loading dots
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _fadeController.forward();

    // Dispatch initial route check after splash hold
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    final authController = context.read<AuthController>();
    final onboardingController = context.read<OnboardingController>();

    if (authController.isAuthenticated) {
      NavigationService.instance.clearStackAndNavigateTo(AppRoutes.mainShell);
    } else if (!onboardingController.isCompleted) {
      NavigationService.instance.clearStackAndNavigateTo(AppRoutes.welcome);
    } else {
      NavigationService.instance.clearStackAndNavigateTo(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing Brand Icon Container (96x96, rounded-2xl, bg-primary-container)
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF15171C).withValues(alpha: 0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: colors.primaryContainer.withValues(alpha: 0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.local_dining_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),

                AppSpacing.vGap24,

                // Headline: "Lumina Vendor"
                Text(
                  'Lumina Vendor',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: colors.primary,
                  ),
                ),

                const SizedBox(height: 32),

                // 3 Pulsing Animated Indicator Dots
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final delay = index * 0.25;
                        final t = (_pulseController.value - delay) % 1.0;
                        final scale = 0.6 + (0.4 * (1.0 - (2 * (t - 0.5)).abs()));
                        final opacity = 0.3 + (0.7 * (1.0 - (2 * (t - 0.5)).abs()));

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8 * scale,
                          height: 8 * scale,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.primary.withValues(alpha: opacity.clamp(0.2, 1.0)),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
