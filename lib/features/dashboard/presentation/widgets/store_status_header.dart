import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/models/shop_model.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../../features/shop/presentation/controllers/shop_controller.dart';

// Top Store Header with Open/Closed Status Toggle & Multi-Shop Switcher
class StoreStatusHeader extends StatelessWidget {
  final VoidCallback onSwitchShopRequested;

  const StoreStatusHeader({
    super.key,
    required this.onSwitchShopRequested,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final authController = context.watch<AuthController>();
    final shopController = context.watch<ShopController>();

    final shop = shopController.currentShop ?? authController.activeShop;
    final isStoreOpen = shop?.isOpen ?? false;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Store Avatar / Icon
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF232A34) : Colors.white,
            borderRadius: AppRadius.md,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
            border: Border.all(
              color: isDark ? const Color(0xFF2D3748) : const Color(0xFFF3F4F6),
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.storefront_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ),

        AppSpacing.hGap12,

        // Store Name & Multi-Shop Selector
        Expanded(
          child: GestureDetector(
            onTap: onSwitchShopRequested,
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Store Manager',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ],
                ),
                Text(
                  shop?.name ?? 'Foodie Hub Express',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),

        AppSpacing.hGap8,

        // Store Open/Close Toggle Pill (Instant Visual Feedback)
        GestureDetector(
          onTap: () {
            shopController.toggleStoreStatus(!isStoreOpen);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: isStoreOpen
                  ? (isDark ? const Color(0xFF0F3A2E) : AppColors.statusSuccessBg)
                  : (isDark ? const Color(0xFF3B1414) : AppColors.statusErrorBg),
              borderRadius: AppRadius.full,
              border: Border.all(
                color: isStoreOpen ? AppColors.statusSuccess : AppColors.statusError,
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isStoreOpen ? AppColors.statusSuccess : AppColors.statusError,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isStoreOpen ? 'Open' : 'Closed',
                  style: AppTypography.labelMedium.copyWith(
                    color: isStoreOpen ? AppColors.statusSuccess : AppColors.statusError,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
