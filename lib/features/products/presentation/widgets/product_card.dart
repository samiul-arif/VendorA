import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_card.dart';
import '../../domain/models/product_model.dart';

// Product Card (arif.html Styled 2-Column Grid Item)
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
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container with Floating Badges & Edit Action
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  height: 100,
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
                            size: 32,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                      ),

                      // Popular Badge Top-Left
                      if (isPopular)
                        Positioned(
                          top: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.75),
                              borderRadius: AppRadius.full,
                            ),
                            child: const Text(
                              'Popular',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),

                      // Edit Circular Button Top-Right
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: onEditTapped,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.edit_rounded,
                                size: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Stock Quantity Pill Bottom-Right
                      Positioned(
                        bottom: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Title (Tap to edit)
              GestureDetector(
                onTap: onEditTapped,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.description.isNotEmpty ? product.description : 'Fresh kitchen specialty',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 10,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Footer: Price & 1-Tap Quick Stock Toggle
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price in Foodie Pink (#E21B70)
                Text(
                  Formatters.formatCurrency(product.price),
                  style: const TextStyle(
                    fontSize: 13,
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
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
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: isSoldOut ? AppColors.statusError : const Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isSoldOut ? 'Sold Out' : 'In Stock',
                          style: TextStyle(
                            fontSize: 9,
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
          ),
        ],
      ),
    );
  }
}
