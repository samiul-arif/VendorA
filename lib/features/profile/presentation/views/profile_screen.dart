import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/components/app_dialog.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/profile_controller.dart';
import '../widgets/profile_header_card.dart';
import 'bank_payout_screen.dart';

/// Vendor Profile & Settings Screen strictly matching Stitch brief (`settings/code.html` & `vendor_profile_with_account_settings_link/code.html`)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;

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
    final isDark = context.isDark;
    final authController = context.watch<AuthController>();
    final profileController = context.watch<ProfileController>();
    final vendor = authController.vendor;
    final isDarkMode = profileController.isDarkMode;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.borderSubtle,
                  width: 1.2,
                ),
              ),
              child: Icon(
                Icons.person_rounded,
                size: 20,
                color: colors.primary,
              ),
            ),
          ),
        ),
        title: Text(
          'Profile',
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
            icon: Icon(
              Icons.notifications_outlined,
              color: colors.textPrimary,
              size: 24,
            ),
          ),
          AppSpacing.hGap8,
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 120),
          children: [
            // 1. Profile Overview Hero Card (Bento Style with Avatar, Name, Phone & Address)
            ProfileHeaderCard(
              vendor: vendor,
              onEditTapped: () {
                Navigator.of(context).pushNamed(AppRoutes.editProfile);
              },
            ),

            AppSpacing.vGap24,

            // 2. Account Section (No shop management)
            _buildSectionHeader('ACCOUNT', colors),
            AppSpacing.vGap8,
            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppRadius.lg,
                border: Border.all(color: colors.borderSubtle),
                boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _buildNavTile(
                    icon: Icons.person_outline_rounded,
                    iconBg: colors.primary.withValues(alpha: 0.12),
                    iconColor: colors.primary,
                    title: 'Profile Details',
                    subtitle: 'Update your personal information',
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.editProfile);
                    },
                    colors: colors,
                  ),
                  _buildDivider(colors),
                  _buildNavTile(
                    icon: Icons.analytics_outlined,
                    iconBg: colors.surfaceLow,
                    iconColor: colors.primary,
                    title: 'Analytics & Reports',
                    subtitle: 'View performance and sales data',
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.analytics);
                    },
                    colors: colors,
                  ),
                  _buildDivider(colors),
                  _buildNavTile(
                    icon: Icons.lock_outline_rounded,
                    iconBg: colors.surfaceLow,
                    iconColor: colors.primary,
                    title: 'Change Password',
                    subtitle: 'Manage account password & security',
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.changePassword);
                    },
                    colors: colors,
                  ),
                  _buildDivider(colors),
                  _buildNavTile(
                    icon: Icons.account_balance_rounded,
                    iconBg: colors.surfaceLow,
                    iconColor: colors.secondary,
                    title: 'Bank & Payout Account',
                    subtitle: 'Manage revenue withdrawal methods',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BankPayoutScreen()),
                      );
                    },
                    colors: colors,
                  ),
                ],
              ),
            ),

            AppSpacing.vGap24,

            // 3. Preferences Section
            _buildSectionHeader('PREFERENCES', colors),
            AppSpacing.vGap8,
            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppRadius.lg,
                border: Border.all(color: colors.borderSubtle),
                boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _buildSwitchTile(
                    icon: Icons.notifications_active_outlined,
                    title: 'Push Notifications',
                    subtitle: 'Receive alerts for new orders',
                    value: _pushNotifications,
                    onChanged: (val) {
                      setState(() => _pushNotifications = val);
                      AppToast.showSuccess(
                        context,
                        title: val ? 'Notifications Enabled' : 'Notifications Muted',
                        message: val ? 'Live push alerts are active.' : 'Order push alerts are silenced.',
                      );
                    },
                    colors: colors,
                  ),
                  _buildDivider(colors),
                  _buildSwitchTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    subtitle: 'Switch to dark theme appearance',
                    value: isDarkMode,
                    onChanged: (val) {
                      profileController.toggleDarkMode(val);
                      AppToast.showInfo(
                        context,
                        title: val ? 'Dark Theme Activated' : 'Light Theme Activated',
                        message: val ? 'App theme set to dark mode.' : 'App theme set to light mode.',
                      );
                    },
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
                borderRadius: AppRadius.lg,
                border: Border.all(color: colors.borderSubtle),
                boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _buildNavTile(
                    icon: Icons.help_outline_rounded,
                    iconBg: colors.surfaceLow,
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
                    iconBg: colors.surfaceLow,
                    iconColor: colors.textPrimary,
                    title: 'Privacy Policy',
                    subtitle: 'How we manage merchant and order data',
                    onTap: () {
                      AppToast.showInfo(
                        context,
                        title: 'Privacy Policy',
                        message: 'Opening Merchant Privacy Policy...',
                      );
                    },
                    colors: colors,
                  ),
                  _buildDivider(colors),
                  _buildNavTile(
                    icon: Icons.description_outlined,
                    iconBg: colors.surfaceLow,
                    iconColor: colors.textPrimary,
                    title: 'Terms of Service',
                    subtitle: 'Merchant marketplace terms & conditions',
                    onTap: () {
                      AppToast.showInfo(
                        context,
                        title: 'Terms of Service',
                        message: 'Opening Terms & Conditions...',
                      );
                    },
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
                  style: AppTypography.labelLarge.copyWith(
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
                style: AppTypography.labelSmall.copyWith(
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
        style: AppTypography.labelSmall.copyWith(
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
            AppSpacing.hGap14,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleSmall.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                  ),
                  AppSpacing.vGap2,
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
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
              color: colors.surfaceLow,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: colors.textPrimary),
          ),
          AppSpacing.hGap14,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                AppSpacing.vGap2,
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
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
              activeThumbColor: colors.secondary,
              activeTrackColor: colors.secondary.withValues(alpha: 0.35),
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
