import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/app_switch.dart';
import '../../domain/models/product_model.dart';

// 2-Column Product Grid Card (modern_ui_arif Standard)
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final ValueChanged<bool> onToggleAvailability;
  final VoidCallback onRestockTapped;
  final VoidCallback onEditTapped;

  const ProductCard({
    super.key,
    required this.product,
    required this.onToggleAvailability,
    required this.onRestockTapped,
    required this.onEditTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isOutOfStock = product.isOutOfStock;
    final isLowStock = product.isLowStock;
    final isAvailable = product.isEffectiveAvailable;

    return AppCard(
      padding: const EdgeInsets.all(12),
      onTap: onEditTapped,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container with Badges
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isDark ? const Color(0xFF232A34) : const Color(0xFFF3F4F6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.fastfood_rounded,
                        size: 36,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                  ),
                ),
              ),

              // Popular / Discount Pill Badge
              if (product.isPopular)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.full,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          offset: const Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Text(
                      'Popular',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

              // Out of Stock Overlay Pill
              if (isOutOfStock)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.statusError,
                      borderRadius: AppRadius.full,
                    ),
                    child: Text(
                      'Out of Stock',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                )
              else if (isLowStock)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.statusWarning,
                      borderRadius: AppRadius.full,
                    ),
                    child: Text(
                      'Low: ${product.stockQuantity} left',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          AppSpacing.vGap10,

          // Product Name & Category
          Text(
            product.name,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          Text(
            product.categoryName,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          AppSpacing.vGap8,

          // Price & Stock Count Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    Formatters.formatCurrency(product.price),
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (product.originalPrice != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      Formatters.formatCurrency(product.originalPrice!),
                      style: AppTypography.bodySmall.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),

              // Quick Restock Button Trigger
              GestureDetector(
                onTap: onRestockTapped,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF232A34) : AppColors.borderLight,
                    borderRadius: AppRadius.sm,
                  ),
                  child: Text(
                    '+${product.stockQuantity}',
                    style: AppTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.inkPrimary,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.vGap8,

          // Divider
          Container(
            height: 1,
            color: isDark ? const Color(0xFF2D3748) : const Color(0xFFF3F4F6),
          ),

          AppSpacing.vGap8,

          // Availability Switch Row (Offline Store Sync)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isAvailable ? 'Available' : 'Paused',
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isAvailable ? AppColors.statusSuccess : AppColors.statusError,
                  fontSize: 11,
                ),
              ),
              AppSwitch(
                value: isAvailable,
                onChanged: onToggleAvailability,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
