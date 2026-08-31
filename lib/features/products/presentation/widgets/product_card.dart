import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_card.dart';
import '../../domain/models/product_model.dart';

// Product Card (arif.html Styled Compact 2-Column Grid Item with Divider)
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

    final isSoldOut = !product.isAvailable || product.stockQuantity == 0;
    final isPopular = product.isPopular;

    return AppCard(
      padding: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image Container with Floating Badges & Edit Action
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              height: 96,
              color: isDark ? const Color(0xFF232A34) : const Color(0xFFF3F4F6),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Product Image
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    color: isSoldOut ? Colors.grey.withValues(alpha: 0.7) : null,
                    colorBlendMode: isSoldOut ? BlendMode.saturation : null,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.restaurant_rounded,
                        size: 28,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                  ),

                  // Popular Badge Top-Left
                  if (isPopular)
                    Positioned(
                      top: 5,
                      left: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: AppRadius.full,
                        ),
                        child: const Text(
                          'Popular',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                  // Edit Circular Button Top-Right
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: onEditTapped,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.edit_rounded,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Stock Quantity Pill Bottom-Right
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: isSoldOut
                            ? AppColors.statusError
                            : Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isSoldOut ? 'Sold Out' : 'Qty: ${product.stockQuantity}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
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

          // Title (Tap to edit)
          GestureDetector(
            onTap: onEditTapped,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  product.description.isNotEmpty ? product.description : 'Fresh kitchen specialty',
                  style: TextStyle(
                    fontSize: 9.5,
                    color: isDark ? AppColors.textMutedDark : const Color(0xFF6B7280),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Horizontal Line Separator (arif.html Matching)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Divider(
              height: 1,
              thickness: 1,
              color: isDark ? AppColors.darkDivider : const Color(0xFFF3F4F6),
            ),
          ),

          // Footer: Price & 1-Tap Quick Stock Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Price in Foodie Pink (#E21B70)
              Text(
                Formatters.formatCurrency(product.price),
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),

              // 1-Tap In Stock / Sold Out Toggle Button
              GestureDetector(
                onTap: () {
                  onToggleAvailability(!product.isAvailable);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: isSoldOut
                        ? (isDark ? const Color(0xFF3B1414) : const Color(0xFFFEE2E2))
                        : (isDark ? const Color(0xFF0F3A2E) : const Color(0xFFD1FAE5)),
                    borderRadius: AppRadius.full,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 4.5,
                        height: 4.5,
                        decoration: BoxDecoration(
                          color: isSoldOut ? AppColors.statusError : const Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 3.5),
                      Text(
                        isSoldOut ? 'Sold Out' : 'In Stock',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          color: isSoldOut ? const Color(0xFFB91C1C) : const Color(0xFF047857),
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
