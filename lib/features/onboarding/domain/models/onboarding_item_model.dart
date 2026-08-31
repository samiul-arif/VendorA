import 'package:flutter/material.dart';

/// Enum for distinctive interactive mock previews in onboarding slides
enum OnboardingPreviewType {
  orderDispatch,
  menuInventory,
  revenuePayouts,
  storeManagement,
}

/// Domain Model for Onboarding Feature Showcase Slides
class OnboardingItemModel {
  final String id;
  final String categoryTag;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final OnboardingPreviewType previewType;
  final List<String> keyBenefits;

  const OnboardingItemModel({
    required this.id,
    required this.categoryTag,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.previewType,
    required this.keyBenefits,
  });

  /// Default list of high-value merchant onboarding slides
  static List<OnboardingItemModel> get defaultSlides => [
        const OnboardingItemModel(
          id: 'slide_orders',
          categoryTag: 'LIVE DISPATCH',
          title: 'Accept & Dispatch Orders in Real-Time',
          subtitle:
              'Never miss a hungry customer. Get instant audible alerts, accept orders with 1 tap, and track couriers from kitchen to doorstep.',
          icon: Icons.electric_bolt_rounded,
          accentColor: Color(0xFFD70F64), // Foodie Pink Primary
          previewType: OnboardingPreviewType.orderDispatch,
          keyBenefits: [
            'Instant high-priority sound chime on incoming orders',
            'Full order customization & kitchen prep timers',
            'Live courier dispatch & assignment tracker',
          ],
        ),
        const OnboardingItemModel(
          id: 'slide_menu',
          categoryTag: 'MENU & INVENTORY',
          title: 'Total Kitchen & Catalog Control',
          subtitle:
              'Update dish availability on the fly. 1-tap stock-out prevents customer refunds, while camera upload makes listing new dishes effortless.',
          icon: Icons.restaurant_menu_rounded,
          accentColor: Color(0xFFF59E0B), // Warm Amber
          previewType: OnboardingPreviewType.menuInventory,
          keyBenefits: [
            '1-Tap instant stock-out & quick quantity restock',
            'Live camera & photo gallery dish image uploads',
            'Custom food categories & add-on modifier pricing',
          ],
        ),
        const OnboardingItemModel(
          id: 'slide_payouts',
          categoryTag: 'FINANCIAL INSIGHTS',
          title: 'Transparent Earnings & Instant Payouts',
          subtitle:
              'Track net sales, commission breakdowns, and automated bank settlements with enterprise-grade financial reporting.',
          icon: Icons.trending_up_rounded,
          accentColor: Color(0xFF10B981), // Vibrant Emerald
          previewType: OnboardingPreviewType.revenuePayouts,
          keyBenefits: [
            'Real-time gross revenue & net settlement ledger',
            'Itemized sales volume & peak hour heatmaps',
            'Direct automated deposits to verified bank accounts',
          ],
        ),
        const OnboardingItemModel(
          id: 'slide_store',
          categoryTag: 'STORE OPERATIONS',
          title: 'Multi-Shop & Smart Preferences',
          subtitle:
              'Switch between multiple kitchen branches, customize opening hours, toggle dark mode, and connect directly with partner support.',
          icon: Icons.storefront_rounded,
          accentColor: Color(0xFF6366F1), // Indigo Accent
          previewType: OnboardingPreviewType.storeManagement,
          keyBenefits: [
            'Seamless multi-outlet branch switching',
            'Granular operating hours & delivery radius controls',
            'Sleek dark & light theme modes for kitchen stations',
          ],
        ),
      ];
}
