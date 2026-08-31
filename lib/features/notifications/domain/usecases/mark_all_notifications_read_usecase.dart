import '../../../../core/utils/result.dart';
import '../repositories/notification_repository_interface.dart';

// Mark All Notifications as Read Use Case
class MarkAllNotificationsReadUseCase {
  final INotificationRepository _repository;

  MarkAllNotificationsReadUseCase(this._repository);

  Future<Result<void>> execute({
    required String shopId,
  }) async {
    return await _repository.markAllAsRead(shopId: shopId);
  }
}
