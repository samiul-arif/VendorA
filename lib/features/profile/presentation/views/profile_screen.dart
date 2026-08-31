import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/components/app_dialog.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/profile_controller.dart';
import '../widgets/profile_header_card.dart';
import 'edit_profile_screen.dart';
import 'shop_settings_screen.dart';
import 'bank_payout_screen.dart';

/// Vendor Profile & Settings Screen matching Stitch brief (`settings/code.html` & `vendor_profile_with_account_settings_link/code.html`)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;
  bool _darkMode = false;
  bool _biometricLogin = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = context.read<AuthController>();
      final vendorId = authController.vendor?.id ?? 'vendor_001';
      final shopId = authController.activeShop?.id ?? 'shop_01';
      context.read<ProfileController>().loadProfileSettings(shopId: shopId, vendorId: vendorId);
    });
  }

  void _handleLogout() async {
    final confirmed = await AppDialog.showConfirmation(
      context: context,
      title: 'Sign Out of Merchant Account',
      message: 'Are you sure you want to sign out? You will need your credentials to access your store portal again.',
      confirmText: 'Sign Out',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      final authController = context.read<AuthController>();
      await authController.logout();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final authController = context.watch<AuthController>();
    final vendor = authController.vendor;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 120),
          children: [
            // Page Header: "Settings" + Subtitle
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: colors.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Manage your app-level preferences and account settings.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),

            AppSpacing.vGap16,

            // 1. Profile Overview Hero Card (Bento Style)
            ProfileHeaderCard(
              vendor: vendor,
              onEditTapped: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
            ),

            AppSpacing.vGap24,

            // 2. Account Section
            _buildSectionHeader('ACCOUNT', colors),
            AppSpacing.vGap8,
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
                children: [
                  _buildNavTile(
                    icon: Icons.person_outline_rounded,
                    iconBg: colors.primaryContainer.withValues(alpha: 0.15),
                    iconColor: colors.primary,
                    title: 'Profile Details',
                    subtitle: 'Update your personal information & contact',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                    },
                    colors: colors,
                  ),
                  _buildDivider(colors),
                  _buildNavTile(
                    icon: Icons.storefront_rounded,
                    iconBg: colors.surfaceSubtle,
                    iconColor: colors.textPrimary,
                    title: 'Shop Management',
                    subtitle: 'Manage storefront details, location & banner',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ShopSettingsScreen()),
                      );
                    },
                    colors: colors,
                  ),
                  _buildDivider(colors),
                  _buildNavTile(
                    icon: Icons.account_balance_rounded,
                    iconBg: colors.surfaceSubtle,
                    iconColor: const Color(0xFF006B57),
                    title: 'Bank & Payout Account',
                    subtitle: 'Manage revenue withdrawal methods',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BankPayoutScreen()),
                      );
                    },
                    colors: colors,
                  ),
                  _buildDivider(colors),
                  _buildNavTile(
                    icon: Icons.analytics_outlined,
                    iconBg: colors.surfaceSubtle,
                    iconColor: colors.primary,
                    title: 'Analytics & Reports',
                    subtitle: 'View performance and order metrics',
                    onTap: () {
                      AppToast.showInfo(
                        context,
                        title: 'Analytics & Reports',
                        message: 'Weekly earnings and metrics available on home dashboard.',
                      );
                    },
                    colors: colors,
                  ),
                ],
              ),
            ),

            AppSpacing.vGap24,

            // 3. Preferences Section (Switches matching Stitch)
            _buildSectionHeader('PREFERENCES', colors),
            AppSpacing.vGap8,
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
                children: [
                  _buildSwitchTile(
                    icon: Icons.notifications_active_outlined,
                    title: 'Push Notifications',
                    subtitle: 'Receive real-time alerts for incoming orders',
                    value: _pushNotifications,
                    onChanged: (val) => setState(() => _pushNotifications = val),
                    colors: colors,
                  ),
                  _buildDivider(colors),
                  _buildSwitchTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    subtitle: 'Switch to sleek dark theme appearance',
                    value: _darkMode,
                    onChanged: (val) => setState(() => _darkMode = val),
                    colors: colors,
                  ),
                  _buildDivider(colors),
                  _buildSwitchTile(
                    icon: Icons.fingerprint_rounded,
                    title: 'Biometric Login',
                    subtitle: 'Quick access via fingerprint or Face ID',
                    value: _biometricLogin,
                    onChanged: (val) => setState(() => _biometricLogin = val),
                    colors: colors,
                  ),
                ],
              ),
            ),

            AppSpacing.vGap24,

            // 4. Support & Legal Section
            _buildSectionHeader('SUPPORT & LEGAL', colors),
            AppSpacing.vGap8,
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
                children: [
                  _buildNavTile(
                    icon: Icons.help_outline_rounded,
                    iconBg: colors.surfaceSubtle,
                    iconColor: colors.textPrimary,
                    title: 'Help Center',
                    subtitle: 'Guides, FAQs, and live merchant chat',
                    onTap: () {
                      AppToast.showInfo(
                        context,
                        title: 'Help Center',
                        message: 'Opening partner support articles...',
                      );
                    },
                    colors: colors,
                  ),
                  _buildDivider(colors),
                  _buildNavTile(
                    icon: Icons.policy_outlined,
                    iconBg: colors.surfaceSubtle,
                    iconColor: colors.textPrimary,
                    title: 'Privacy Policy',
                    subtitle: 'How we manage merchant and order data',
                    onTap: () {},
                    colors: colors,
                  ),
                  _buildDivider(colors),
                  _buildNavTile(
                    icon: Icons.description_outlined,
                    iconBg: colors.surfaceSubtle,
                    iconColor: colors.textPrimary,
                    title: 'Terms of Service',
                    subtitle: 'Merchant marketplace terms & conditions',
                    onTap: () {},
                    colors: colors,
                  ),
                ],
              ),
            ),

            AppSpacing.vGap24,

            // 5. Sign Out Button
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _handleLogout,
                icon: Icon(Icons.logout_rounded, size: 18, color: colors.error),
                label: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: colors.error,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.errorBg,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                ),
              ),
            ),

            AppSpacing.vGap20,

            // 6. App Version & Build
            Center(
              child: Text(
                'Lumina Vendor App v2.4.1 (Build 482)',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: colors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppSemanticColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w900,
          color: colors.primary,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required AppSemanticColors colors,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: colors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required AppSemanticColors colors,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colors.surfaceSubtle,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: colors.textPrimary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch.adaptive(
              value: value,
              activeThumbColor: const Color(0xFF006B57),
              activeTrackColor: const Color(0xFF75F9D6),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(AppSemanticColors colors) {
    return Divider(
      height: 1,
      thickness: 1,
      color: colors.borderSubtle,
      indent: 68,
    );
  }
}
