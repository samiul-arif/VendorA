import 'package:flutter/material.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/product_model.dart';

/// Product Card matching Stitch 2x2 Grid brief (`products_2x2_grid_view/code.html`)
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
    final isSoldOut = !product.isAvailable || product.stockQuantity == 0;

    return GestureDetector(
      onTap: onEditTapped,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF15171C).withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
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
                    color: colors.surfaceSubtle,
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
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

                  // Stock Chip Bottom-Left (Frosted Glass Effect matching Stitch HTML)
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: GestureDetector(
                      onTap: onRestockTapped,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: isSoldOut
                              ? colors.error.withValues(alpha: 0.9)
                              : colors.surface.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          isSoldOut ? 'Sold out' : '${product.stockQuantity} in stock',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isSoldOut ? Colors.white : colors.textPrimary,
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
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Formatters.formatCurrency(product.price),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: colors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => onToggleAvailability(!product.isAvailable),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: product.isAvailable && product.stockQuantity > 0
                                ? const Color(0xFF006B57)
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
