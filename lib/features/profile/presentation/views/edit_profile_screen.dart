import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../notifications/domain/models/notification_type.dart';
import '../controllers/profile_controller.dart';
import 'change_password_screen.dart';

/// Vendor Profile Details Screen strictly matching Stitch brief (`vendor_profile_with_account_settings_link/code.html`)
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final vendor = context.read<AuthController>().vendor;

    _nameController = TextEditingController(text: vendor?.name ?? 'Alex Johnson');
    _emailController = TextEditingController(text: vendor?.email ?? 'alex.j@merchant.app');
    _phoneController = TextEditingController(text: vendor?.phoneNumber ?? '+880 1712 345678');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final authController = context.read<AuthController>();
    final profileController = context.read<ProfileController>();
    final vendor = authController.vendor;

    if (vendor != null) {
      final result = await profileController.updateProfile(
        vendorId: vendor.id,
        name: _nameController.text.trim(),
        businessName: vendor.businessName,
        phone: _phoneController.text.trim(),
      );

      if (mounted) {
        setState(() => _isSaving = false);
        result.when(
          success: (updated) {
            context.read<NotificationController>().dispatchNotification(
              context,
              title: 'Profile Updated',
              message: 'Personal information saved successfully.',
              type: NotificationType.system,
              toastVariant: AppToastVariant.success,
            );
            Navigator.of(context).pop();
          },
          failure: (msg, _) {
            AppToast.showError(context, title: 'Update Failed', message: msg);
          },
        );
      }
    } else {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDark;
    final authController = context.watch<AuthController>();
    final vendor = authController.vendor;
    final displayName = _nameController.text.isNotEmpty ? _nameController.text : (vendor?.name ?? 'Alex Johnson');

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profile Details',
          style: AppTypography.headlineMedium.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.2,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 120),
            children: [
              // 1. Avatar & Overview Hero Card (Bento Style matching Stitch brief)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.lg,
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
                ),
                child: Column(
                  children: [
                    // Circular Avatar with Floating Edit Button
                    Stack(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.primary.withValues(alpha: 0.12),
                            border: Border.all(color: colors.surface, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF15171C).withValues(alpha: 0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              displayName.isNotEmpty ? displayName[0].toUpperCase() : 'A',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                color: colors.primary,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: colors.primary.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    AppSpacing.vGap14,

                    // Merchant Full Name
                    Text(
                      displayName,
                      style: AppTypography.headlineMedium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: colors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),

                    AppSpacing.vGap6,

                    // Owner Role Pill (Emerald Green Chip matching Stitch HTML)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.secondaryContainer.withValues(alpha: 0.25),
                        borderRadius: AppRadius.full,
                      ),
                      child: Text(
                        'OWNER',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          color: colors.secondary,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),

                    AppSpacing.vGap20,

                    // Divider
                    Divider(color: colors.divider, height: 1),

                    AppSpacing.vGap16,

                    // Two Stat Columns: Active Items (142) & Store Rating (4.8 ★)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '142',
                              style: AppTypography.titleLarge.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: colors.textPrimary,
                              ),
                            ),
                            AppSpacing.vGap2,
                            Text(
                              'Active Items',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 12,
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 28,
                          width: 1,
                          color: colors.borderSubtle,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF59E0B)),
                                const SizedBox(width: 3),
                                Text(
                                  '4.8',
                                  style: AppTypography.titleLarge.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: colors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            AppSpacing.vGap2,
                            Text(
                              'Store Rating',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 12,
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              AppSpacing.vGap24,

              // 2. Personal Information Card matching Stitch (`vendor_profile_with_account_settings_link/code.html`)
              Container(
                padding: const EdgeInsets.all(20),
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
                      'Personal Information',
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    AppSpacing.vGap12,
                    Divider(height: 1, color: colors.divider),
                    AppSpacing.vGap20,

                    // Full Name Field
                    _buildInputField(
                      label: 'FULL NAME',
                      controller: _nameController,
                      colors: colors,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),

                    AppSpacing.vGap16,

                    // Email Address Field
                    _buildInputField(
                      label: 'EMAIL ADDRESS',
                      controller: _emailController,
                      colors: colors,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || !val.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),

                    AppSpacing.vGap16,

                    // Phone Number Field
                    _buildInputField(
                      label: 'PHONE NUMBER',
                      controller: _phoneController,
                      colors: colors,
                      keyboardType: TextInputType.phone,
                    ),

                    AppSpacing.vGap24,

                    // Action Buttons Row: Save Changes & Change Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colors.borderSubtle, width: 1.2),
                            foregroundColor: colors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadius.full,
                            ),
                          ),
                          child: Text(
                            'Change Password',
                            style: AppTypography.labelMedium.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        AppSpacing.hGap10,
                        ElevatedButton(
                          onPressed: _isSaving ? null : _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.ctaPrimary,
                            foregroundColor: colors.ctaPrimaryText,
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadius.full,
                            ),
                            elevation: 1,
                          ),
                          child: _isSaving
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.ctaPrimaryText,
                                  ),
                                )
                              : Text(
                                  'Save Changes',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: colors.ctaPrimaryText,
                                    fontWeight: FontWeight.w800,
                                  ),
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
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required AppSemanticColors colors,
    TextInputType keyboardType = TextInputType.text,
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
            letterSpacing: 0.5,
          ),
        ),
        AppSpacing.vGap6,
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTypography.bodyMedium.copyWith(
            color: colors.textPrimary,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.surfaceLow,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
