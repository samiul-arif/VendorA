import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../../features/shop/presentation/controllers/shop_controller.dart';
import '../../../../features/notifications/presentation/controllers/notification_controller.dart';
import '../../../../features/notifications/domain/models/notification_type.dart';
import '../../../../shared/components/app_toast.dart';

/// Top Store Header & Status Row matching Stitch brief (`dashboard/code.html`)
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
    final isDark = context.isDark;

    final authController = context.watch<AuthController>();
    final shopController = context.watch<ShopController>();

    final shop = shopController.currentShop ?? authController.activeShop;
    final isStoreOpen = shop?.isOpen ?? true;

    final rawName = shop?.name ?? 'Jane\'s Bakery';
    final cleanName = rawName.contains('(') ? rawName.split('(').first.trim() : rawName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Welcome Row: Avatar, Greeting & Store Name (Tappable to switch shop)
        GestureDetector(
          onTap: widget.onSwitchShopRequested,
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              // Store Avatar / Logo Badge
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.borderSubtle,
                    width: 1.2,
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

              AppSpacing.hGap12,

              // Greeting & Shop Name with dropdown indicator
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: AppTypography.bodyMedium.copyWith(
                        color: colors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            cleanName,
                            style: AppTypography.headlineMedium.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AppSpacing.hGap4,
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

        AppSpacing.vGap14,

        // 2. Shop Status Card matching Stitch brief (`dashboard/code.html`)
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: AppRadius.md,
            border: Border.all(color: colors.borderSubtle),
            boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Live Pulsing Indicator + Status Text
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
                                    color: colors.secondary.withValues(alpha: 0.35),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isStoreOpen ? colors.secondary : colors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  AppSpacing.hGap10,
                  Text(
                    isStoreOpen ? 'Shop is Open' : 'Shop is Paused',
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),

              // Status Switch Toggle
              Transform.scale(
                scale: 0.85,
                child: Switch.adaptive(
                  value: isStoreOpen,
                  activeThumbColor: colors.secondary,
                  activeTrackColor: colors.secondaryContainer,
                  inactiveThumbColor: colors.surface,
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
