import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/presentation/views/dashboard_screen.dart';
import '../../orders/presentation/views/order_list_screen.dart';
import '../../products/presentation/views/product_list_screen.dart';
import '../../profile/presentation/views/shop_settings_screen.dart';
import '../../profile/presentation/views/profile_screen.dart';
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
      badgeCount: 2, // Live active incoming orders count
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

              // Tab 1: Real Order Management Screen
              const OrderListScreen(),

              // Tab 2: Real Product Catalog & Inventory Screen
              const ProductListScreen(),

              // Tab 3: Real Shop Management Screen
              const ShopSettingsScreen(),

              // Tab 4: Real Vendor Profile & Settings Screen
              const ProfileScreen(),
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
