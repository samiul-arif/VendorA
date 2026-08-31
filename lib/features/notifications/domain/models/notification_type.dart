import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

// Notification Types and Visual Meta Helpers
enum NotificationType {
  order,
  payout,
  system,
  stock;

  String get label {
    switch (this) {
      case NotificationType.order:
        return 'Orders';
      case NotificationType.payout:
        return 'Payouts';
      case NotificationType.system:
        return 'System';
      case NotificationType.stock:
        return 'Inventory';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.order:
        return Icons.receipt_long_rounded;
      case NotificationType.payout:
        return Icons.account_balance_wallet_rounded;
      case NotificationType.system:
        return Icons.notifications_active_rounded;
      case NotificationType.stock:
        return Icons.inventory_2_rounded;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.order:
        return AppColors.primary;
      case NotificationType.payout:
        return const Color(0xFF10B981);
      case NotificationType.system:
        return const Color(0xFF3B82F6);
      case NotificationType.stock:
        return const Color(0xFFF59E0B);
    }
  }

  static NotificationType fromString(String? val) {
    if (val == null) return NotificationType.system;
    switch (val.toLowerCase().trim()) {
      case 'order':
        return NotificationType.order;
      case 'payout':
        return NotificationType.payout;
      case 'stock':
        return NotificationType.stock;
      case 'system':
      default:
        return NotificationType.system;
    }
  }
}
