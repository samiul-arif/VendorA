import 'package:flutter/material.dart';
import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/components/app_toast.dart';
import '../../domain/models/notification_model.dart';
import '../../domain/models/notification_type.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import '../../domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../domain/usecases/delete_notification_usecase.dart';

// Notification Center Controller
class NotificationController extends BaseController {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationReadUseCase _markNotificationReadUseCase;
  final MarkAllNotificationsReadUseCase _markAllNotificationsReadUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;

  List<NotificationModel> _allNotifications = [];
  NotificationType? _selectedFilter;
  String _activeShopId = 'shop_01';

  NotificationController({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkNotificationReadUseCase markNotificationReadUseCase,
    required MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase,
    required DeleteNotificationUseCase deleteNotificationUseCase,
  })  : _getNotificationsUseCase = getNotificationsUseCase,
        _markNotificationReadUseCase = markNotificationReadUseCase,
        _markAllNotificationsReadUseCase = markAllNotificationsReadUseCase,
        _deleteNotificationUseCase = deleteNotificationUseCase;

  // Getters
  List<NotificationModel> get allNotifications => _allNotifications;
  NotificationType? get selectedFilter => _selectedFilter;

  List<NotificationModel> get filteredNotifications {
    if (_selectedFilter == null) return _allNotifications;
    return _allNotifications.where((n) => n.type == _selectedFilter).toList();
  }

  int get unreadCount => _allNotifications.where((n) => !n.isRead).length;

  // Load Notifications
  Future<void> loadNotifications({String? shopId, bool forceRefresh = false}) async {
    if (shopId != null) _activeShopId = shopId;

    await runWithState<List<NotificationModel>>(() async {
      final result = await _getNotificationsUseCase.execute(
        shopId: _activeShopId,
        forceRefresh: forceRefresh,
      );

      if (result is Success<List<NotificationModel>>) {
        _allNotifications = result.data;
      }
      return result;
    });
  }

  // Set Filter
  void setFilter(NotificationType? filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // Dispatch live notification (Show floating toast + persist in history + increment badge)
  void dispatchNotification(
    BuildContext? context, {
    required String title,
    required String message,
    NotificationType type = NotificationType.system,
    String? relatedOrderId,
    String? actionRoute,
    AppToastVariant toastVariant = AppToastVariant.info,
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onTap,
  }) {
    final newNotification = NotificationModel(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      shopId: _activeShopId,
      title: title,
      message: message,
      type: type,
      isRead: false,
      relatedOrderId: relatedOrderId,
      actionRoute: actionRoute,
      createdAt: DateTime.now(),
    );

    // Insert at beginning of history
    _allNotifications.insert(0, newNotification);
    notifyListeners();

    // Show floating top toast if context is provided
    if (context != null) {
      AppToast.show(
        context,
        title: title,
        message: message,
        variant: toastVariant,
        actionLabel: actionLabel,
        onAction: onAction,
        onTap: onTap,
      );
    }
  }

  // Mark single as read
  Future<void> markAsRead(String id) async {
    final result = await _markNotificationReadUseCase.execute(notificationId: id);
    if (result is Success<NotificationModel>) {
      final idx = _allNotifications.indexWhere((n) => n.id == id);
      if (idx != -1) {
        _allNotifications[idx] = result.data;
        notifyListeners();
      }
    } else {
      // Optimistic local update fallback
      final idx = _allNotifications.indexWhere((n) => n.id == id);
      if (idx != -1) {
        _allNotifications[idx] = _allNotifications[idx].copyWith(isRead: true);
        notifyListeners();
      }
    }
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    final result = await _markAllNotificationsReadUseCase.execute(shopId: _activeShopId);
    if (result is Success<void>) {
      _allNotifications = _allNotifications.map((n) => n.copyWith(isRead: true)).toList();
      notifyListeners();
    } else {
      // Optimistic local update fallback
      _allNotifications = _allNotifications.map((n) => n.copyWith(isRead: true)).toList();
      notifyListeners();
    }
  }

  // Delete single notification
  Future<void> deleteNotification(String id) async {
    final result = await _deleteNotificationUseCase.execute(notificationId: id);
    if (result is Success<void>) {
      _allNotifications.removeWhere((n) => n.id == id);
      notifyListeners();
    } else {
      _allNotifications.removeWhere((n) => n.id == id);
      notifyListeners();
    }
  }
}
