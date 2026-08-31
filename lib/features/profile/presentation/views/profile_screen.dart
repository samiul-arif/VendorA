import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/components/app_dialog.dart';
import '../../../../shared/components/app_card.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/settings_group_card.dart';
import '../widgets/theme_mode_toggle_tile.dart';
import 'edit_profile_screen.dart';
import 'bank_payout_screen.dart';
import 'shop_settings_screen.dart';

// Vendor Profile & Global App Settings Screen (Tab 4 in MainShellScreen)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      title: 'Log Out of Merchant Account',
      message: 'Are you sure you want to log out? You will need your credentials to sign in again.',
      confirmText: 'Log Out',
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authController = context.watch<AuthController>();
    final vendor = authController.vendor;
    final activeShop = authController.activeShop;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
      appBar: AppBar(
        title: const Text('Vendor Profile & Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Log Out',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          children: [
            // Profile Header
            ProfileHeaderCard(
              vendor: vendor,
              activeShop: activeShop,
              onEditTapped: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
            ),

            AppSpacing.vGap20,

            // Appearance & Interface
            Text(
              'APPEARANCE & INTERFACE',
              style: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
            AppSpacing.vGap8,
            const AppCard(
              padding: EdgeInsets.zero,
              child: ThemeModeToggleTile(),
            ),

            AppSpacing.vGap20,

            // Store & Operations Group
            SettingsGroupCard(
              title: 'Store Operations',
              items: [
                SettingsTileItem(
                  icon: Icons.storefront_rounded,
                  iconColor: AppColors.primary,
                  title: 'Store Preferences & Hours',
                  subtitle: 'Operating schedule, minimum order, auto-accept',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ShopSettingsScreen()),
                    );
                  },
                ),
                SettingsTileItem(
                  icon: Icons.account_balance_rounded,
                  iconColor: const Color(0xFF10B981),
                  title: 'Bank & Payout Account',
                  subtitle: 'Weekly settlement bank details & history',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const BankPayoutScreen()),
                    );
                  },
                ),
                SettingsTileItem(
                  icon: Icons.restaurant_menu_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  title: 'Manage Menu Items',
                  subtitle: 'Dishes, stock quantities & prices',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.products);
                  },
                ),
              ],
            ),

            AppSpacing.vGap20,

            // Support & About
            SettingsGroupCard(
              title: 'Support & System',
              items: [
                SettingsTileItem(
                  icon: Icons.support_agent_rounded,
                  iconColor: const Color(0xFF3B82F6),
                  title: 'Merchant Support Hotline',
                  subtitle: '24/7 dedicated partner assistance',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contacting merchant partner support desk...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                SettingsTileItem(
                  icon: Icons.shield_outlined,
                  iconColor: const Color(0xFF8B5CF6),
                  title: 'Privacy Policy & Terms',
                  subtitle: 'Legal and food safety compliance',
                  onTap: () {},
                ),
                SettingsTileItem(
                  icon: Icons.info_outline_rounded,
                  iconColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  title: 'App Version',
                  trailing: Text(
                    'v1.0.0 (Build 240)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                ),
                SettingsTileItem(
                  icon: Icons.logout_rounded,
                  iconColor: AppColors.statusError,
                  title: 'Sign Out',
                  isDestructive: true,
                  onTap: _handleLogout,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
