import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/empty_state_view.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../../shared/components/app_circular_back_button.dart';
import '../../../../shared/components/app_header_action_button.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/models/notification_model.dart';
import '../controllers/notification_controller.dart';
import '../widgets/notification_tile.dart';
import '../widgets/notification_filter_bar.dart';

// Notification Center Screen (Permanent Activity Log & Quick Destination Router)
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
    // Clicking any notification does nothing for now (no external link / navigation)
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final controller = context.watch<NotificationController>();
    final notifications = controller.filteredNotifications;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 56,
        leading: const AppCircularBackButton(),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          if (controller.unreadCount > 0)
            AppHeaderActionButton(
              text: 'Mark All Read',
              icon: Icons.done_all_rounded,
              onPressed: () => controller.markAllAsRead(),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: colors.borderSubtle,
            height: 1.0,
          ),
        ),
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
                                onTap: () => _handleNotificationTap(item),
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
