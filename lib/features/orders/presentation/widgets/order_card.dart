import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_status.dart';

/// Order Card strictly matching Stitch brief (`orders_list/code.html`)
class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onReady;
  final VoidCallback? onDecline;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.onAccept,
    this.onReady,
    this.onDecline,
  });

  Color _getHighlightColor(OrderStatus status, AppSemanticColors colors) {
    switch (status) {
      case OrderStatus.pending:
        return colors.textSecondary; // Tertiary container / Pending
      case OrderStatus.accepted:
      case OrderStatus.preparing:
        return colors.secondary; // Secondary Emerald
      case OrderStatus.ready:
        return colors.primaryContainer; // Primary Container Pink
      case OrderStatus.delivered:
        return colors.secondary; // Secondary
      case OrderStatus.cancelled:
        return colors.error; // Error Red
      case OrderStatus.all:
        return colors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDark;
    final isPending = order.status == OrderStatus.pending;
    final isAccepted = order.status == OrderStatus.accepted || order.status == OrderStatus.preparing;

    final customerName = order.customerName.isNotEmpty ? order.customerName : 'Customer';
    final itemsCountText = '${order.items.length} ${order.items.length == 1 ? "item" : "items"}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.md,
          border: Border.all(color: colors.borderSubtle),
          boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Left Indicator Highlight Bar
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4.5,
              child: Container(
                color: _getHighlightColor(order.status, colors),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: #1206 + Time ago & Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '#${order.orderNumber}',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: colors.textPrimary,
                            ),
                          ),
                          AppSpacing.hGap8,
                          Row(
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                size: 14,
                                color: colors.textMuted,
                              ),
                              AppSpacing.hGap4,
                              Text(
                                Formatters.formatTime(order.createdAt),
                                style: AppTypography.bodySmall.copyWith(
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      _buildStatusBadge(order.status, colors),
                    ],
                  ),

                  AppSpacing.vGap12,

                  // Items Summary String
                  Text(
                    order.itemsSummary,
                    style: AppTypography.bodySmall.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  AppSpacing.vGap14,

                  // Divider & Bottom Customer Row + Action Buttons
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: colors.divider, width: 0.8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Customer Name, Items Count & Price
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customerName,
                                style: AppTypography.titleSmall.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              AppSpacing.vGap2,
                              Row(
                                children: [
                                  Text(
                                    itemsCountText,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                    width: 3,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: colors.textMuted,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Text(
                                    Formatters.formatCurrency(order.totalAmount),
                                    style: AppTypography.titleSmall.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        AppSpacing.hGap8,

                        // Action Buttons with refined, comfortable touch sizes
                        if (isPending)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (onDecline != null)
                                SizedBox(
                                  height: 36,
                                  child: OutlinedButton(
                                    onPressed: onDecline,
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: colors.borderSubtle, width: 1.2),
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: AppRadius.full,
                                      ),
                                    ),
                                    child: Text(
                                      'Decline',
                                      style: AppTypography.labelMedium.copyWith(
                                        color: colors.textSecondary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              if (onDecline != null) AppSpacing.hGap8,
                              SizedBox(
                                height: 36,
                                child: ElevatedButton(
                                  onPressed: onAccept,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colors.primary,
                                    foregroundColor: colors.textInverse,
                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: AppRadius.full,
                                    ),
                                    elevation: 1,
                                  ),
                                  child: Text(
                                    'Accept',
                                    style: AppTypography.labelMedium.copyWith(
                                      color: colors.textInverse,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else if (isAccepted)
                          SizedBox(
                            height: 36,
                            child: ElevatedButton(
                              onPressed: onReady,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.ctaPrimary,
                                foregroundColor: colors.ctaPrimaryText,
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: AppRadius.full,
                                ),
                                elevation: 1,
                              ),
                              child: Text(
                                'Ready',
                                style: AppTypography.labelMedium.copyWith(
                                  color: colors.ctaPrimaryText,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 36,
                            child: OutlinedButton(
                              onPressed: onTap,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: colors.borderSubtle, width: 1.2),
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: AppRadius.full,
                                ),
                              ),
                              child: Text(
                                'Details',
                                style: AppTypography.labelMedium.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status, AppSemanticColors colors) {
    if (status == OrderStatus.pending) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: colors.textSecondary.withValues(alpha: 0.12),
          borderRadius: AppRadius.sm,
        ),
        child: Text(
          'PENDING',
          style: AppTypography.labelSmall.copyWith(
            color: colors.textSecondary,
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      );
    } else if (status == OrderStatus.accepted || status == OrderStatus.preparing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: colors.secondaryContainer.withValues(alpha: 0.25),
          borderRadius: AppRadius.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: colors.secondary,
                shape: BoxShape.circle,
              ),
            ),
            AppSpacing.hGap4,
            Text(
              status == OrderStatus.preparing ? 'PREPARING' : 'ACCEPTED',
              style: AppTypography.labelSmall.copyWith(
                color: colors.secondary,
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    } else if (status == OrderStatus.ready) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: colors.primaryContainer.withValues(alpha: 0.15),
          borderRadius: AppRadius.sm,
        ),
        child: Text(
          'READY',
          style: AppTypography.labelSmall.copyWith(
            color: colors.primary,
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      );
    } else if (status == OrderStatus.delivered) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: colors.successBg,
          borderRadius: AppRadius.sm,
        ),
        child: Text(
          'DELIVERED',
          style: AppTypography.labelSmall.copyWith(
            color: colors.success,
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: colors.errorBg,
          borderRadius: AppRadius.sm,
        ),
        child: Text(
          'CANCELLED',
          style: AppTypography.labelSmall.copyWith(
            color: colors.error,
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      );
    }
  }
}
