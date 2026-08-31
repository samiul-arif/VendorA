import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';

/// Smooth Animated Capsule & Dot Page Indicator
class OnboardingIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color activeColor;
  final ValueChanged<int>? onDotTapped;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.activeColor,
    this.onDotTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;

        return GestureDetector(
          onTap: () => onDotTapped?.call(index),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: isActive ? 28 : 8,
            decoration: BoxDecoration(
              color: isActive ? activeColor : colors.borderSubtle,
              borderRadius: AppRadius.full,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
