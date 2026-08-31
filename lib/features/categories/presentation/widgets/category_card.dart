import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/components/app_card.dart';
import '../../domain/models/category_model.dart';

// Category Item Card with Name, Description, and Item Count Badge
class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AppCard(
      onTap: onTap ?? onEdit,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Icon Leading Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: AppRadius.md,
                ),
                child: Icon(
                  Icons.category_outlined,
                  color: colors.primary,
                  size: 22,
                ),
              ),

              AppSpacing.hGap12,

              // Category Name & Item Count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.name,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                        // Item Count Pill Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surfaceSubtle,
                            borderRadius: AppRadius.full,
                            border: Border.all(
                              color: colors.borderSubtle,
                            ),
                          ),
                          child: Text(
                            '${category.itemCount} ${category.itemCount == 1 ? 'Item' : 'Items'}',
                            style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (category.description.isNotEmpty) ...[
                      AppSpacing.vGap4,
                      Text(
                        category.description,
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          AppSpacing.vGap12,

          // Divider
          Divider(
            height: 1,
            color: colors.divider,
          ),

          AppSpacing.vGap8,

          // Action Buttons Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: colors.textPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  textStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              AppSpacing.hGap4,
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded, size: 16),
                label: const Text('Delete'),
                style: TextButton.styleFrom(
                  foregroundColor: colors.error,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  textStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
