import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/order_status.dart';

/// Order Card matching Stitch brief (`orders_list/code.html`)
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

  Color _getHighlightColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFF75767C); // Tertiary container / Pending
      case OrderStatus.accepted:
      case OrderStatus.preparing:
        return const Color(0xFF006B57); // Secondary Emerald
      case OrderStatus.ready:
        return const Color(0xFFE21B70); // Primary Container Pink
      case OrderStatus.delivered:
        return const Color(0xFF006B57); // Secondary
      case OrderStatus.cancelled:
        return const Color(0xFFBA1A1A); // Error Red
      case OrderStatus.all:
        return const Color(0xFF75767C);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isPending = order.status == OrderStatus.pending;
    final isAccepted = order.status == OrderStatus.accepted || order.status == OrderStatus.preparing;

    final customerName = order.customerName.isNotEmpty ? order.customerName : 'Eleanor Shellstrop';
    final itemsCountText = '${order.items.length} ${order.items.length == 1 ? "item" : "items"}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
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
        child: Stack(
          children: [
            // Left Indicator Highlight Bar
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4.5,
              child: Container(
                color: _getHighlightColor(order.status),
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Icon(Icons.schedule_rounded, size: 14, color: colors.textMuted),
                              const SizedBox(width: 3),
                              Text(
                                Formatters.formatTime(order.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
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
                    style: TextStyle(
                      fontSize: 12.5,
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
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    itemsCountText,
                                    style: TextStyle(
                                      fontSize: 12,
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
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Action Buttons based on status
                        if (isPending)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (onDecline != null)
                                OutlinedButton(
                                  onPressed: onDecline,
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: colors.borderSubtle),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                    minimumSize: Size.zero,
                                    shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                                  ),
                                  child: Text(
                                    'Decline',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ),
                              if (onDecline != null) const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: onAccept,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                                  minimumSize: Size.zero,
                                  shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Accept',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        else if (isAccepted)
                          ElevatedButton(
                            onPressed: onReady,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.ctaPrimary,
                              foregroundColor: colors.ctaPrimaryText,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              minimumSize: Size.zero,
                              shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                              elevation: 0,
                            ),
                            child: Text(
                              'Ready',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: colors.ctaPrimaryText,
                              ),
                            ),
                          )
                        else
                          OutlinedButton(
                            onPressed: onTap,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colors.borderSubtle),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                              minimumSize: Size.zero,
                              shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                            ),
                            child: Text(
                              'Details',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
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
          color: const Color(0xFF75767C).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'PENDING',
          style: TextStyle(
            color: Color(0xFF5C5D64),
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
          color: const Color(0xFF75F9D6).withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF006B57),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              status == OrderStatus.preparing ? 'PREPARING' : 'ACCEPTED',
              style: const TextStyle(
                color: Color(0xFF006B57),
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
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'READY',
          style: TextStyle(
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
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'DELIVERED',
          style: TextStyle(
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
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'CANCELLED',
          style: TextStyle(
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
