import 'package:flutter/material.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';

/// Horizontal Quick Action Chips matching Stitch brief (`dashboard/code.html`)
class QuickActionsBar extends StatelessWidget {
  final ValueChanged<int>? onNavigateTab;

  const QuickActionsBar({
    super.key,
    this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          // 1. "+ Add Product" Solid Black Pill
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.addProduct);
            },
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add Product'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.ctaPrimary,
              foregroundColor: colors.ctaPrimaryText,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
              elevation: 0,
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // 2. "View Products" Outlined Pill
          OutlinedButton.icon(
            onPressed: () {
              onNavigateTab?.call(2); // Products tab
            },
            icon: Icon(Icons.inventory_2_outlined, size: 17, color: colors.textPrimary),
            label: Text(
              'View Products',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: colors.surface,
              side: BorderSide(color: colors.borderSubtle, width: 1.2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
            ),
          ),

          const SizedBox(width: 10),

          // 3. "Categories" Outlined Pill
          OutlinedButton.icon(
            onPressed: () {
              onNavigateTab?.call(2); // Products tab with category selection
            },
            icon: Icon(Icons.category_outlined, size: 17, color: colors.textPrimary),
            label: Text(
              'Categories',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: colors.surface,
              side: BorderSide(color: colors.borderSubtle, width: 1.2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
            ),
          ),

          const SizedBox(width: 10),

          // 4. "Orders" Outlined Pill
          OutlinedButton.icon(
            onPressed: () {
              onNavigateTab?.call(1); // Orders tab
            },
            icon: Icon(Icons.receipt_long_outlined, size: 17, color: colors.textPrimary),
            label: Text(
              'All Orders',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: colors.surface,
              side: BorderSide(color: colors.borderSubtle, width: 1.2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
            ),
          ),
        ],
      ),
    );
  }
}
