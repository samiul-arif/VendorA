import 'package:flutter/material.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// 2-Column Quick Action Cards matching the exact style and size of Total Orders & Payouts cards
class QuickActionsBar extends StatelessWidget {
  final ValueChanged<int>? onNavigateTab;

  const QuickActionsBar({
    super.key,
    this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDark;

    return Row(
      children: [
        // Left Card: Add Item
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.addProduct);
            },
            child: Container(
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppRadius.md,
                border: Border.all(color: colors.borderSubtle),
                boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline_rounded,
                        size: 18,
                        color: colors.primary,
                      ),
                      AppSpacing.hGap8,
                      Expanded(
                        child: Text(
                          'Inventory',
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vGap10,
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add Item',
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        AppSpacing.hGap14,

        // Right Card: View Orders
        Expanded(
          child: GestureDetector(
            onTap: () => onNavigateTab?.call(1),
            child: Container(
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppRadius.md,
                border: Border.all(color: colors.borderSubtle),
                boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 18,
                        color: colors.primary,
                      ),
                      AppSpacing.hGap8,
                      Expanded(
                        child: Text(
                          'Live Queue',
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vGap10,
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'View Orders',
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
