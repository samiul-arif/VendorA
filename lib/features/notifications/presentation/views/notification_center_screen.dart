import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/empty_state_view.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/notification_controller.dart';
import '../widgets/notification_tile.dart';
import '../widgets/notification_filter_bar.dart';

// Notification Center Screen
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final controller = context.watch<NotificationController>();
    final notifications = controller.filteredNotifications;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (controller.unreadCount > 0)
            TextButton.icon(
              onPressed: () => controller.markAllAsRead(),
              icon: const Icon(Icons.done_all_rounded, size: 18),
              label: const Text(
                'Mark All Read',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Filter Bar
            NotificationFilterBar(
              selectedFilter: controller.selectedFilter,
              onFilterSelected: (f) => controller.setFilter(f),
            ),

            AppSpacing.vGap4,

            // Content List
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
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
                            title: 'No Notifications',
                            description: controller.selectedFilter != null
                                ? 'No ${controller.selectedFilter!.label.toLowerCase()} alerts found.'
                                : 'You are all caught up! New orders, payouts, and kitchen updates will appear here.',
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                            itemCount: notifications.length,
                            separatorBuilder: (_, __) => AppSpacing.vGap12,
                            itemBuilder: (context, index) {
                              final item = notifications[index];
                              return NotificationTile(
                                notification: item,
                                onTap: () => controller.markAsRead(item.id),
                                onDelete: () => controller.deleteNotification(item.id),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
