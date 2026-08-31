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

import '../../../../core/routing/app_routes.dart';

// Top Store Header with Open/Closed Status Toggle, Notification Bell & Shop Switcher
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
    final notifController = context.watch<NotificationController>();

    final shop = shopController.currentShop ?? authController.activeShop;
    final isStoreOpen = shop?.isOpen ?? true;
    final unreadCount = notifController.unreadCount;

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

        // Right Actions: Notification Bell + Store Open/Close Toggle Pill
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Notification Bell Icon Button (Left of Open/Close)
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.notifications);
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E242C) : Colors.white,
                  borderRadius: AppRadius.full,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      unreadCount > 0 ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                      size: 19,
                      color: unreadCount > 0
                          ? AppColors.primary
                          : (isDark ? AppColors.textSecondaryDark : const Color(0xFF4B5563)),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        top: 7,
                        right: 7,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? const Color(0xFF1E242C) : Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Store Open/Close Toggle Pill
            GestureDetector(
              onTap: () {
                final nextStatus = !isStoreOpen;
                shopController.toggleStoreStatus(nextStatus, authController: authController);
                final notif = context.read<NotificationController>();

                if (nextStatus) {
                  notif.dispatchNotification(
                    context,
                    title: 'Shop Opened',
                    message: 'Your kitchen is now accepting incoming orders.',
                    type: NotificationType.system,
                    toastVariant: AppToastVariant.success,
                  );
                } else {
                  notif.dispatchNotification(
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
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
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
                    const SizedBox(width: 5),
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
        ),
      ],
    );
  }
}
