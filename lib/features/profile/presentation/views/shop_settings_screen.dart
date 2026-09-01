import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../shop/presentation/controllers/shop_controller.dart';
import '../../../shop/presentation/widgets/shop_switcher_bottom_sheet.dart';

/// Shop Information & Store Preferences Screen matching Stitch brief (`shop_management_with_shop_switcher_modal/code.html`)
/// with Top Card (Open/Close & Switch buttons stacked vertically), Image update support, Operating Hours, and Payment Preferences.
class ShopSettingsScreen extends StatefulWidget {
  const ShopSettingsScreen({super.key});

  @override
  State<ShopSettingsScreen> createState() => _ShopSettingsScreenState();
}

class _ShopSettingsScreenState extends State<ShopSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _zipController;
  late TextEditingController _minOrderController;
  late TextEditingController _deliveryFeeController;

  String _openingTime = '08:30 AM';
  String _closingTime = '11:00 PM';
  String? _bannerImageUrl;
  String? _logoImageUrl;

  final Set<String> _acceptedPaymentMethods = {'bKash', 'Nagad', 'Cash on Delivery', 'Credit Card'};

  final List<String> _allPaymentMethods = [
    'bKash',
    'Nagad',
    'Cash on Delivery',
    'Credit Card',
    'Rocket',
  ];

  @override
  void initState() {
    super.initState();
    final shopController = context.read<ShopController>();
    final authController = context.read<AuthController>();
    final shop = shopController.currentShop ?? authController.activeShop;

    _nameController = TextEditingController(text: shop?.name ?? 'Jane\'s Gourmet Bakery');
    _descController = TextEditingController(
      text: shop?.description ?? 'Artisanal baked goods, pastries, sourdough bread and specialty espresso drinks.',
    );
    _phoneController = TextEditingController(text: shop?.phone.isNotEmpty == true ? shop!.phone : '+880 1711778889');
    _addressController = TextEditingController(text: shop?.address.isNotEmpty == true ? shop!.address : 'House 42, Road 11, Banani');
    _cityController = TextEditingController(text: shop?.city.isNotEmpty == true ? shop!.city : 'Dhaka');
    _zipController = TextEditingController(text: '1213');
    _minOrderController = TextEditingController(text: shop?.minimumOrderAmount.toStringAsFixed(0) ?? '150');
    _deliveryFeeController = TextEditingController(text: shop?.deliveryFee.toStringAsFixed(0) ?? '40');
    _openingTime = shop?.openingTime ?? '08:30 AM';
    _closingTime = shop?.closingTime ?? '11:00 PM';
    _bannerImageUrl = shop?.bannerUrl;
    _logoImageUrl = shop?.logoUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _minOrderController.dispose();
    _deliveryFeeController.dispose();
    super.dispose();
  }

  void _showShopSwitcherModal() {
    ShopSwitcherBottomSheet.show(context);
  }

  void _pickTime({required bool isOpening}) async {
    final initial = isOpening ? const TimeOfDay(hour: 8, minute: 30) : const TimeOfDay(hour: 23, minute: 0);
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );

    if (picked != null) {
      final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      final minute = picked.minute.toString().padLeft(2, '0');
      final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
      final formatted = '${hour.toString().padLeft(2, '0')}:$minute $period';

      setState(() {
        if (isOpening) {
          _openingTime = formatted;
        } else {
          _closingTime = formatted;
        }
      });
    }
  }

  void _handleImageUpdate({required bool isBanner}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.appColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final colors = ctx.appColors;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBanner ? 'Update Storefront Banner' : 'Update Store Logo',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                AppSpacing.vGap6,
                Text(
                  'Select an image from gallery or use modern curated preset.',
                  style: AppTypography.bodySmall.copyWith(color: colors.textSecondary),
                ),
                AppSpacing.vGap20,
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.surfaceLow,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.photo_library_rounded, color: colors.primary),
                  ),
                  title: Text(
                    'Choose from Device Gallery',
                    style: AppTypography.labelLarge.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w700),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      if (isBanner) {
                        _bannerImageUrl = 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800';
                      } else {
                        _logoImageUrl = 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400';
                      }
                    });
                    AppToast.showSuccess(
                      context,
                      title: 'Image Updated',
                      message: isBanner ? 'Storefront banner updated successfully.' : 'Store logo updated successfully.',
                    );
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.surfaceLow,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.auto_awesome_rounded, color: colors.secondary),
                  ),
                  title: Text(
                    'Set Bakery / Cafe Aesthetic Preset',
                    style: AppTypography.labelLarge.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w700),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      if (isBanner) {
                        _bannerImageUrl = 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800';
                      } else {
                        _logoImageUrl = 'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=400';
                      }
                    });
                    AppToast.showSuccess(
                      context,
                      title: 'Preset Applied',
                      message: 'Curated merchant aesthetic applied.',
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleSaveChanges() {
    if (!_formKey.currentState!.validate()) return;

    final shopController = context.read<ShopController>();
    final authController = context.read<AuthController>();
    final current = shopController.currentShop ?? authController.activeShop;

    if (current != null) {
      final updated = current.copyWith(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        openingTime: _openingTime,
        closingTime: _closingTime,
        bannerUrl: _bannerImageUrl,
        logoUrl: _logoImageUrl,
        minimumOrderAmount: double.tryParse(_minOrderController.text) ?? 150.0,
        deliveryFee: double.tryParse(_deliveryFeeController.text) ?? 40.0,
      );
      shopController.setActiveShop(updated);
      authController.updateActiveShop(updated);
    }

    AppToast.showSuccess(
      context,
      title: 'Changes Saved',
      message: 'Storefront details and operational preferences updated successfully.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDark;
    final shopController = context.watch<ShopController>();
    final authController = context.watch<AuthController>();
    final notifController = context.watch<NotificationController>();
    final unreadCount = notifController.unreadCount;

    final shop = shopController.currentShop ?? authController.activeShop;
    final isOpen = shop?.isOpen ?? true;
    final autoAccept = shop?.autoAcceptOrders ?? true;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Icon(
                Icons.store_mall_directory_rounded,
                size: 20,
                color: colors.primary,
              ),
            ),
          ),
        ),
        title: Text(
          'Shop Settings',
          style: AppTypography.headlineMedium.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.notifications);
            },
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: colors.textPrimary,
                  size: 24,
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colors.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.surface, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.hGap8,
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 130),
            children: [
              // 1. Updated Shop Top Card: Open/Close & Switch buttons stacked vertically
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.lg,
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store Avatar / Logo with edit trigger
                    GestureDetector(
                      onTap: () => _handleImageUpdate(isBanner: false),
                      child: Stack(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.12),
                              borderRadius: AppRadius.md,
                              border: Border.all(color: colors.borderSubtle),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: _logoImageUrl != null
                                ? Image.network(
                                    _logoImageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.storefront_rounded,
                                      color: colors.primary,
                                      size: 28,
                                    ),
                                  )
                                : Icon(
                                    Icons.storefront_rounded,
                                    color: colors.primary,
                                    size: 28,
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: colors.surface, width: 1.5),
                              ),
                              child: Icon(Icons.edit_rounded, size: 10, color: colors.textInverse),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.hGap14,
                    // Branch Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Active Store Branch',
                                style: AppTypography.bodySmall.copyWith(
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              AppSpacing.hGap6,
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isOpen
                                      ? colors.secondary.withValues(alpha: 0.15)
                                      : colors.error.withValues(alpha: 0.15),
                                  borderRadius: AppRadius.full,
                                ),
                                child: Text(
                                  isOpen ? 'OPEN' : 'CLOSED',
                                  style: AppTypography.labelSmall.copyWith(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                    color: isOpen ? colors.secondary : colors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.vGap4,
                          Text(
                            shop?.name ?? 'Jane\'s Gourmet Bakery',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w900,
                              color: colors.textPrimary,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AppSpacing.vGap2,
                          Text(
                            shop?.address ?? 'House 42, Road 11, Banani, Dhaka',
                            style: AppTypography.bodySmall.copyWith(
                              color: colors.textMuted,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.hGap10,
                    // Two Buttons Vertically Stacked: Open/Close & Switch
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Button 1: Open / Close Store Action
                        SizedBox(
                          width: 82,
                          height: 32,
                          child: OutlinedButton(
                            onPressed: () {
                              shopController.toggleStoreStatus(!isOpen, authController: authController);
                              AppToast.showInfo(
                                context,
                                title: isOpen ? 'Store Closed' : 'Store Opened',
                                message: isOpen
                                    ? 'Your store is marked closed for incoming orders.'
                                    : 'Your store is live and accepting customer orders.',
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: isOpen ? colors.error : colors.secondary,
                                width: 1.2,
                              ),
                              padding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                borderRadius: AppRadius.full,
                              ),
                            ),
                            child: Text(
                              isOpen ? 'Close' : 'Open',
                              style: AppTypography.labelSmall.copyWith(
                                color: isOpen ? colors.error : colors.secondary,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        AppSpacing.vGap6,
                        // Button 2: Switch Branch Action
                        SizedBox(
                          width: 82,
                          height: 32,
                          child: ElevatedButton.icon(
                            onPressed: _showShopSwitcherModal,
                            icon: Icon(Icons.swap_horiz_rounded, size: 14, color: colors.textInverse),
                            label: Text(
                              'Switch',
                              style: AppTypography.labelSmall.copyWith(
                                color: colors.textInverse,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.textInverse,
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              elevation: 0,
                              shape: const RoundedRectangleBorder(
                                borderRadius: AppRadius.full,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              AppSpacing.vGap16,

              // 2. Storefront Cover Banner Card
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.lg,
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Image container with update overlay
                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colors.surfaceLow,
                        gradient: _bannerImageUrl == null
                            ? LinearGradient(
                                colors: [colors.primary, colors.primary.withValues(alpha: 0.7)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                      ),
                      child: Stack(
                        children: [
                          if (_bannerImageUrl != null)
                            Image.network(
                              _bannerImageUrl!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Icon(Icons.restaurant_rounded, size: 44, color: colors.textMuted),
                              ),
                            )
                          else
                            Center(
                              child: Icon(Icons.restaurant_rounded, size: 44, color: Colors.white.withValues(alpha: 0.6)),
                            ),
                          Positioned(
                            bottom: 10,
                            right: 12,
                            child: GestureDetector(
                              onTap: () => _handleImageUpdate(isBanner: true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  borderRadius: AppRadius.full,
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.photo_camera_rounded, size: 14, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text(
                                      'Update Cover',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Storefront Cover Banner',
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colors.textPrimary,
                            ),
                          ),
                          AppSpacing.vGap2,
                          Text(
                            'Displayed on customer discovery feed and shop hero section.',
                            style: AppTypography.bodySmall.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGap16,

              // 3. Operating Hours & Preferences Section
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.lg,
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded, size: 18, color: colors.primary),
                        AppSpacing.hGap8,
                        Text(
                          'Operating Hours & Schedule',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vGap16,
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(isOpening: true),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colors.surfaceLow,
                                borderRadius: AppRadius.md,
                                border: Border.all(color: colors.borderSubtle),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'OPENING TIME',
                                    style: AppTypography.labelSmall.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                  AppSpacing.vGap6,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _openingTime,
                                        style: AppTypography.titleSmall.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: colors.textPrimary,
                                        ),
                                      ),
                                      Icon(Icons.access_time_rounded, size: 16, color: colors.primary),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        AppSpacing.hGap12,
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(isOpening: false),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colors.surfaceLow,
                                borderRadius: AppRadius.md,
                                border: Border.all(color: colors.borderSubtle),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CLOSING TIME',
                                    style: AppTypography.labelSmall.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                  AppSpacing.vGap6,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _closingTime,
                                        style: AppTypography.titleSmall.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: colors.textPrimary,
                                        ),
                                      ),
                                      Icon(Icons.access_time_filled_rounded, size: 16, color: colors.primary),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              AppSpacing.vGap16,

              // 4. Accepted Payment Methods Section
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.lg,
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.payments_outlined, size: 18, color: colors.primary),
                        AppSpacing.hGap8,
                        Text(
                          'Accepted Payment Methods',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vGap6,
                    Text(
                      'Select the payment channels your store accepts from customers.',
                      style: AppTypography.bodySmall.copyWith(color: colors.textSecondary),
                    ),
                    AppSpacing.vGap14,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _allPaymentMethods.map((method) {
                        final isSelected = _acceptedPaymentMethods.contains(method);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                if (_acceptedPaymentMethods.length > 1) {
                                  _acceptedPaymentMethods.remove(method);
                                } else {
                                  AppToast.showWarning(context, title: 'Required', message: 'At least one payment method is required.');
                                }
                              } else {
                                _acceptedPaymentMethods.add(method);
                              }
                            });
                          },
                          borderRadius: AppRadius.full,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? colors.primary : colors.surfaceLow,
                              borderRadius: AppRadius.full,
                              border: Border.all(
                                color: isSelected ? colors.primary : colors.borderSubtle,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) ...[
                                  Icon(Icons.check_rounded, size: 14, color: colors.textInverse),
                                  const SizedBox(width: 4),
                                ],
                                Text(
                                  method,
                                  style: AppTypography.labelMedium.copyWith(
                                    color: isSelected ? colors.textInverse : colors.textPrimary,
                                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGap16,

              // 5. Order Handling & Operational Parameters
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.lg,
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tune_rounded, size: 18, color: colors.primary),
                        AppSpacing.hGap8,
                        Text(
                          'Order Handling Preferences',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vGap16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Auto-Accept Incoming Orders',
                                style: AppTypography.titleSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                ),
                              ),
                              AppSpacing.vGap2,
                              Text(
                                'Automatically forward new orders directly to kitchen queue',
                                style: AppTypography.bodySmall.copyWith(color: colors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Transform.scale(
                          scale: 0.85,
                          child: Switch.adaptive(
                            value: autoAccept,
                            activeThumbColor: colors.secondary,
                            activeTrackColor: colors.secondary.withValues(alpha: 0.35),
                            onChanged: (val) {
                              shopController.toggleAutoAccept(val, authController: authController);
                            },
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vGap16,
                    Divider(height: 1, color: colors.divider),
                    AppSpacing.vGap16,
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            label: 'MINIMUM ORDER (৳)',
                            controller: _minOrderController,
                            colors: colors,
                            hint: '150',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        AppSpacing.hGap12,
                        Expanded(
                          child: _buildField(
                            label: 'DELIVERY FEE (৳)',
                            controller: _deliveryFeeController,
                            colors: colors,
                            hint: '40',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              AppSpacing.vGap16,

              // 6. Basic Store Information Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.lg,
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Storefront Details',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    AppSpacing.vGap16,
                    _buildField(
                      label: 'STORE NAME *',
                      controller: _nameController,
                      colors: colors,
                      hint: 'Jane\'s Gourmet Bakery',
                      validator: (v) => v == null || v.trim().isEmpty ? 'Store name is required' : null,
                    ),
                    AppSpacing.vGap14,
                    _buildField(
                      label: 'STORE DESCRIPTION',
                      controller: _descController,
                      colors: colors,
                      hint: 'Artisanal baked goods, pastries, sourdough bread...',
                      maxLines: 2,
                    ),
                    AppSpacing.vGap14,
                    _buildField(
                      label: 'STORE PHONE *',
                      controller: _phoneController,
                      colors: colors,
                      hint: '+880 1711778889',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),

              AppSpacing.vGap16,

              // 7. Store Location Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.lg,
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Store Location',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    AppSpacing.vGap16,
                    _buildField(
                      label: 'STREET ADDRESS',
                      controller: _addressController,
                      colors: colors,
                      hint: 'House 42, Road 11, Banani',
                      prefixIcon: Icons.location_on_outlined,
                    ),
                    AppSpacing.vGap14,
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            label: 'CITY',
                            controller: _cityController,
                            colors: colors,
                            hint: 'Dhaka',
                          ),
                        ),
                        AppSpacing.hGap12,
                        Expanded(
                          child: _buildField(
                            label: 'ZIP CODE',
                            controller: _zipController,
                            colors: colors,
                            hint: '1213',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              AppSpacing.vGap24,

              // 8. Save Changes Solid Pill CTA Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleSaveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.ctaPrimary,
                    foregroundColor: colors.ctaPrimaryText,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.full,
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Save Store Changes',
                        style: AppTypography.labelLarge.copyWith(
                          color: colors.ctaPrimaryText,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      AppSpacing.hGap8,
                      Icon(Icons.check_circle_outline_rounded, size: 18, color: colors.ctaPrimaryText),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required AppSemanticColors colors,
    required String hint,
    IconData? prefixIcon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.textSecondary,
            letterSpacing: 0.4,
          ),
        ),
        AppSpacing.vGap6,
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTypography.bodyMedium.copyWith(
            color: colors.textPrimary,
            fontSize: 13.5,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: colors.textMuted,
              fontSize: 13,
            ),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18, color: colors.textMuted) : null,
            filled: true,
            fillColor: colors.surfaceLow,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: BorderSide(color: colors.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: BorderSide(color: colors.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: BorderSide(color: colors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
