import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/status_badge.dart';

// Incoming Orders Stream Component for Quick Dispatch & Kitchen Preparation
class IncomingOrdersStream extends StatelessWidget {
  final VoidCallback onViewAllTapped;

  const IncomingOrdersStream({
    super.key,
    required this.onViewAllTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final mockOrders = [
      _MockOrderSummary(
        orderId: 'FP-8492',
        customerName: 'Alex Rivera',
        itemsSummary: '2x Truffle Smash Burger • 1x Loaded Fries',
        totalAmount: 32.50,
        status: OrderStatusType.preparing,
        timeAgo: '4m ago',
        actionLabel: 'Mark Ready',
        isPrimaryAction: false,
      ),
      _MockOrderSummary(
        orderId: 'FP-8493',
        customerName: 'Sarah Jenkins',
        itemsSummary: '1x Crispy Chicken Rice Bowl • 1x Iced Tea',
        totalAmount: 18.20,
        status: OrderStatusType.pending,
        timeAgo: 'Just now',
        actionLabel: 'Accept Order',
        isPrimaryAction: true,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Incoming Live Orders',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            GestureDetector(
              onTap: onViewAllTapped,
              child: Text(
                'View All (18)',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),

        AppSpacing.vGap12,

        // Order Cards List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mockOrders.length,
          separatorBuilder: (_, __) => AppSpacing.vGap12,
          itemBuilder: (context, index) {
            final order = mockOrders[index];
            return AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order ID & Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '#${order.orderId}',
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${order.timeAgo}',
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                      StatusBadge.fromOrderStatus(order.status),
                    ],
                  ),

                  AppSpacing.vGap8,

                  // Items Summary
                  Text(
                    order.itemsSummary,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  AppSpacing.vGap12,

                  // Price & Quick Action Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Formatters.formatCurrency(order.totalAmount),
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Order #${order.orderId} updated!'),
                              backgroundColor: AppColors.statusSuccess,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: order.isPrimaryAction
                              ? AppColors.primary
                              : (isDark ? Colors.white : AppColors.btnPrimaryBgLight),
                          foregroundColor: order.isPrimaryAction
                              ? Colors.white
                              : (isDark ? AppColors.inkPrimary : Colors.white),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                          elevation: 0,
                        ),
                        child: Text(
                          order.actionLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MockOrderSummary {
  final String orderId;
  final String customerName;
  final String itemsSummary;
  final double totalAmount;
  final OrderStatusType status;
  final String timeAgo;
  final String actionLabel;
  final bool isPrimaryAction;

  _MockOrderSummary({
    required this.orderId,
    required this.customerName,
    required this.itemsSummary,
    required this.totalAmount,
    required this.status,
    required this.timeAgo,
    required this.actionLabel,
    required this.isPrimaryAction,
  });
}
