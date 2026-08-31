import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../../features/shop/presentation/controllers/shop_controller.dart';
import '../../../../features/notifications/presentation/controllers/notification_controller.dart';
import '../../../../features/notifications/domain/models/notification_type.dart';
import '../../../../shared/components/app_toast.dart';

// Top Store Header with Open/Closed Status Toggle & Shop Switcher (Screenshot 4 Matching)
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
    final isStoreOpen = shop?.isOpen ?? true;

    // Display clean name without brackets if present for header
    final rawName = shop?.name ?? 'Foodie Hub Express';
    final cleanName = rawName.contains('(') ? rawName.split('(').first.trim() : rawName;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Store Manager & Shop Name with tap to switch
        GestureDetector(
          onTap: onSwitchShopRequested,
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Store Manager',
                style: AppTypography.labelSmall.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cleanName,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: isDark ? AppColors.textMutedDark : const Color(0xFF9CA3AF),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Store Open/Close Toggle Pill Matching Screenshot 4 (Green #ECFDF5 with #10B981 dot)
        GestureDetector(
          onTap: () {
            final nextStatus = !isStoreOpen;
            shopController.toggleStoreStatus(nextStatus);
            final notifController = context.read<NotificationController>();

            if (nextStatus) {
              notifController.dispatchNotification(
                context,
                title: 'Shop Opened',
                message: 'Your kitchen is now accepting incoming orders.',
                type: NotificationType.system,
                toastVariant: AppToastVariant.success,
              );
            } else {
              notifController.dispatchNotification(
                context,
                title: 'Shop Closed / Paused',
                message: 'Store marked offline. Incoming orders are paused.',
                type: NotificationType.system,
                toastVariant: AppToastVariant.warning,
              );
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isStoreOpen
                  ? (isDark ? const Color(0xFF0F3A2E) : const Color(0xFFECFDF5))
                  : (isDark ? const Color(0xFF3B1414) : const Color(0xFFFEF2F2)),
              borderRadius: AppRadius.full,
              border: Border.all(
                color: isStoreOpen ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: isStoreOpen ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isStoreOpen ? 'Open' : 'Closed',
                  style: TextStyle(
                    color: isStoreOpen ? const Color(0xFF059669) : const Color(0xFFDC2626),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
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
