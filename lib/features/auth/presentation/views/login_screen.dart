import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/navigation_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/components/app_button.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/app_text_field.dart';
import '../../../../shared/components/app_bottom_sheet.dart';
import '../../../../shared/components/app_toast.dart';
import '../controllers/auth_controller.dart';
import '../widgets/vendor_brand_header.dart';
import '../widgets/demo_credentials_chip.dart';

// Vendor Login Screen (modern_ui_arif Card-First Authentication Experience)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = true;
  String? _inlineError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _autofillDemo() {
    setState(() {
      _emailController.text = 'demo@vendor.com';
      _passwordController.text = 'vendor123';
      _inlineError = null;
    });
  }

  Future<void> _handleLogin() async {
    setState(() => _inlineError = null);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authController = context.read<AuthController>();
    final result = await authController.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    result.when(
      success: (session) {
        AppToast.showSuccess(
          context,
          title: 'Welcome Back, ${session.vendor.name}!',
          message: 'Signed in as ${session.activeShop?.name ?? "Merchant"}.',
        );

        // Clear stack and navigate to Main Dashboard Shell
        NavigationService.instance.clearStackAndNavigateTo(AppRoutes.mainShell);
      },
      failure: (message, exception) {
        setState(() => _inlineError = message);
        AppToast.showError(
          context,
          title: 'Authentication Failed',
          message: message,
        );
      },
    );
  }

  void _showForgotPasswordSheet() {
    final resetEmailController = TextEditingController(text: _emailController.text);

    AppBottomSheet.show(
      context: context,
      title: 'Reset Password',
      subtitle: 'Enter your registered email address to receive recovery instructions.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Registered Email',
            hint: 'e.g. vendor@business.com',
            controller: resetEmailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined, size: 20),
          ),
          AppSpacing.vGap24,
          AppButton(
            text: 'Send Reset Link',
            onPressed: () {
              Navigator.of(context).pop();
              AppToast.showInfo(
                context,
                title: 'Reset Link Sent',
                message: 'Password reset instructions have been sent to ${resetEmailController.text.trim()}.',
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final authController = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Brand Identity & Header
                  const VendorBrandHeader(),

                  AppSpacing.vGap24,

                  // Main Login Form Card
                  AppCard(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Demo Credentials Fast-Fill
                          DemoCredentialsChip(onFillCredentials: _autofillDemo),

                          AppSpacing.vGap20,

                          // Inline Error Banner (if any)
                          if (_inlineError != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colors.errorBg,
                                borderRadius: AppRadius.md,
                                border: Border.all(
                                  color: colors.error.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline_rounded,
                                    size: 20,
                                    color: colors.error,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _inlineError!,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: colors.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppSpacing.vGap16,
                          ],

                          // Email Input Field
                          AppTextField(
                            label: 'Email Address',
                            hint: 'vendor@foodpanda.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: Validators.validateEmail,
                            prefixIcon: const Icon(Icons.email_outlined, size: 20),
                            showClearButton: true,
                          ),

                          AppSpacing.vGap16,

                          // Password Input Field
                          AppTextField(
                            label: 'Password',
                            hint: 'Enter your account password',
                            controller: _passwordController,
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            validator: Validators.validatePassword,
                            onSubmitted: (_) => _handleLogin(),
                            prefixIcon: const Icon(Icons.lock_outline, size: 20),
                          ),

                          AppSpacing.vGap12,

                          // Remember Me & Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      activeColor: colors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      onChanged: (val) => setState(() => _rememberMe = val ?? true),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => setState(() => _rememberMe = !_rememberMe),
                                    child: Text(
                                      'Remember me',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: _showForgotPasswordSheet,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Forgot password?',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          AppSpacing.vGap24,

                          // Solid Near-Black Primary CTA Button (modern_ui_arif standard)
                          AppButton(
                            text: 'Sign In to Store',
                            isLoading: authController.isLoading,
                            onPressed: _handleLogin,
                            variant: AppButtonVariant.primary,
                            size: AppButtonSize.large,
                            trailingIcon: const Icon(Icons.arrow_forward_rounded, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ),

                  AppSpacing.vGap24,

                  // Help & Support Link
                  Center(
                    child: Text(
                      'Need assistance? Contact Partner Support',
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
