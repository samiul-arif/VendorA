import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/components/app_card.dart';
import '../../domain/models/notification_model.dart';

// Interactive Notification Tile with Slide-to-Delete
class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final type = notification.type;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.statusError,
          borderRadius: AppRadius.card,
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
      ),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        backgroundColor: notification.isRead
            ? null
            : (isDark ? const Color(0xFF251A24) : const Color(0xFFFFF5F8)),
        child: InkWell(
          onTap: () {
            onTap();
            if (notification.relatedOrderId != null) {
              Navigator.of(context).pushNamed(
                AppRoutes.orderDetails,
                arguments: notification.relatedOrderId,
              );
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Icon Accent
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: type.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(type.icon, size: 20, color: type.color),
              ),

              AppSpacing.hGap14,

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                        if (!notification.isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    AppSpacing.vGap4,
                    Text(
                      notification.message,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        height: 1.35,
                      ),
                    ),
                    AppSpacing.vGap8,
                    Text(
                      _formatTimeAgo(notification.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
