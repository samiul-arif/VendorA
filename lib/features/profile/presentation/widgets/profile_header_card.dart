import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../shared/models/vendor_model.dart';

/// Profile Header Card matching Stitch brief (`vendor_profile_with_account_settings_link/code.html`)
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

    final displayName = vendor?.name ?? 'Alex Johnson';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF15171C).withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular Avatar (Clean, no floating edit badge)
          Container(
            width: 88,
            height: 88,
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
            child: Center(
              child: Text(
                displayName.isNotEmpty ? displayName[0].toUpperCase() : 'A',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: colors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Merchant Full Name
          Text(
            displayName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: colors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 6),

          // Owner Role Pill (Emerald Green Chip)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF75F9D6).withValues(alpha: 0.3),
              borderRadius: AppRadius.full,
            ),
            child: const Text(
              'OWNER',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                color: Color(0xFF006B57),
                letterSpacing: 0.6,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Divider
          Divider(color: colors.borderSubtle, height: 1),

          const SizedBox(height: 16),

          // Two Stat Columns: Active Items (142) & Store Rating (4.8 ★)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '142',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Active Items',
                    style: TextStyle(
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Store Rating',
                    style: TextStyle(
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
}
