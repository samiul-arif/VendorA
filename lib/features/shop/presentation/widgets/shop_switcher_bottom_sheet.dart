import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../../features/shop/presentation/controllers/shop_controller.dart';
import '../../../../features/dashboard/presentation/controllers/dashboard_controller.dart';
import '../../../../features/orders/presentation/controllers/order_controller.dart';
import '../../../../features/notifications/presentation/controllers/notification_controller.dart';
import '../../../../features/notifications/domain/models/notification_type.dart';
import '../../../../shared/components/app_toast.dart';

/// Shop Switcher Bottom Sheet Modal matching Stitch brief (`shop_management_with_shop_switcher_modal/code.html`)
class ShopSwitcherBottomSheet extends StatelessWidget {
  const ShopSwitcherBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ShopSwitcherBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final authController = context.watch<AuthController>();
    final shopController = context.watch<ShopController>();

    final availableShops = authController.availableShops;
    final activeShopId = shopController.currentShop?.id ?? authController.activeShop?.id ?? 'shop_01';

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          AppSpacing.vGap16,

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Switch Store Branch',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Select a store from your merchant portfolio',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
                color: colors.textMuted,
              ),
            ],
          ),

          AppSpacing.vGap16,

          // List of Store Branches
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: availableShops.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final shop = availableShops[index];
                final isSelected = shop.id == activeShopId;

                return GestureDetector(
                  onTap: () async {
                    if (isSelected) {
                      Navigator.of(context).pop();
                      return;
                    }

                    final result = await authController.switchShop(shop.id);
                    if (!context.mounted) return;

                    result.when(
                      success: (session) {
                        if (session.activeShop != null) {
                          shopController.setActiveShop(session.activeShop!);
                          context.read<DashboardController>().loadDashboard(shopId: session.activeShop!.id);
                          context.read<OrderController>().loadOrders(shopId: session.activeShop!.id);
                        }

                        Navigator.of(context).pop();

                        context.read<NotificationController>().dispatchNotification(
                          context,
                          title: 'Store Switched',
                          message: 'Now managing "${session.activeShop?.name ?? shop.name}".',
                          type: NotificationType.system,
                          toastVariant: AppToastVariant.success,
                        );
                      },
                      failure: (msg, _) {
                        AppToast.showError(context, title: 'Store Switch Failed', message: msg);
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected ? colors.primaryContainer.withValues(alpha: 0.08) : colors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? colors.primary : colors.borderSubtle,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Store Icon Avatar
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected ? colors.primary : colors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.borderSubtle),
                          ),
                          child: Icon(
                            Icons.storefront_rounded,
                            size: 22,
                            color: isSelected ? Colors.white : colors.textPrimary,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Store Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shop.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                shop.address.isNotEmpty ? shop.address : 'Downtown Branch, Sector 4',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Selection Indicator
                        if (isSelected)
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_rounded, size: 16, color: Colors.white),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: colors.borderSubtle),
                            ),
                            child: Text(
                              'Switch',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          AppSpacing.vGap16,

          // "+ Add New Branch" Action
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              AppToast.showInfo(
                context,
                title: 'Branch Expansion',
                message: 'New branch onboarding workflow initiated.',
              );
            },
            icon: const Icon(Icons.add_business_rounded, size: 18),
            label: const Text('Add New Store Branch'),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.primary,
              side: BorderSide(color: colors.primary, width: 1.2),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
              textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
