import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../shop/presentation/controllers/shop_controller.dart';
import '../../../shop/presentation/widgets/shop_switcher_bottom_sheet.dart';

/// Shop Information & Store Preferences Screen matching Stitch brief (`shop_management_with_shop_switcher_modal/code.html`)
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

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final shopController = context.read<ShopController>();
      final authController = context.read<AuthController>();
      final shop = shopController.currentShop ?? authController.activeShop;

      _nameController = TextEditingController(text: shop?.name ?? 'Jane\'s Gourmet Bakery');
      _descController = TextEditingController(text: shop?.description ?? 'Artisanal baked goods, pastries, sourdough bread and specialty espresso drinks.');
      _phoneController = TextEditingController(text: shop?.phone.isNotEmpty == true ? shop!.phone : '+880 1711778889');
      _addressController = TextEditingController(text: shop?.address.isNotEmpty == true ? shop!.address : 'House 42, Road 11, Banani');
      _cityController = TextEditingController(text: 'Dhaka');
      _zipController = TextEditingController(text: '1213');
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _showShopSwitcherModal() {
    ShopSwitcherBottomSheet.show(context);
  }

  void _handleSaveChanges() {
    if (!_formKey.currentState!.validate()) return;

    AppToast.showSuccess(
      context,
      title: 'Changes Saved',
      message: 'Storefront information and preferences updated successfully.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final shopController = context.watch<ShopController>();
    final authController = context.watch<AuthController>();

    final shop = shopController.currentShop ?? authController.activeShop;
    final isOpen = shop?.isOpen ?? true;
    final autoAccept = shop?.autoAcceptOrders ?? true;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        bottom: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 120),
            children: [
              // Page Header: "Shop Management" + Subtitle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shop Management',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: colors.textPrimary,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Manage your storefront details and visibility.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              AppSpacing.vGap16,

              // 1. Active Store Switcher Banner Card (Consistent Switcher Style)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF15171C).withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Store Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colors.primaryContainer.withValues(alpha: 0.3)),
                      ),
                      child: Icon(Icons.storefront_rounded, color: colors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Active Store Branch',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: isOpen ? colors.successBg : colors.errorBg,
                                  borderRadius: AppRadius.full,
                                ),
                                child: Text(
                                  isOpen ? 'OPEN' : 'CLOSED',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                    color: isOpen ? colors.success : colors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            shop?.name ?? 'Jane\'s Gourmet Bakery',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _showShopSwitcherModal,
                      icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                      label: const Text('Switch'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.ctaPrimary,
                        foregroundColor: colors.ctaPrimaryText,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        minimumSize: Size.zero,
                        shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGap16,

              // 2. Storefront Cover Banner Card
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF15171C).withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Image
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFB90058), Color(0xFFE21B70)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(Icons.restaurant_rounded, size: 44, color: Colors.white.withValues(alpha: 0.4)),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: AppRadius.full,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.photo_camera_rounded, size: 14, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'Update Cover',
                                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Storefront Banner',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Visible on customer marketplace hero section',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGap16,

              // 3. Basic Information Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF15171C).withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Information',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    AppSpacing.vGap16,
                    _buildField(
                      label: 'SHOP NAME',
                      controller: _nameController,
                      colors: colors,
                      hint: 'e.g. Jane\'s Gourmet Bakery',
                    ),
                    AppSpacing.vGap14,
                    _buildField(
                      label: 'DESCRIPTION',
                      controller: _descController,
                      colors: colors,
                      hint: 'Describe your specialties and story...',
                      maxLines: 3,
                    ),
                    AppSpacing.vGap14,
                    _buildField(
                      label: 'CONTACT NUMBER',
                      controller: _phoneController,
                      colors: colors,
                      hint: '+880 1711778889',
                      prefixIcon: Icons.phone_outlined,
                    ),
                  ],
                ),
              ),

              AppSpacing.vGap16,

              // 4. Location Details Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF15171C).withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Store Location',
                      style: TextStyle(
                        fontSize: 15,
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
                        const SizedBox(width: 12),
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

              AppSpacing.vGap16,

              // 5. Operating Preferences (Auto-Accept Orders Switch)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF15171C).withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Handling Preferences',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    AppSpacing.vGap14,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Auto-Accept Incoming Orders',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Automatically forward new orders to kitchen queue',
                                style: TextStyle(fontSize: 12, color: colors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Transform.scale(
                          scale: 0.85,
                          child: Switch.adaptive(
                            value: autoAccept,
                            activeThumbColor: const Color(0xFF006B57),
                            activeTrackColor: const Color(0xFF75F9D6),
                            onChanged: (val) {
                              shopController.toggleAutoAccept(val, authController: authController);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              AppSpacing.vGap24,

              // 6. Save Changes Pill CTA
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _handleSaveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.ctaPrimary,
                    foregroundColor: colors.ctaPrimaryText,
                    shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                    elevation: 1,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Save Changes',
                        style: TextStyle(
                          color: colors.ctaPrimaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 6),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: colors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: colors.textPrimary, fontSize: 13.5),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: colors.textMuted, fontSize: 13),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18, color: colors.textMuted) : null,
            filled: true,
            fillColor: colors.surfaceSubtle,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
