import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/components/app_card.dart';
import '../../../shared/components/stat_card.dart';
import '../../../shared/components/status_badge.dart';
import '../../../shared/components/app_switch.dart';
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
      badgeCount: 3, // Mock active orders count
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
              _TabPlaceholder(
                title: 'Dashboard Overview',
                subtitle: 'Real-time sales, order alerts, and business insights.',
                icon: Icons.analytics_outlined,
                accentColor: AppColors.primary,
              ),
              _TabPlaceholder(
                title: 'Order Management',
                subtitle: 'Manage active, completed, and incoming customer orders.',
                icon: Icons.receipt_long_rounded,
                accentColor: AppColors.secondary,
              ),
              _TabPlaceholder(
                title: 'Product Catalog',
                subtitle: 'Organize menu categories, items, and availability status.',
                icon: Icons.restaurant_menu_rounded,
                accentColor: AppColors.statusInfo,
              ),
              _TabPlaceholder(
                title: 'Shop Settings',
                subtitle: 'Manage store hours, open/close toggle, and delivery radius.',
                icon: Icons.storefront_rounded,
                accentColor: AppColors.statusWarning,
              ),
              _TabPlaceholder(
                title: 'Vendor Profile',
                subtitle: 'Account preferences, business details, and secure logout.',
                icon: Icons.person_rounded,
                accentColor: AppColors.primary,
              ),
            ],
          ),

          // Floating Pill Bottom Navigation Dock
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

// Scaffolding Tab View Demonstration
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
          // Header Bar
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

          // Feature Demo Card
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

          AppSpacing.vGap16,

          // Quick Demo Controls
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Store Status',
                  style: AppTypography.titleSmall.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.vGap12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isShopOpen ? 'Accepting Customer Orders' : 'Store Currently Paused',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    AppSwitch(
                      value: _isShopOpen,
                      onChanged: (val) => setState(() => _isShopOpen = val),
                    ),
                  ],
                ),
              ],
            ),
          ),

          AppSpacing.vGap16,

          // Metric Card Demonstration Grid
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: "Today's Sales",
                  value: '\$1,420.50',
                  trendText: '+12.4%',
                  isTrendPositive: true,
                  icon: Icons.attach_money_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Active Orders',
                  value: '18',
                  trendText: '+3 new',
                  isTrendPositive: true,
                  icon: Icons.shopping_bag_outlined,
                  iconColor: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
