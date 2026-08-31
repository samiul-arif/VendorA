import '../../../../core/utils/result.dart';
import '../models/notification_model.dart';
import '../models/notification_type.dart';
import '../repositories/notification_repository_interface.dart';

// Get Notifications List Use Case
class GetNotificationsUseCase {
  final INotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<Result<List<NotificationModel>>> execute({
    required String shopId,
    NotificationType? typeFilter,
    bool forceRefresh = false,
  }) async {
    return await _repository.getNotifications(
      shopId: shopId,
      typeFilter: typeFilter,
      forceRefresh: forceRefresh,
    );
  }
}
