import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/order_status.dart';

// Horizontal Filter Pills for Order Status Tabs
class OrderStatusTabBar extends StatelessWidget {
  final OrderStatus selectedStatus;
  final ValueChanged<OrderStatus> onStatusSelected;
  final int Function(OrderStatus) countGetter;

  const OrderStatusTabBar({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
    required this.countGetter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final tabs = [
      OrderStatus.all,
      OrderStatus.pending,
      OrderStatus.accepted,
      OrderStatus.preparing,
      OrderStatus.ready,
      OrderStatus.delivered,
      OrderStatus.cancelled,
    ];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final status = tabs[index];
          final isSelected = selectedStatus == status;
          final count = countGetter(status);

          final bgColor = isSelected
              ? (isDark ? Colors.white : AppColors.ctaPrimary)
              : (isDark ? AppColors.darkSurface : Colors.white);

          final textColor = isSelected
              ? (isDark ? AppColors.ctaPrimary : Colors.white)
              : (isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight);

          return GestureDetector(
            onTap: () => onStatusSelected(status),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: AppRadius.full,
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : (isDark ? AppColors.darkBorder : AppColors.borderLight),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    status.label,
                    style: AppTypography.labelMedium.copyWith(
                      color: textColor,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? AppColors.ctaPrimary.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.25))
                            : (isDark ? const Color(0xFF2E1A2A) : AppColors.primaryTint),
                        borderRadius: AppRadius.full,
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? (isDark ? AppColors.ctaPrimary : Colors.white)
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
