import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/vendor_model.dart';

/// Profile Header Card matching Stitch brief with Name, Phone, Address, Image & Stats
class ProfileHeaderCard extends StatelessWidget {
  final VendorModel? vendor;
  final VoidCallback? onEditTapped;

  const ProfileHeaderCard({
    super.key,
    required this.vendor,
    this.onEditTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDark;

    final displayName = vendor?.name ?? 'Alex Johnson';
    final phone = (vendor != null && vendor!.phoneNumber.isNotEmpty)
        ? vendor!.phoneNumber
        : '+880 1712 345678';
    final address = (vendor != null && vendor!.businessName.isNotEmpty)
        ? vendor!.businessName
        : 'House 42, Road 27, Dhanmondi, Dhaka';
    final avatarUrl = vendor?.profileImageUrl;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: colors.borderSubtle),
        boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
      ),
      child: Column(
        children: [
          // 1. Avatar (Clean circular image / initial badge, no floating edit icon)
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary.withValues(alpha: 0.12),
              border: Border.all(color: colors.surface, width: 4),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF15171C).withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: avatarUrl != null && avatarUrl.isNotEmpty
                  ? Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildInitials(displayName, colors),
                    )
                  : _buildInitials(displayName, colors),
            ),
          ),

          AppSpacing.vGap12,

          // 2. Merchant Full Name
          Text(
            displayName,
            style: AppTypography.headlineMedium.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: colors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),

          AppSpacing.vGap6,

          // 3. Role Pill (Emerald Green Chip matching Stitch HTML)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colors.secondaryContainer.withValues(alpha: 0.25),
              borderRadius: AppRadius.full,
            ),
            child: Text(
              'OWNER',
              style: AppTypography.labelSmall.copyWith(
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                color: colors.secondary,
                letterSpacing: 0.6,
              ),
            ),
          ),

          AppSpacing.vGap12,

          // 4. Contact & Address Details
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.surfaceLow,
              borderRadius: AppRadius.md,
              border: Border.all(color: colors.borderSubtle.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                // Phone Number Row
                Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 15,
                      color: colors.primary,
                    ),
                    AppSpacing.hGap8,
                    Expanded(
                      child: Text(
                        phone,
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                AppSpacing.vGap8,
                Divider(height: 1, color: colors.divider.withValues(alpha: 0.6)),
                AppSpacing.vGap8,
                // Business Address Row
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: colors.secondary,
                    ),
                    AppSpacing.hGap8,
                    Expanded(
                      child: Text(
                        address,
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          AppSpacing.vGap16,

          // Divider
          Divider(color: colors.divider, height: 1),

          AppSpacing.vGap14,

          // 5. Two Stat Columns: Active Items (142) & Store Rating (4.8 ★)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '142',
                    style: AppTypography.titleLarge.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: colors.textPrimary,
                    ),
                  ),
                  AppSpacing.vGap2,
                  Text(
                    'Active Items',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 12,
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                height: 28,
                width: 1,
                color: colors.borderSubtle,
              ),
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 3),
                      Text(
                        '4.8',
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vGap2,
                  Text(
                    'Store Rating',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 12,
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInitials(String displayName, AppSemanticColors colors) {
    return Center(
      child: Text(
        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'A',
        style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w900,
          color: colors.primary,
        ),
      ),
    );
  }
}
