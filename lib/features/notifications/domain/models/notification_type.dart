import 'package:flutter/material.dart';
import '../../../../core/theme/app_semantic_colors.dart';

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

  Color color(AppSemanticColors colors) {
    switch (this) {
      case NotificationType.order:
        return colors.primary;
      case NotificationType.payout:
        return colors.success;
      case NotificationType.system:
        return colors.info;
      case NotificationType.stock:
        return colors.warning;
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
