import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/onboarding_item_model.dart';

/// Distinctive visual mockup illustration rendered inside each onboarding slide
class OnboardingMockPreview extends StatelessWidget {
  final OnboardingItemModel item;

  const OnboardingMockPreview({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colors.borderSubtle, width: 1.2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            item.accentColor.withValues(alpha: isDark ? 0.18 : 0.08),
            colors.surface,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background subtle concentric glow rings
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.accentColor.withValues(alpha: 0.1),
              ),
            ),
          ),

          // Core Mockup Content according to preview type
          Padding(
            padding: const EdgeInsets.all(20),
            child: _buildPreviewContent(context, colors),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent(BuildContext context, AppSemanticColors colors) {
    switch (item.previewType) {
      case OnboardingPreviewType.orderDispatch:
        return _buildOrderDispatchMock(context, colors);
      case OnboardingPreviewType.menuInventory:
        return _buildMenuInventoryMock(context, colors);
      case OnboardingPreviewType.revenuePayouts:
        return _buildRevenuePayoutsMock(context, colors);
      case OnboardingPreviewType.storeManagement:
        return _buildStoreManagementMock(context, colors);
    }
  }

  // Slide 1: Live Order Dispatch Mockup
  Widget _buildOrderDispatchMock(BuildContext context, AppSemanticColors colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Floating Alert Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFD70F64),
            borderRadius: AppRadius.full,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD70F64).withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_active_rounded, color: Colors.white, size: 14),
              SizedBox(width: 6),
              Text(
                'NEW LIVE ORDER  •  02:45',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),

        AppSpacing.vGap12,

        // Order Mini Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.surfaceSubtle,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#ORD-4821',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: colors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.successBg,
                      borderRadius: AppRadius.full,
                    ),
                    child: Text(
                      'Delivery',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: colors.success,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.restaurant_rounded, size: 14, color: colors.textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '2x Truffle Burger, 1x Fries, 1x Coke',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '৳34.50',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        AppSpacing.vGap12,

        // Accept Action Bar Preview
        Row(
          children: [
            Expanded(
              child: Container(
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFD70F64),
                  borderRadius: AppRadius.full,
                ),
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Accept & Start Prep',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Slide 2: Menu & Stock Management Mockup
  Widget _buildMenuInventoryMock(BuildContext context, AppSemanticColors colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.surfaceSubtle,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Row(
            children: [
              // Dish Thumbnail Mock
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lunch_dining_rounded,
                  color: Color(0xFFF59E0B),
                  size: 28,
                ),
              ),
              AppSpacing.hGap12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gourmet Truffle Burger',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '৳14.50  •  Stock: 18 left',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: colors.successBg,
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  'IN STOCK',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    color: colors.success,
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSpacing.vGap12,
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt_rounded, size: 15, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 6),
                    Text(
                      'Photo Upload',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.hGap10,
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pause_circle_outline_rounded, size: 15, color: colors.error),
                    const SizedBox(width: 6),
                    Text(
                      'Stock Out Item',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: colors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Slide 3: Revenue & Payouts Mockup
  Widget _buildRevenuePayoutsMock(BuildContext context, AppSemanticColors colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Net Revenue',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '৳1,842.50',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF10B981),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                borderRadius: AppRadius.full,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_upward_rounded, size: 13, color: Color(0xFF10B981)),
                  SizedBox(width: 3),
                  Text(
                    '+18.4%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        AppSpacing.vGap16,
        // Mock Mini Bar Chart
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildBar(height: 28, label: '10 AM', active: false, colors: colors),
            _buildBar(height: 48, label: '12 PM', active: false, colors: colors),
            _buildBar(height: 72, label: '02 PM', active: true, colors: colors),
            _buildBar(height: 38, label: '04 PM', active: false, colors: colors),
            _buildBar(height: 64, label: '06 PM', active: false, colors: colors),
            _buildBar(height: 80, label: '08 PM', active: true, colors: colors),
          ],
        ),
      ],
    );
  }

  Widget _buildBar({
    required double height,
    required String label,
    required bool active,
    required AppSemanticColors colors,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: height,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF10B981) : const Color(0xFF10B981).withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 8.5, color: colors.textMuted, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // Slide 4: Multi-Store & Preference Controls Mockup
  Widget _buildStoreManagementMock(BuildContext context, AppSemanticColors colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.surfaceSubtle,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: Color(0xFF6366F1),
                  size: 22,
                ),
              ),
              AppSpacing.hGap12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Foodie Hub Express',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '2 Active Outlets  •  Downtown',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: colors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: colors.successBg,
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  'OPEN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: colors.success,
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSpacing.vGap12,
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Row(
                  children: [
                    Icon(Icons.palette_outlined, size: 15, color: colors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      'Dark / Light',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colors.textPrimary),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.hGap8,
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.support_agent_rounded, size: 15, color: Color(0xFF6366F1)),
                    const SizedBox(width: 6),
                    Text(
                      'Partner Help',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colors.textPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
