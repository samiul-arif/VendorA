import 'package:flutter/material.dart';
import '../../../../shared/components/status_badge.dart';

// Order Lifecycle Status Enum & Helper Extensions
enum OrderStatus {
  all,
  pending,
  accepted,
  preparing,
  ready,
  delivered,
  cancelled;

  String get label {
    switch (this) {
      case OrderStatus.all:
        return 'All Orders';
      case OrderStatus.pending:
        return 'New Orders';
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready for Pickup';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  BadgeType get badgeType {
    switch (this) {
      case OrderStatus.all:
      case OrderStatus.pending:
        return BadgeType.pending;
      case OrderStatus.accepted:
        return BadgeType.accepted;
      case OrderStatus.preparing:
        return BadgeType.preparing;
      case OrderStatus.ready:
        return BadgeType.ready;
      case OrderStatus.delivered:
        return BadgeType.delivered;
      case OrderStatus.cancelled:
        return BadgeType.cancelled;
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.all:
        return Icons.list_alt_rounded;
      case OrderStatus.pending:
        return Icons.notifications_active_outlined;
      case OrderStatus.accepted:
        return Icons.check_circle_outline_rounded;
      case OrderStatus.preparing:
        return Icons.soup_kitchen_outlined;
      case OrderStatus.ready:
        return Icons.takeout_dining_outlined;
      case OrderStatus.delivered:
        return Icons.done_all_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  // Next status in standard kitchen dispatch workflow
  OrderStatus? get nextActionStatus {
    switch (this) {
      case OrderStatus.pending:
        return OrderStatus.accepted;
      case OrderStatus.accepted:
        return OrderStatus.preparing;
      case OrderStatus.preparing:
        return OrderStatus.ready;
      case OrderStatus.ready:
        return OrderStatus.delivered;
      default:
        return null;
    }
  }

  String? get nextActionLabel {
    switch (this) {
      case OrderStatus.pending:
        return 'Accept';
      case OrderStatus.accepted:
        return 'Start Preparing';
      case OrderStatus.preparing:
        return 'Mark Ready';
      case OrderStatus.ready:
        return 'Hand to Rider';
      default:
        return null;
    }
  }

  static OrderStatus fromString(String? val) {
    if (val == null) return OrderStatus.pending;
    switch (val.toLowerCase().trim()) {
      case 'all':
        return OrderStatus.all;
      case 'pending':
        return OrderStatus.pending;
      case 'accepted':
        return OrderStatus.accepted;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready':
      case 'ready_for_pickup':
        return OrderStatus.ready;
      case 'delivered':
      case 'completed':
        return OrderStatus.delivered;
      case 'cancelled':
      case 'rejected':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}
