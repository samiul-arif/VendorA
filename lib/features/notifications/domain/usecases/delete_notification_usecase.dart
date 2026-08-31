import '../../../../core/utils/result.dart';
import '../repositories/notification_repository_interface.dart';

// Delete Notification Use Case
class DeleteNotificationUseCase {
  final INotificationRepository _repository;

  DeleteNotificationUseCase(this._repository);

  Future<Result<void>> execute({
    required String notificationId,
  }) async {
    return await _repository.deleteNotification(notificationId: notificationId);
  }
}
