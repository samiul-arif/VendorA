import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/onboarding_item_model.dart';
import 'onboarding_mock_preview.dart';

/// Single Page Item for Onboarding Carousel
class OnboardingPageItem extends StatelessWidget {
  final OnboardingItemModel item;

  const OnboardingPageItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visual Mockup Preview
          OnboardingMockPreview(item: item),

          AppSpacing.vGap24,

          // Category Badge Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: item.accentColor.withValues(alpha: 0.12),
              borderRadius: AppRadius.full,
              border: Border.all(
                color: item.accentColor.withValues(alpha: 0.25),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: 13, color: item.accentColor),
                const SizedBox(width: 6),
                Text(
                  item.categoryTag,
                  style: TextStyle(
                    color: item.accentColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),

          AppSpacing.vGap12,

          // Title
          Text(
            item.title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
              color: colors.textPrimary,
              height: 1.25,
            ),
          ),

          AppSpacing.vGap10,

          // Subtitle
          Text(
            item.subtitle,
            style: TextStyle(
              fontSize: 13.5,
              color: colors.textSecondary,
              height: 1.45,
            ),
          ),

          AppSpacing.vGap20,

          // Key Benefits List
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surfaceSubtle,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.borderSubtle, width: 1.0),
            ),
            child: Column(
              children: item.keyBenefits.map((benefit) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: item.accentColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                      AppSpacing.hGap10,
                      Expanded(
                        child: Text(
                          benefit,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
