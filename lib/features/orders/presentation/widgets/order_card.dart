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
              padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: #1206 + Time ago & Status Badge (Responsive)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              '#${order.orderNumber}',
                              style: AppTypography.titleMedium.copyWith(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w900,
                                color: colors.textPrimary,
                              ),
                            ),
                            AppSpacing.hGap6,
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.schedule_rounded,
                                    size: 13,
                                    color: colors.textMuted,
                                  ),
                                  const SizedBox(width: 3),
                                  Flexible(
                                    child: Text(
                                      Formatters.formatTime(order.createdAt),
                                      style: AppTypography.bodySmall.copyWith(
                                        color: colors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.5,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      _buildStatusBadge(order.status, colors),
                    ],
                  ),

                  AppSpacing.vGap10,

                  // Items Summary String
                  Text(
                    order.itemsSummary,
                    style: AppTypography.bodySmall.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  AppSpacing.vGap12,

                  // Divider & Bottom Customer Row + Action Buttons (Responsive)
                  Container(
                    padding: const EdgeInsets.only(top: 10),
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
                                  fontSize: 13.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    itemsCountText,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: colors.textSecondary,
                                      fontSize: 11.5,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: 3,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: colors.textMuted,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      Formatters.formatCurrency(order.totalAmount),
                                      style: AppTypography.titleSmall.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: colors.textPrimary,
                                        fontSize: 12.5,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 6),

                        // Action Buttons with refined, compact sizes for small screens
                        if (isPending)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (onDecline != null)
                                InkWell(
                                  onTap: onDecline,
                                  borderRadius: AppRadius.full,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: colors.surface,
                                      borderRadius: AppRadius.full,
                                      border: Border.all(color: colors.borderSubtle, width: 1.1),
                                    ),
                                    child: Text(
                                      'Decline',
                                      style: AppTypography.labelMedium.copyWith(
                                        color: colors.textSecondary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              if (onDecline != null) const SizedBox(width: 6),
                              InkWell(
                                onTap: onAccept,
                                borderRadius: AppRadius.full,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    borderRadius: AppRadius.full,
                                    boxShadow: [
                                      BoxShadow(
                                        color: colors.primary.withValues(alpha: 0.25),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Accept',
                                    style: AppTypography.labelMedium.copyWith(
                                      color: colors.textInverse,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else if (isAccepted)
                          InkWell(
                            onTap: onReady,
                            borderRadius: AppRadius.full,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                              decoration: BoxDecoration(
                                color: colors.ctaPrimary,
                                borderRadius: AppRadius.full,
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.ctaPrimary.withValues(alpha: 0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Ready',
                                style: AppTypography.labelMedium.copyWith(
                                  color: colors.ctaPrimaryText,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        else
                          InkWell(
                            onTap: onTap,
                            borderRadius: AppRadius.full,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: AppRadius.full,
                                border: Border.all(color: colors.borderSubtle, width: 1.1),
                              ),
                              child: Text(
                                'Details',
                                style: AppTypography.labelMedium.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
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
