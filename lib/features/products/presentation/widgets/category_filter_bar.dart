import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../controllers/product_controller.dart';

// Category Horizontal Filter Bar with Item Counts
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
      height: 40,
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.ctaPrimary
                    : colors.surface,
                borderRadius: AppRadius.full,
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : colors.borderSubtle,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cat.name,
                    style: AppTypography.labelMedium.copyWith(
                      color: isSelected
                          ? colors.ctaPrimaryText
                          : colors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.ctaPrimaryText.withValues(alpha: 0.2)
                          : colors.surfaceSubtle,
                      borderRadius: AppRadius.full,
                    ),
                    child: Text(
                      '${cat.itemCount}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? colors.ctaPrimaryText
                            : colors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
