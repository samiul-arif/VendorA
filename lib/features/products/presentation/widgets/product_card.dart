import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_card.dart';
import '../../domain/models/product_model.dart';

// Product Card (Refined High-Density Grid Item matching arif.html visual rhythm)
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
    final isPopular = product.isPopular;

    return AppCard(
      padding: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Product Image with Badges & Edit Button (Taller 98px area)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: 98,
              color: colors.surfaceSubtle,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    color: isSoldOut ? Colors.grey.withValues(alpha: 0.7) : null,
                    colorBlendMode: isSoldOut ? BlendMode.saturation : null,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.restaurant_rounded,
                        size: 24,
                        color: colors.textMuted,
                      ),
                    ),
                  ),

                  // Popular Badge
                  if (isPopular)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: AppRadius.full,
                        ),
                        child: const Text(
                          'Popular',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                  // Edit Circular Button Top-Right
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: onEditTapped,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.edit_rounded,
                            size: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Stock Quantity Pill Bottom-Right
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: isSoldOut
                            ? colors.error
                            : Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isSoldOut ? 'Sold Out' : 'Qty: ${product.stockQuantity}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Title & Description
          GestureDetector(
            onTap: onEditTapped,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  product.description.isNotEmpty ? product.description : 'Fresh kitchen specialty',
                  style: TextStyle(
                    fontSize: 9.5,
                    color: colors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Spacing before divider to improve description breathing room
          const SizedBox(height: 6),

          // Subtle Horizontal Separator
          Divider(
            height: 1,
            thickness: 0.8,
            color: colors.divider,
          ),

          const SizedBox(height: 6),

          // Footer: Price & Stock Status Badge (Clean & Compact)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Formatters.formatCurrency(product.price),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: colors.primary,
                ),
              ),
              GestureDetector(
                onTap: () => onToggleAvailability(!product.isAvailable),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSoldOut
                        ? colors.errorBg
                        : colors.successBg,
                    borderRadius: AppRadius.full,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isSoldOut ? colors.error : colors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        isSoldOut ? 'Sold Out' : 'In Stock',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: isSoldOut ? colors.error : colors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
