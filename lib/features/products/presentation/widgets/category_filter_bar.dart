import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../controllers/product_controller.dart';

/// Category Horizontal Filter Bar matching Stitch brief (`products_2x2_grid_view/code.html`)
class CategoryFilterBar extends StatelessWidget {
  final List<CategoryFilterItem> categories;
  final String selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedCategoryId == cat.id;

          return InkWell(
            onTap: () => onCategorySelected(cat.id),
            borderRadius: AppRadius.full,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : colors.surface,
                borderRadius: AppRadius.full,
                border: Border.all(
                  color: isSelected ? colors.primary : colors.borderSubtle,
                  width: 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.25),
                          offset: const Offset(0, 3),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cat.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : colors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  if (cat.itemCount > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white.withValues(alpha: 0.22) : colors.surfaceSubtle,
                        borderRadius: AppRadius.full,
                      ),
                      child: Text(
                        '${cat.itemCount}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: isSelected ? Colors.white : colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
