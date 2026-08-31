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
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. "+ Add Product" Solid Black Pill
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.addProduct);
            },
            borderRadius: AppRadius.full,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              decoration: BoxDecoration(
                color: colors.ctaPrimary,
                borderRadius: AppRadius.full,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, size: 18, color: colors.ctaPrimaryText),
                  const SizedBox(width: 6),
                  Text(
                    'Add Product',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: colors.ctaPrimaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // 2. "View Products" Outlined Pill
          InkWell(
            onTap: () => onNavigateTab?.call(2),
            borderRadius: AppRadius.full,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppRadius.full,
                border: Border.all(color: colors.borderSubtle, width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 17, color: colors.textPrimary),
                  const SizedBox(width: 6),
                  Text(
                    'View Products',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // 3. "Categories" Outlined Pill
          InkWell(
            onTap: () => onNavigateTab?.call(2),
            borderRadius: AppRadius.full,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppRadius.full,
                border: Border.all(color: colors.borderSubtle, width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.category_outlined, size: 17, color: colors.textPrimary),
                  const SizedBox(width: 6),
                  Text(
                    'Categories',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // 4. "Orders" Outlined Pill
          InkWell(
            onTap: () => onNavigateTab?.call(1),
            borderRadius: AppRadius.full,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppRadius.full,
                border: Border.all(color: colors.borderSubtle, width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 17, color: colors.textPrimary),
                  const SizedBox(width: 6),
                  Text(
                    'All Orders',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
