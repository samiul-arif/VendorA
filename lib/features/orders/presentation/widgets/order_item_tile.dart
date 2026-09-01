import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/order_item_model.dart';

// Order Item Line Tile for Receipt & Detail Breakdowns
class OrderItemTile extends StatelessWidget {
  final OrderItemModel item;
  final bool showDivider;

  const OrderItemTile({
    super.key,
    required this.item,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Thumbnail
              ClipRRect(
                borderRadius: AppRadius.sm,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colors.surfaceSubtle,
                    borderRadius: AppRadius.sm,
                    border: Border.all(color: colors.borderSubtle),
                  ),
                  child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                      ? Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(
                              Icons.fastfood_outlined,
                              size: 22,
                              color: colors.textMuted,
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.fastfood_outlined,
                            size: 22,
                            color: colors.textMuted,
                          ),
                        ),
                ),
              ),

              AppSpacing.hGap12,

              // Product Info & Price Breakdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.12),
                            borderRadius: AppRadius.xs,
                            border: Border.all(
                              color: colors.primary.withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Qty: ${item.quantity}',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: colors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${Formatters.formatCurrency(item.unitPrice)} each',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    if (item.selectedAddons.isNotEmpty) ...[
                      AppSpacing.vGap6,
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: item.selectedAddons.map((addon) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: colors.surfaceSubtle,
                              borderRadius: AppRadius.xs,
                              border: Border.all(color: colors.borderSubtle),
                            ),
                            child: Text(
                              '+ $addon',
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    if (item.specialInstructions != null && item.specialInstructions!.isNotEmpty) ...[
                      AppSpacing.vGap6,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.warningBg,
                          borderRadius: AppRadius.xs,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.notes_rounded,
                              size: 12,
                              color: colors.warning,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                item.specialInstructions!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: colors.warning,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              AppSpacing.hGap12,

              // Item Subtotal (Formatted Currency)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.formatCurrency(item.totalPrice),
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    'Subtotal',
                    style: TextStyle(
                      fontSize: 10,
                      color: colors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (showDivider)
          Divider(
            height: 1,
            color: colors.divider,
          ),
      ],
    );
  }
}
