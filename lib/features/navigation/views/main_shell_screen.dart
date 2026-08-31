import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/components/app_card.dart';
import '../../../shared/components/stat_card.dart';
import '../../../shared/components/status_badge.dart';
import '../../../shared/components/app_switch.dart';
import '../../dashboard/presentation/views/dashboard_screen.dart';
import '../../products/presentation/views/product_list_screen.dart';
import '../widgets/floating_nav_bar.dart';

// Main Application Navigation Shell
class MainShellScreen extends StatefulWidget {
  final int initialIndex;

  const MainShellScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<NavItem> _navItems = const [
    NavItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard_rounded,
      label: 'Home',
    ),
    NavItem(
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long_rounded,
      label: 'Orders',
      badgeCount: 3, // Mock active incoming orders count
    ),
    NavItem(
      icon: Icons.restaurant_menu_outlined,
      selectedIcon: Icons.restaurant_menu_rounded,
      label: 'Products',
    ),
    NavItem(
      icon: Icons.storefront_outlined,
      selectedIcon: Icons.storefront_rounded,
      label: 'Shop',
    ),
    NavItem(
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
      body: Stack(
        children: [
          // Indexed Tab Stack
          IndexedStack(
            index: _currentIndex,
            children: [
              // Tab 0: Real Dashboard Screen
              DashboardScreen(
                onNavigateTab: (index) => setState(() => _currentIndex = index),
              ),

              // Tab 1: Orders Tab Placeholder
              _TabPlaceholder(
                title: 'Order Management',
                subtitle: 'Manage active, completed, and incoming customer orders.',
                icon: Icons.receipt_long_rounded,
                accentColor: AppColors.secondary,
              ),

              // Tab 2: Real Product Catalog & Inventory Screen
              const ProductListScreen(),

              // Tab 3: Shop Settings Placeholder
              _TabPlaceholder(
                title: 'Shop Settings',
                subtitle: 'Manage store hours, open/close toggle, and delivery radius.',
                icon: Icons.storefront_rounded,
                accentColor: AppColors.statusWarning,
              ),

              // Tab 4: Vendor Profile Placeholder
              _TabPlaceholder(
                title: 'Vendor Profile',
                subtitle: 'Account preferences, business details, and secure logout.',
                icon: Icons.person_rounded,
                accentColor: AppColors.primary,
              ),
            ],
          ),

          // Floating Pill Bottom Navigation Dock (modern_ui_arif)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingNavBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              items: _navItems,
            ),
          ),
        ],
      ),
    );
  }
}

// Scaffolding Tab View Placeholder
class _TabPlaceholder extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const _TabPlaceholder({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  @override
  State<_TabPlaceholder> createState() => _TabPlaceholderState();
}

class _TabPlaceholderState extends State<_TabPlaceholder> {
  bool _isShopOpen = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: AppTypography.headlineMedium.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  AppSpacing.vGap4,
                  Text(
                    'Vendor Partner Merchant App',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
              StatusBadge(
                type: _isShopOpen ? BadgeType.open : BadgeType.closed,
                label: _isShopOpen ? 'Shop Open' : 'Shop Closed',
              ),
            ],
          ),

          AppSpacing.vGap20,

          AppCard(
            gradient: isDark ? AppColors.darkCardGradient : null,
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(widget.icon, size: 26, color: widget.accentColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: AppTypography.titleMedium.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      AppSpacing.vGap4,
                      Text(
                        widget.subtitle,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
