import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/components/app_toast.dart';

/// Change Password Screen strictly matching Stitch brief (`account_settings_change_password/code.html`)
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleUpdatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);

    AppToast.showSuccess(
      context,
      title: 'Password Updated',
      message: 'Your merchant account password has been changed successfully.',
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          'Account Settings',
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
              // Page Context Header matching Stitch
              Text(
                'Security',
                style: AppTypography.headlineMedium.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              AppSpacing.vGap2,
              Text(
                'Manage your account security and password.',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                  fontSize: 13,
                ),
              ),

              AppSpacing.vGap20,

              // Change Password Card matching Stitch (`account_settings_change_password/code.html`)
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
                      'Change Password',
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    AppSpacing.vGap12,
                    Divider(height: 1, color: colors.divider),
                    AppSpacing.vGap20,

                    // 1. Current Password Field
                    _buildPasswordField(
                      label: 'CURRENT PASSWORD',
                      controller: _currentPasswordController,
                      obscureText: _obscureCurrent,
                      onToggleObscure: () => setState(() => _obscureCurrent = !_obscureCurrent),
                      colors: colors,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter current password';
                        }
                        return null;
                      },
                    ),

                    AppSpacing.vGap16,

                    // 2. New Password Field
                    _buildPasswordField(
                      label: 'NEW PASSWORD',
                      controller: _newPasswordController,
                      obscureText: _obscureNew,
                      onToggleObscure: () => setState(() => _obscureNew = !_obscureNew),
                      colors: colors,
                      validator: (val) {
                        if (val == null || val.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    AppSpacing.vGap16,

                    // 3. Confirm New Password Field
                    _buildPasswordField(
                      label: 'CONFIRM NEW PASSWORD',
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      onToggleObscure: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      colors: colors,
                      validator: (val) {
                        if (val != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    AppSpacing.vGap24,

                    // Action Button (Right aligned solid pill matching Stitch HTML)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleUpdatePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.textInverse,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadius.full,
                            ),
                            elevation: 1,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.textInverse,
                                  ),
                                )
                              : Text(
                                  'Update Password',
                                  style: AppTypography.labelLarge.copyWith(
                                    color: colors.textInverse,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
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

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleObscure,
    required AppSemanticColors colors,
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
          obscureText: obscureText,
          validator: validator,
          style: AppTypography.bodyMedium.copyWith(
            color: colors.textPrimary,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: colors.textMuted,
              letterSpacing: 2,
            ),
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
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 20,
                color: colors.textMuted,
              ),
              onPressed: onToggleObscure,
            ),
          ),
        ),
      ],
    );
  }
}
