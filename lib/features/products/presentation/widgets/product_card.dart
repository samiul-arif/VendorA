import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/product_model.dart';

/// Product Card strictly matching Stitch 2x2 Grid brief (`products_2x2_grid_view/code.html`)
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
    final colors = context.appColors;
    final isDark = context.isDark;
    final isSoldOut = !product.isAvailable || product.stockQuantity == 0;

    return GestureDetector(
      onTap: onEditTapped,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.md,
          border: Border.all(color: colors.borderSubtle),
          boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Aspect Square with Edit Button & Stock Chip
            AspectRatio(
              aspectRatio: 1.05,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image / Placeholder
                  Container(
                    color: colors.surfaceLow,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      color: isSoldOut ? Colors.grey.withValues(alpha: 0.7) : null,
                      colorBlendMode: isSoldOut ? BlendMode.saturation : null,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(
                          Icons.restaurant_rounded,
                          size: 32,
                          color: colors.textMuted,
                        ),
                      ),
                    ),
                  ),

                  // Floating Edit Button Top-Right
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: onEditTapped,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: colors.surface.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1F000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 14,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ),

                  // Stock Chip Bottom-Left
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: GestureDetector(
                      onTap: onRestockTapped,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: isSoldOut
                              ? colors.error.withValues(alpha: 0.92)
                              : colors.surface.withValues(alpha: 0.92),
                          borderRadius: AppRadius.xs,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          isSoldOut ? 'Sold out' : '${product.stockQuantity} in stock',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isSoldOut ? colors.textInverse : colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details (Title & Price)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.titleSmall.copyWith(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: isSoldOut ? colors.textMuted : colors.textPrimary,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.vGap4,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Formatters.formatCurrency(product.price),
                        style: AppTypography.titleSmall.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: isSoldOut ? colors.textMuted : colors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => onToggleAvailability(!product.isAvailable),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: product.isAvailable && product.stockQuantity > 0
                                ? colors.secondary
                                : colors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
