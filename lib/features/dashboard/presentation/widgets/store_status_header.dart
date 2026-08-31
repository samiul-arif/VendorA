import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
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
    final colors = context.appColors;
    final isDark = context.isDark;

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
                  color: colors.textSecondary,
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
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: colors.textMuted,
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
                  color: colors.surface,
                  borderRadius: AppRadius.full,
                  border: Border.all(
                    color: colors.borderSubtle,
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
                          ? colors.primary
                          : colors.textSecondary,
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        top: 7,
                        right: 7,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.surface,
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
                      ? colors.successBg
                      : colors.errorBg,
                  borderRadius: AppRadius.full,
                  border: Border.all(
                    color: isStoreOpen
                        ? colors.success.withValues(alpha: 0.3)
                        : colors.error.withValues(alpha: 0.3),
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
                        color: isStoreOpen ? colors.success : colors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isStoreOpen ? 'Open' : 'Closed',
                      style: TextStyle(
                        color: isStoreOpen ? colors.success : colors.error,
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
