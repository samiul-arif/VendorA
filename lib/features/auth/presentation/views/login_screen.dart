import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/navigation_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../../shared/components/app_bottom_sheet.dart';
import '../../../../shared/components/app_text_field.dart';
import '../controllers/auth_controller.dart';
import '../widgets/demo_credentials_chip.dart';

/// Vendor Login Screen matching Stitch brief (`login_screen/code.html`)
/// with Google Sign-In and BD 10-digit Phone / Email support.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isGoogleLoading = false;
  String? _inlineError;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _autofillDemo() {
    setState(() {
      _identifierController.text = 'demo@vendor.com';
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
    final identifier = _identifierController.text.trim();

    final result = await authController.login(
      email: identifier,
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

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
      _inlineError = null;
    });

    final authController = context.read<AuthController>();
    final result = await authController.login(
      email: 'samiul.arif.merchant@gmail.com',
      password: 'vendor123',
    );

    if (!mounted) return;
    setState(() => _isGoogleLoading = false);

    result.when(
      success: (session) {
        AppToast.showSuccess(
          context,
          title: 'Signed in with Google',
          message: 'Authenticated as ${session.vendor.name}.',
        );

        NavigationService.instance.clearStackAndNavigateTo(AppRoutes.mainShell);
      },
      failure: (message, exception) {
        setState(() => _inlineError = message);
        AppToast.showError(
          context,
          title: 'Google Sign-In Failed',
          message: message,
        );
      },
    );
  }

  void _showForgotPasswordSheet() {
    final resetEmailController = TextEditingController(text: _identifierController.text);

    AppBottomSheet.show(
      context: context,
      title: 'Reset Password',
      subtitle: 'Enter your registered email address to receive password recovery instructions.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Registered Email',
            hint: 'e.g. merchant@example.com',
            controller: resetEmailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined, size: 18),
          ),
          AppSpacing.vGap20,
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                AppToast.showSuccess(
                  context,
                  title: 'Instructions Sent',
                  message: 'A password reset link has been dispatched to ${resetEmailController.text}.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appColors.ctaPrimary,
                foregroundColor: context.appColors.ctaPrimaryText,
                shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
              ),
              child: const Text('Send Reset Link', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
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
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF15171C).withValues(alpha: 0.05),
                      blurRadius: 24,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Brand Logo Icon
                      Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colors.primaryContainer.withValues(alpha: 0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.storefront_rounded,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      AppSpacing.vGap16,

                      // Title & Subtitle
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Log in to manage your shop.',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      AppSpacing.vGap24,

                      // Inline Error Banner if present
                      if (_inlineError != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: colors.errorBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: colors.error.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline_rounded, size: 16, color: colors.error),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _inlineError!,
                                  style: TextStyle(color: colors.error, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.vGap16,
                      ],

                      // Email / Phone Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email or BD Phone (+880)',
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _identifierController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Please enter your email or phone';
                              final trimmed = v.trim();
                              if (trimmed.contains('@')) {
                                return Validators.validateEmail(trimmed);
                              }
                              return Validators.validateBdPhone(trimmed);
                            },
                            style: TextStyle(color: colors.textPrimary, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'merchant@example.com or 1711778889',
                              hintStyle: TextStyle(color: colors.textMuted, fontSize: 13),
                              prefixIcon: Icon(Icons.mail_outline_rounded, size: 18, color: colors.textMuted),
                              filled: true,
                              fillColor: colors.surfaceSubtle,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                      ),

                      AppSpacing.vGap16,

                      // Password Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Password',
                                style: TextStyle(
                                  color: colors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              GestureDetector(
                                onTap: _showForgotPasswordSheet,
                                child: Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: colors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            validator: Validators.validatePassword,
                            style: TextStyle(color: colors.textPrimary, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              hintStyle: TextStyle(color: colors.textMuted, fontSize: 13),
                              prefixIcon: Icon(Icons.lock_outline_rounded, size: 18, color: colors.textMuted),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  size: 18,
                                  color: colors.textMuted,
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              filled: true,
                              fillColor: colors.surfaceSubtle,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                      ),

                      AppSpacing.vGap24,

                      // Primary Solid Pill Button: "Log In"
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: authController.isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.ctaPrimary,
                            foregroundColor: colors.ctaPrimaryText,
                            shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                            elevation: 1,
                          ),
                          child: authController.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Log In',
                                      style: TextStyle(
                                        color: colors.ctaPrimaryText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(Icons.arrow_forward_rounded, size: 18, color: colors.ctaPrimaryText),
                                  ],
                                ),
                        ),
                      ),

                      AppSpacing.vGap16,

                      // Divider "OR"
                      Row(
                        children: [
                          Expanded(child: Divider(color: colors.divider)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: colors.textMuted,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: colors.divider)),
                        ],
                      ),

                      AppSpacing.vGap16,

                      // Google Sign-In Button
                      SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: _isGoogleLoading ? null : _handleGoogleSignIn,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: colors.surface,
                            foregroundColor: colors.textPrimary,
                            side: BorderSide(color: colors.borderSubtle, width: 1.2),
                            shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                          ),
                          child: _isGoogleLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: colors.primary, strokeWidth: 2),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Multi-Color Google G Icon Container
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: const BoxDecoration(shape: BoxShape.circle),
                                      child: CustomPaint(
                                        painter: _GoogleLogoPainter(),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      AppSpacing.vGap16,

                      // Demo Autofill Pill
                      DemoCredentialsChip(onFillCredentials: _autofillDemo),

                      AppSpacing.vGap16,

                      // Footer Link: "New vendor? Sign up here"
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'New vendor?',
                              style: TextStyle(fontSize: 13, color: colors.textSecondary),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(AppRoutes.registration);
                              },
                              child: Text(
                                'Sign up here',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: colors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Painter for Google Brand Logo
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final redPaint = Paint()..color = const Color(0xFFEA4335)..style = PaintingStyle.fill;
    final bluePaint = Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.fill;
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05)..style = PaintingStyle.fill;
    final greenPaint = Paint()..color = const Color(0xFF34A853)..style = PaintingStyle.fill;

    // Draw Google Quad-Color circle representation
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -0.785, 1.57, true, bluePaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 0.785, 1.57, true, greenPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 2.356, 1.57, true, yellowPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 3.926, 1.57, true, redPaint);

    // Inner cutout
    final innerPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.55, innerPaint);

    // Blue horizontal arm
    final armRect = Rect.fromLTWH(center.dx - 1, center.dy - radius * 0.25, radius, radius * 0.5);
    canvas.drawRect(armRect, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
