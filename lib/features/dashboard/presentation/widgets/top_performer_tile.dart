import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/analytics_summary_model.dart';

// Top Performer Best-Selling Item Tile
class TopPerformerTile extends StatelessWidget {
  final TopPerformerItem item;

  const TopPerformerTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = colors.success;
    final errorColor = colors.error;
    final neutralColor = isDark ? const Color(0xFFDFE2EE) : const Color(0xFF5C5D64);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: const BoxDecoration(
        borderRadius: AppRadius.sm,
      ),
      child: Row(
        children: [
          // Item Image Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 48,
              height: 48,
              color: isDark ? const Color(0xFF2C3039) : const Color(0xFFE5E8F4),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.fastfood_outlined,
                  color: colors.textSecondary,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Title and Orders Count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.ordersCount} Orders',
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Revenue & Growth Trend
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.formatCurrency(item.totalRevenue),
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.growthPercentage == 0
                        ? Icons.remove
                        : (item.isGrowthPositive
                            ? Icons.arrow_upward
                            : Icons.arrow_downward),
                    size: 12,
                    color: item.growthPercentage == 0
                        ? neutralColor
                        : (item.isGrowthPositive ? successColor : errorColor),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${item.growthPercentage.toStringAsFixed(0)}%',
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: item.growthPercentage == 0
                          ? neutralColor
                          : (item.isGrowthPositive ? successColor : errorColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
