import 'notification_type.dart';

// Notification Entity Model
class NotificationModel {
  final String id;
  final String shopId;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final String? actionRoute;
  final String? relatedOrderId;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.shopId,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    this.actionRoute,
    this.relatedOrderId,
    required this.createdAt,
  });

  NotificationModel copyWith({
    String? id,
    String? shopId,
    String? title,
    String? message,
    NotificationType? type,
    bool? isRead,
    String? actionRoute,
    String? relatedOrderId,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
      relatedOrderId: relatedOrderId ?? this.relatedOrderId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopId': shopId,
      'title': title,
      'message': message,
      'type': type.name,
      'isRead': isRead,
      'actionRoute': actionRoute,
      'relatedOrderId': relatedOrderId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      shopId: json['shopId'] as String? ?? 'shop_01',
      title: json['title'] as String,
      message: json['message'] as String,
      type: NotificationType.fromString(json['type'] as String?),
      isRead: json['isRead'] as bool? ?? false,
      actionRoute: json['actionRoute'] as String?,
      relatedOrderId: json['relatedOrderId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
