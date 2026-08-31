import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_button.dart';
import '../../../../shared/components/app_text_field.dart';
import '../../../../shared/components/app_circular_back_button.dart';
import '../../../../shared/components/app_header_action_button.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../notifications/domain/models/notification_type.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';

// Edit Vendor Profile Screen
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _businessNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final vendor = context.read<AuthController>().vendor;

    _nameController = TextEditingController(text: vendor?.name ?? 'Samiul Arif');
    _businessNameController = TextEditingController(
      text: vendor?.businessName ?? 'Arif Food Enterprises LLC',
    );
    _phoneController = TextEditingController(
      text: vendor?.phoneNumber ?? '+1 (555) 234-5678',
    );
    _emailController = TextEditingController(
      text: vendor?.email ?? 'demo@vendor.com',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _businessNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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
        businessName: _businessNameController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      if (mounted) {
        setState(() => _isSaving = false);
        result.when(
          success: (updated) {
            context.read<NotificationController>().dispatchNotification(
              context,
              title: 'Profile Updated',
              message: 'Merchant business details saved successfully.',
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF161B22) : const Color(0xFFFFFFFF),
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 56,
        leading: const AppCircularBackButton(),
        title: Text(
          'Edit Vendor Profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        actions: [
          AppHeaderActionButton(
            text: 'Save',
            isLoading: _isSaving,
            onPressed: _handleSave,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: isDark ? AppColors.darkBorder : const Color(0xFFEEF0F2),
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Avatar Preview
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF2E1A2A) : AppColors.primaryTint,
                        border: Border.all(color: AppColors.primary, width: 2.5),
                      ),
                      child: const Center(
                        child: Text(
                          'A',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.ctaPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGap24,

              // Full Name
              AppTextField(
                label: 'Partner / Owner Name',
                controller: _nameController,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),

              AppSpacing.vGap16,

              // Business Name
              AppTextField(
                label: 'Business Entity Name',
                controller: _businessNameController,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter registered business name';
                  }
                  return null;
                },
              ),

              AppSpacing.vGap16,

              // Contact Phone
              AppTextField(
                label: 'Primary Contact Phone',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),

              AppSpacing.vGap16,

              // Email (Read only)
              AppTextField(
                label: 'Account Email (Verified)',
                controller: _emailController,
                enabled: false,
                suffixIcon: const Icon(Icons.lock_outline_rounded, size: 18),
              ),

              AppSpacing.vGap32,

              // Save Button (modern_ui_arif Solid Black Primary CTA)
              AppButton(
                text: 'Save Profile Changes',
                isLoading: _isSaving,
                onPressed: _handleSave,
                variant: AppButtonVariant.primary,
                size: AppButtonSize.large,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
