import '../../../../core/network/base_mock_repository.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/notification_model.dart';
import '../../domain/models/notification_type.dart';
import '../../domain/repositories/notification_repository_interface.dart';

// Mock Notification Repository with in-memory persistence
class MockNotificationRepository extends BaseMockRepository implements INotificationRepository {
  List<NotificationModel> _notifications = [
    NotificationModel(
      id: 'notif_001',
      shopId: 'shop_01',
      title: 'New Order Received! (#ORD-9021)',
      message: 'Alex Johnson placed an order for 2x Truffle Burger (৳34.50). Tap to start preparation.',
      type: NotificationType.order,
      isRead: false,
      relatedOrderId: 'ord_001',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NotificationModel(
      id: 'notif_002',
      shopId: 'shop_01',
      title: 'Low Stock Alert: Organic Basil Pesto',
      message: 'Only 3 units left in inventory. Consider restocking soon to avoid stockout.',
      type: NotificationType.stock,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationModel(
      id: 'notif_003',
      shopId: 'shop_01',
      title: 'Weekly Payout Deposited',
      message: 'Your weekly settlement of ৳8,420.50 has been transferred to DBBL Bank (•••• 4829).',
      type: NotificationType.payout,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    NotificationModel(
      id: 'notif_004',
      shopId: 'shop_01',
      title: 'Peak Dinner Hours Approaching',
      message: 'Kitchen prep demand expected to surge between 7:00 PM and 9:30 PM.',
      type: NotificationType.system,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 10)),
    ),
    NotificationModel(
      id: 'notif_005',
      shopId: 'shop_01',
      title: 'Order Delivered (#ORD-9018)',
      message: 'Rider Dave Miller completed delivery to 452 Elm Street.',
      type: NotificationType.order,
      isRead: true,
      relatedOrderId: 'ord_004',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Future<Result<List<NotificationModel>>> getNotifications({
    required String shopId,
    NotificationType? typeFilter,
    bool forceRefresh = false,
  }) async {
    return executeMock(
      operation: () async {
        var list = _notifications.where((n) => n.shopId == shopId).toList();
        if (typeFilter != null) {
          list = list.where((n) => n.type == typeFilter).toList();
        }
        // Sort newest first
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return list;
      },
      customDelayMs: 250,
    );
  }

  @override
  Future<Result<NotificationModel>> markAsRead({
    required String notificationId,
  }) async {
    return executeMock(
      operation: () async {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          final updated = _notifications[index].copyWith(isRead: true);
          _notifications[index] = updated;
          return updated;
        }
        throw Exception('Notification not found');
      },
      customDelayMs: 150,
    );
  }

  @override
  Future<Result<void>> markAllAsRead({
    required String shopId,
  }) async {
    return executeMock(
      operation: () async {
        _notifications = _notifications.map((n) {
          if (n.shopId == shopId) {
            return n.copyWith(isRead: true);
          }
          return n;
        }).toList();
      },
      customDelayMs: 200,
    );
  }

  @override
  Future<Result<void>> deleteNotification({
    required String notificationId,
  }) async {
    return executeMock(
      operation: () async {
        _notifications.removeWhere((n) => n.id == notificationId);
      },
      customDelayMs: 200,
    );
  }
}
