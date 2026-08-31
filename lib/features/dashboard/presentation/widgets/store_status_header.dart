import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../../features/shop/presentation/controllers/shop_controller.dart';
import '../../../../features/notifications/presentation/controllers/notification_controller.dart';
import '../../../../features/notifications/domain/models/notification_type.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../../core/routing/app_routes.dart';

/// Top Store Header matching Stitch brief (`dashboard/code.html`)
/// with Avatar, Greeting, Shop Name, Status Card & Notification trigger.
class StoreStatusHeader extends StatefulWidget {
  final VoidCallback onSwitchShopRequested;

  const StoreStatusHeader({
    super.key,
    required this.onSwitchShopRequested,
  });

  @override
  State<StoreStatusHeader> createState() => _StoreStatusHeaderState();
}

class _StoreStatusHeaderState extends State<StoreStatusHeader> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final authController = context.watch<AuthController>();
    final shopController = context.watch<ShopController>();
    final notifController = context.watch<NotificationController>();

    final shop = shopController.currentShop ?? authController.activeShop;
    final isStoreOpen = shop?.isOpen ?? true;
    final unreadCount = notifController.unreadCount;

    final rawName = shop?.name ?? 'Jane\'s Bakery';
    final cleanName = rawName.contains('(') ? rawName.split('(').first.trim() : rawName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top App Bar Row for Mobile
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Avatar & Greeting & Store Name
            Expanded(
              child: GestureDetector(
                onTap: widget.onSwitchShopRequested,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    // Store Avatar / Logo Badge
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.primaryContainer.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.storefront_rounded,
                          color: colors.primary,
                          size: 24,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Greeting & Shop Name with Dropdown Arrow
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  cleanName,
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                    color: colors.textPrimary,
                                    letterSpacing: -0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: colors.textMuted,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Notification Bell
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.notifications);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.borderSubtle),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF15171C).withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      size: 20,
                      color: colors.textPrimary,
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        top: 9,
                        right: 9,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colors.error,
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.surface, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Shop Status Banner Card matching Stitch brief
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.borderSubtle),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF15171C).withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Live Pulsing Dot + Status Label
              Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            if (isStoreOpen)
                              Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF006B57).withValues(alpha: 0.35),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isStoreOpen ? const Color(0xFF006B57) : colors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isStoreOpen ? 'Shop is Open' : 'Shop is Paused',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),

              // Switch Toggle
              Transform.scale(
                scale: 0.85,
                child: Switch.adaptive(
                  value: isStoreOpen,
                  activeThumbColor: const Color(0xFF006B57), // secondary
                  activeTrackColor: const Color(0xFF75F9D6),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: colors.surfaceSubtle,
                  onChanged: (val) {
                    shopController.toggleStoreStatus(val, authController: authController);
                    final notif = context.read<NotificationController>();

                    if (val) {
                      notif.dispatchNotification(
                        context,
                        title: 'Shop Opened',
                        message: 'Your kitchen is live and accepting incoming customer orders.',
                        type: NotificationType.system,
                        toastVariant: AppToastVariant.success,
                      );
                    } else {
                      notif.dispatchNotification(
                        context,
                        title: 'Shop Paused',
                        message: 'Store marked offline. Orders are temporarily paused.',
                        type: NotificationType.system,
                        toastVariant: AppToastVariant.warning,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
