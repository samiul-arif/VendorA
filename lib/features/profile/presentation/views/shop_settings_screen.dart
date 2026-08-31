import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/components/app_button.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/app_switch.dart';
import '../../../../shared/components/app_text_field.dart';
import '../../../../shared/components/app_bottom_sheet.dart';
import '../../../../shared/components/shared_select_modal.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../shop/presentation/controllers/shop_controller.dart';
import '../../domain/models/operating_hours_model.dart';
import '../controllers/profile_controller.dart';

// Shop Information & Operational Hours Screen (Tab 3 in Main Shell - arif.html Aligned)
class ShopSettingsScreen extends StatefulWidget {
  const ShopSettingsScreen({super.key});

  @override
  State<ShopSettingsScreen> createState() => _ShopSettingsScreenState();
}

class _ShopSettingsScreenState extends State<ShopSettingsScreen> {
  late TextEditingController _minOrderController;
  late TextEditingController _deliveryFeeController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final shop = context.read<ShopController>().currentShop ??
        context.read<AuthController>().activeShop;

    _minOrderController = TextEditingController(
      text: (shop?.minimumOrderAmount ?? 12.00).toStringAsFixed(2),
    );
    _deliveryFeeController = TextEditingController(
      text: (shop?.deliveryFee ?? 2.99).toStringAsFixed(2),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shopId = shop?.id ?? 'shop_01';
      context.read<ProfileController>().loadProfileSettings(shopId: shopId);
    });
  }

  @override
  void dispose() {
    _minOrderController.dispose();
    _deliveryFeeController.dispose();
    super.dispose();
  }

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

  void _editHoursModal(int index, OperatingHoursModel day) {
    final openController = TextEditingController(text: day.openTime);
    final closeController = TextEditingController(text: day.closeTime);
    bool isClosed = day.isClosed;

    AppBottomSheet.show(
      context: context,
      title: '${day.dayOfWeek} Hours',
      subtitle: 'Set opening and closing kitchen times',
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Mark as Closed on this day', style: TextStyle(fontWeight: FontWeight.w700)),
                  AppSwitch(
                    value: isClosed,
                    onChanged: (val) => setModalState(() => isClosed = val),
                  ),
                ],
              ),
              if (!isClosed) ...[
                AppSpacing.vGap16,
                AppTextField(
                  label: 'Opening Time',
                  controller: openController,
                  hint: 'e.g. 08:30 AM',
                ),
                AppSpacing.vGap12,
                AppTextField(
                  label: 'Closing Time',
                  controller: closeController,
                  hint: 'e.g. 11:00 PM',
                ),
              ],
              AppSpacing.vGap24,
              AppButton(
                text: 'Save Hours',
                onPressed: () async {
                  Navigator.of(context).pop();
                  final authController = context.read<AuthController>();
                  final shopId = authController.activeShop?.id ?? 'shop_01';

                  final updated = day.copyWith(
                    openTime: openController.text.trim(),
                    closeTime: closeController.text.trim(),
                    isClosed: isClosed,
                  );

                  await context.read<ProfileController>().updateDayHours(
                    shopId: shopId,
                    index: index,
                    updatedDay: updated,
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Updated ${day.dayOfWeek} schedule.'),
                        backgroundColor: AppColors.statusSuccess,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleSaveThresholds() async {
    setState(() => _isSaving = true);
    final shopController = context.read<ShopController>();
    final shop = shopController.currentShop ?? context.read<AuthController>().activeShop;

    if (shop != null) {
      final minOrder = double.tryParse(_minOrderController.text.trim()) ?? shop.minimumOrderAmount;
      final delFee = double.tryParse(_deliveryFeeController.text.trim()) ?? shop.deliveryFee;

      final updated = shop.copyWith(
        minimumOrderAmount: minOrder,
        deliveryFee: delFee,
      );

      final result = await shopController.updateShop(updated);
      if (mounted) {
        setState(() => _isSaving = false);
        result.when(
          success: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Store settings and thresholds saved!'),
                backgroundColor: AppColors.statusSuccess,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          failure: (msg, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: AppColors.statusError,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      }
    } else {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shopController = context.watch<ShopController>();
    final authController = context.watch<AuthController>();
    final profileController = context.watch<ProfileController>();

    final shop = shopController.currentShop ?? authController.activeShop;
    final isOpen = shop?.isOpen ?? true;
    final autoAccept = shop?.autoAcceptOrders ?? true;
    final hours = profileController.operatingHours;

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
            // Screenshot 1 & 2: Active Shop Switcher & Summary Card
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

                  // Detail rows matching Screenshot 1:
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

            // Quick Operational Toggles
            Text(
              'OPERATIONAL CONTROLS',
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

            AppSpacing.vGap20,

            // Order Thresholds & Delivery
            Text(
              'FEES & THRESHOLDS',
              style: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
            AppSpacing.vGap8,
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Min. Order Amount',
                          hint: '12.00',
                          controller: _minOrderController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          prefixIcon: const Icon(Icons.attach_money_rounded, size: 18),
                        ),
                      ),
                      AppSpacing.hGap12,
                      Expanded(
                        child: AppTextField(
                          label: 'Base Delivery Fee',
                          hint: '2.99',
                          controller: _deliveryFeeController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          prefixIcon: const Icon(Icons.attach_money_rounded, size: 18),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vGap16,
                  AppButton(
                    text: 'Save Thresholds',
                    isLoading: _isSaving,
                    size: AppButtonSize.medium,
                    variant: AppButtonVariant.primary,
                    onPressed: _handleSaveThresholds,
                  ),
                ],
              ),
            ),

            AppSpacing.vGap20,

            // Weekly Operating Hours
            Text(
              'WEEKLY OPERATING SCHEDULE',
              style: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
            AppSpacing.vGap8,
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: hours.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final day = entry.value;
                  final isLast = idx == hours.length - 1;

                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        title: Text(
                          day.dayOfWeek,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        subtitle: Text(
                          day.isClosed ? 'Closed' : '${day.openTime} - ${day.closeTime}',
                          style: TextStyle(
                            fontSize: 12,
                            color: day.isClosed ? AppColors.statusError : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: const Icon(Icons.edit_outlined, size: 18),
                        onTap: () => _editHoursModal(idx, day),
                      ),
                      if (!isLast)
                        Divider(height: 1, color: isDark ? AppColors.darkDivider : AppColors.lightDivider),
                    ],
                  );
                }).toList(),
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
