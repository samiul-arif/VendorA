import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../domain/models/notification_type.dart';

// Horizontal Filter Chips for Notification Categories
class NotificationFilterBar extends StatelessWidget {
  final NotificationType? selectedFilter;
  final ValueChanged<NotificationType?> onFilterSelected;

  const NotificationFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filters = [
      {'label': 'All', 'type': null},
      {'label': 'Orders', 'type': NotificationType.order},
      {'label': 'Inventory', 'type': NotificationType.stock},
      {'label': 'Payouts', 'type': NotificationType.payout},
      {'label': 'System', 'type': NotificationType.system},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((f) {
          final type = f['type'] as NotificationType?;
          final label = f['label'] as String;
          final isSelected = selectedFilter == type;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onFilterSelected(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? Colors.white : AppColors.ctaPrimary)
                      : (isDark ? const Color(0xFF232A34) : AppColors.lightSurfaceSubtle),
                  borderRadius: AppRadius.full,
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark ? AppColors.darkBorder : AppColors.borderLight),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? (isDark ? AppColors.ctaPrimary : Colors.white)
                        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
