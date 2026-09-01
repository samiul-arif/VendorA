import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/components/empty_state_view.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/models/notification_model.dart';
import '../controllers/notification_controller.dart';
import '../widgets/notification_tile.dart';
import '../widgets/notification_filter_bar.dart';

/// Notification Center Screen strictly matching Stitch brief (`notifications/code.html`)
class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = context.read<AuthController>();
      final shopId = authController.activeShop?.id ?? 'shop_01';
      context.read<NotificationController>().loadNotifications(shopId: shopId);
    });
  }

  void _handleNotificationTap(NotificationModel item) {
    final controller = context.read<NotificationController>();
    controller.markAsRead(item.id);

    if (item.relatedOrderId != null && item.relatedOrderId!.isNotEmpty) {
      Navigator.of(context).pushNamed(
        AppRoutes.orderDetails,
        arguments: item.relatedOrderId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final controller = context.watch<NotificationController>();
    final notifications = controller.filteredNotifications;

    // Group into Today and Earlier
    final now = DateTime.now();
    final todayList = <NotificationModel>[];
    final earlierList = <NotificationModel>[];

    for (final notif in notifications) {
      final diff = now.difference(notif.createdAt);
      if (diff.inHours < 24 && now.day == notif.createdAt.day) {
        todayList.add(notif);
      } else {
        earlierList.add(notif);
      }
    }

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notifications',
          style: AppTypography.headlineMedium.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          if (controller.unreadCount > 0)
            TextButton(
              onPressed: () => controller.markAllAsRead(),
              child: Text(
                'MARK ALL AS READ',
                style: AppTypography.labelSmall.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          AppSpacing.hGap8,
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Filter Chips Bar
            NotificationFilterBar(
              selectedFilter: controller.selectedFilter,
              onFilterSelected: (f) => controller.setFilter(f),
            ),

            AppSpacing.vGap4,

            // Notification Groups
            Expanded(
              child: RefreshIndicator(
                color: colors.primary,
                onRefresh: () => controller.loadNotifications(forceRefresh: true),
                child: controller.isLoading
                    ? ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                        itemCount: 4,
                        separatorBuilder: (_, __) => AppSpacing.vGap12,
                        itemBuilder: (_, __) => const ShimmerSkeleton(
                          width: double.infinity,
                          height: 88,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      )
                    : notifications.isEmpty
                        ? EmptyStateView(
                            icon: Icons.notifications_off_outlined,
                            title: 'All caught up!',
                            description: controller.selectedFilter != null
                                ? 'No ${controller.selectedFilter!.label.toLowerCase()} alerts found.'
                                : 'You don\'t have any new notifications at the moment.',
                          )
                        : ListView(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                            children: [
                              if (todayList.isNotEmpty) ...[
                                _buildSectionHeader('TODAY', colors),
                                AppSpacing.vGap8,
                                ...todayList.map((item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: NotificationTile(
                                        notification: item,
                                        onTap: () => _handleNotificationTap(item),
                                        onDelete: () => controller.deleteNotification(item.id),
                                        onViewOrder: () => _handleNotificationTap(item),
                                      ),
                                    )),
                                AppSpacing.vGap12,
                              ],
                              if (earlierList.isNotEmpty) ...[
                                _buildSectionHeader('EARLIER', colors),
                                AppSpacing.vGap8,
                                ...earlierList.map((item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: NotificationTile(
                                        notification: item,
                                        onTap: () => _handleNotificationTap(item),
                                        onDelete: () => controller.deleteNotification(item.id),
                                        onViewOrder: () => _handleNotificationTap(item),
                                      ),
                                    )),
                              ],
                            ],
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppSemanticColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: AppTypography.labelSmall.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: colors.textSecondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
