import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/components/app_dialog.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/settings_group_card.dart';
import '../widgets/theme_mode_toggle_tile.dart';
import 'edit_profile_screen.dart';
import 'bank_payout_screen.dart';
import 'shop_settings_screen.dart';

// Vendor Profile & Global App Settings Screen (Content-First Merchant Layout)
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
    final colors = context.appColors;
    final authController = context.watch<AuthController>();
    final notifController = context.watch<NotificationController>();
    final vendor = authController.vendor;
    final activeShop = authController.activeShop;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          children: [
            // Content-First Header (Scrollable Merchant Title)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vendor Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Merchant business details, payout account & preferences',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),

            AppSpacing.vGap16,

            // Profile Header Card
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
                color: colors.textMuted,
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
                  icon: Icons.notifications_active_rounded,
                  iconColor: colors.primary,
                  title: 'Notification Center',
                  trailing: notifController.unreadCount > 0
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: AppRadius.full,
                          ),
                          child: Text(
                            '${notifController.unreadCount} new',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        )
                      : null,
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.notifications);
                  },
                ),
                SettingsTileItem(
                  icon: Icons.storefront_rounded,
                  iconColor: const Color(0xFF6366F1),
                  title: 'Store Preference',
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
                  onTap: () {
                    AppToast.showInfo(
                      context,
                      title: 'Support Desk',
                      message: 'Connecting to priority merchant partner dispatch...',
                    );
                  },
                ),
                SettingsTileItem(
                  icon: Icons.security_rounded,
                  iconColor: const Color(0xFF10B981),
                  title: 'App Permissions & Privacy',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.permissions);
                  },
                ),
                SettingsTileItem(
                  icon: Icons.shield_outlined,
                  iconColor: const Color(0xFF8B5CF6),
                  title: 'Privacy Policy & Terms',
                  onTap: () {},
                ),
                SettingsTileItem(
                  icon: Icons.info_outline_rounded,
                  iconColor: colors.textMuted,
                  title: 'App Version',
                  trailing: Text(
                    'v1.0.0 (Build 240)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SettingsTileItem(
                  icon: Icons.logout_rounded,
                  iconColor: colors.error,
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
