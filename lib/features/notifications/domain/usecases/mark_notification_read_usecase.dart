import '../../../../core/utils/result.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository_interface.dart';

// Mark Notification as Read Use Case
class MarkNotificationReadUseCase {
  final INotificationRepository _repository;

  MarkNotificationReadUseCase(this._repository);

  Future<Result<NotificationModel>> execute({
    required String notificationId,
  }) async {
    return await _repository.markAsRead(notificationId: notificationId);
  }
}
