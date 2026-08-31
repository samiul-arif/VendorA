import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
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
    final colors = context.appColors;

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
                      ? colors.ctaPrimary
                      : colors.surfaceSubtle,
                  borderRadius: AppRadius.full,
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : colors.border,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? colors.ctaPrimaryText
                        : colors.textSecondary,
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
