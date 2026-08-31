import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/app_switch.dart';
import '../../../../shared/components/shared_select_modal.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../shop/presentation/controllers/shop_controller.dart';

// Shop Information & Store Preferences Screen (Cleaned without extra fees/schedules)
class ShopSettingsScreen extends StatefulWidget {
  const ShopSettingsScreen({super.key});

  @override
  State<ShopSettingsScreen> createState() => _ShopSettingsScreenState();
}

class _ShopSettingsScreenState extends State<ShopSettingsScreen> {
  void _showShopSwitcherModal() async {
    final authController = context.read<AuthController>();
    final shopController = context.read<ShopController>();
    final availableShops = authController.availableShops;
    final currentShopId = shopController.currentShop?.id ?? authController.activeShop?.id ?? 'shop_01';

    final options = availableShops.map((s) {
      return SelectOptionItem<String>(
        value: s.id,
        title: s.name,
        subtitle: s.description,
        icon: Icons.storefront_rounded,
      );
    }).toList();

    final selectedId = await SharedSelectModal.show<String>(
      context: context,
      title: 'Active Shop Switcher',
      subtitle: 'Switch between stores in your merchant portfolio',
      options: options,
      selectedValue: currentShopId,
    );

    if (selectedId != null && selectedId != currentShopId) {
      final result = await authController.switchShop(selectedId);
      result.when(
        success: (session) {
          if (session.activeShop != null) {
            shopController.setActiveShop(session.activeShop!);
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Switched store to "${session.activeShop?.name ?? ''}"'),
                backgroundColor: AppColors.statusSuccess,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        failure: (msg, _) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: AppColors.statusError,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shopController = context.watch<ShopController>();
    final authController = context.watch<AuthController>();

    final shop = shopController.currentShop ?? authController.activeShop;
    final isOpen = shop?.isOpen ?? true;
    final autoAccept = shop?.autoAcceptOrders ?? true;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
      appBar: AppBar(
        title: const Text(
          'Shop Information',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          children: [
            // Active Shop Switcher & Summary Card (Screenshots 1 & 2)
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Shop Switcher',
                    style: AppTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Dropdown box for switching shop
                  GestureDetector(
                    onTap: _showShopSwitcherModal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF232A34) : AppColors.lightSurfaceSubtle,
                        borderRadius: AppRadius.md,
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              shop?.name ?? 'Foodie Hub Express (Restaurant)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ],
                      ),
                    ),
                  ),

                  AppSpacing.vGap16,

                  // Detail rows matching Screenshot 1 & 2:
                  _buildDetailRow(
                    label: 'Operating Hours',
                    value: '${shop?.openingTime ?? "08:30 AM"} – ${shop?.closingTime ?? "11:00 PM"}',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    label: 'Delivery Radius',
                    value: '5.0 km',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    label: 'Auto-Accept Orders',
                    value: autoAccept ? 'Enabled' : 'Disabled',
                    valueColor: autoAccept ? const Color(0xFF10B981) : AppColors.statusError,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    label: 'Device Terminal',
                    value: 'Sunmi V2 Pro / iOS',
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            AppSpacing.vGap20,

            // Store Preferences & Operational Controls
            Text(
              'STORE PREFERENCES',
              style: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
            AppSpacing.vGap8,
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Store Status',
                            style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            isOpen ? 'Accepting customer orders' : 'Store marked offline',
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                      AppSwitch(
                        value: isOpen,
                        onChanged: (val) => shopController.toggleStoreStatus(val),
                      ),
                    ],
                  ),
                  Divider(height: 24, color: isDark ? AppColors.darkDivider : AppColors.lightDivider),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Auto-Accept Live Orders',
                            style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Instantly dispatch to kitchen queue',
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                      AppSwitch(
                        value: autoAccept,
                        onChanged: (val) {
                          if (shop != null) {
                            shopController.updateShop(shop.copyWith(autoAcceptOrders: val));
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    Color? valueColor,
    required bool isDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ],
    );
  }
}
