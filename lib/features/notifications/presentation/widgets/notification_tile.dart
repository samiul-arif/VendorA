import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/notification_model.dart';
import '../../domain/models/notification_type.dart';

/// Notification Card strictly matching Stitch brief (`notifications/code.html`)
class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onViewOrder;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
    this.onViewOrder,
  });

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDark;
    final isUnread = !notification.isRead;
    final type = notification.type;

    // Type specific colors and icons matching Stitch brief
    Color iconBg;
    Color iconColor;
    IconData iconData;

    switch (type) {
      case NotificationType.order:
        iconBg = colors.secondaryContainer.withValues(alpha: 0.35);
        iconColor = colors.secondary;
        iconData = Icons.shopping_bag_rounded;
        break;
      case NotificationType.system:
        iconBg = colors.errorBg;
        iconColor = colors.error;
        iconData = Icons.warning_amber_rounded;
        break;
      case NotificationType.payout:
        iconBg = colors.surfaceLow;
        iconColor = colors.textPrimary;
        iconData = Icons.credit_card_rounded;
        break;
      case NotificationType.stock:
        iconBg = colors.surfaceLow;
        iconColor = const Color(0xFFF59E0B);
        iconData = Icons.inventory_2_rounded;
        break;
    }

    final hasAction = type == NotificationType.order;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: colors.error,
          borderRadius: AppRadius.lg,
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isUnread ? 1.0 : 0.78,
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: AppRadius.lg,
            border: Border.all(
              color: isUnread ? colors.primary.withValues(alpha: 0.25) : colors.borderSubtle,
              width: isUnread ? 1.2 : 1.0,
            ),
            boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.lg,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Unread primary accent dot
                  if (isUnread)
                    Container(
                      margin: const EdgeInsets.only(top: 8, right: 8),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    const SizedBox(width: 4),

                  // Circular Type Icon container (40x40 circle matching Stitch)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(iconData, size: 20, color: iconColor),
                    ),
                  ),

                  AppSpacing.hGap12,

                  // Message Content & Timestamp
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: AppTypography.titleSmall.copyWith(
                                  fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600,
                                  color: colors.textPrimary,
                                  fontSize: 14.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            AppSpacing.hGap8,
                            Text(
                              _formatTimeAgo(notification.createdAt),
                              style: AppTypography.labelSmall.copyWith(
                                color: colors.textMuted,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.vGap4,
                        Text(
                          notification.message,
                          style: AppTypography.bodySmall.copyWith(
                            color: colors.textSecondary,
                            fontSize: 12.5,
                            height: 1.4,
                          ),
                        ),
                        if (hasAction) ...[
                          AppSpacing.vGap10,
                          InkWell(
                            onTap: onViewOrder ?? onTap,
                            borderRadius: AppRadius.full,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: colors.ctaPrimary,
                                borderRadius: AppRadius.full,
                              ),
                              child: Text(
                                'View Order',
                                style: AppTypography.labelSmall.copyWith(
                                  color: colors.ctaPrimaryText,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
