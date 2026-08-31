import '../../../../core/utils/result.dart';
import '../models/notification_model.dart';
import '../models/notification_type.dart';

// Notification Repository Interface
abstract class INotificationRepository {
  Future<Result<List<NotificationModel>>> getNotifications({
    required String shopId,
    NotificationType? typeFilter,
    bool forceRefresh = false,
  });

  Future<Result<NotificationModel>> markAsRead({
    required String notificationId,
  });

  Future<Result<void>> markAllAsRead({
    required String shopId,
  });

  Future<Result<void>> deleteNotification({
    required String notificationId,
  });
}
