import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/routing/app_routes.dart';
import '../controllers/notification_controller.dart';

// Notification Bell Icon with Live Unread Badge
class NotificationBadgeIcon extends StatelessWidget {
  const NotificationBadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final notificationController = context.watch<NotificationController>();
    final count = notificationController.unreadCount;

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, size: 24),
          tooltip: 'Notifications',
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.notifications);
          },
        ),
        if (count > 0)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Center(
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: TextStyle(
                    color: colors.textInverse,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
