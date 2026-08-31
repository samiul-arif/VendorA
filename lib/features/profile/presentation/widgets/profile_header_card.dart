import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/models/vendor_model.dart';
import '../../../../shared/models/shop_model.dart';

// Profile Header Card with Avatar & Verified Partner Badge
class ProfileHeaderCard extends StatelessWidget {
  final VendorModel? vendor;
  final ShopModel? activeShop;
  final VoidCallback onEditTapped;

  const ProfileHeaderCard({
    super.key,
    required this.vendor,
    required this.activeShop,
    required this.onEditTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final displayName = vendor?.name ?? 'Samiul Arif';
    final businessName = vendor?.businessName ?? 'Arif Food Enterprises LLC';
    final shopName = activeShop?.name ?? 'Foodie Hub Express';
    final phone = activeShop?.phone ?? '+1 (555) 234-5678';

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar with Foodie Pink Ring
              Stack(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.primary, width: 2),
                      color: colors.primaryContainer,
                    ),
                    child: Center(
                      child: Text(
                        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'V',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: colors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              AppSpacing.hGap16,

              // Name, Business & Store Phone with Generous Spacing
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            displayName,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.verified_rounded,
                          size: 18,
                          color: colors.primary,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      businessName,
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: colors.textMuted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          phone,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Edit Action
              IconButton(
                icon: Icon(Icons.edit_outlined, size: 20, color: colors.textSecondary),
                onPressed: onEditTapped,
                tooltip: 'Edit Profile',
              ),
            ],
          ),

          AppSpacing.vGap16,

          // Active Store Banner (Clean banner without Operational tag)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: colors.surfaceSubtle,
              borderRadius: AppRadius.md,
              border: Border.all(
                color: colors.borderSubtle,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.storefront_rounded,
                  size: 18,
                  color: colors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Active: $shopName',
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
