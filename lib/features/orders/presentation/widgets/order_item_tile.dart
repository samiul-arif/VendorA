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
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quantity Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: AppRadius.sm,
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '${item.quantity}x',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: colors.primary,
                  ),
                ),
              ),

              AppSpacing.hGap12,

              // Name, Addons & Special Instructions
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

                    if (item.selectedAddons.isNotEmpty) ...[
                      AppSpacing.vGap4,
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: item.selectedAddons.map((addon) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: colors.surfaceSubtle,
                              borderRadius: AppRadius.xs,
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
                      AppSpacing.vGap4,
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

              // Total Price for Line Item
              Text(
                Formatters.formatCurrency(item.totalPrice),
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
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
