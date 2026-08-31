import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

// Toast Variants
enum AppToastVariant {
  success,
  error,
  warning,
  info;

  Color get color {
    switch (this) {
      case AppToastVariant.success:
        return const Color(0xFF10B981);
      case AppToastVariant.error:
        return AppColors.statusError;
      case AppToastVariant.warning:
        return const Color(0xFFF59E0B);
      case AppToastVariant.info:
        return AppColors.primary;
    }
  }

  Color get backgroundColorLight {
    switch (this) {
      case AppToastVariant.success:
        return const Color(0xFFECFDF5);
      case AppToastVariant.error:
        return const Color(0xFFFEF2F2);
      case AppToastVariant.warning:
        return const Color(0xFFFFFBEB);
      case AppToastVariant.info:
        return AppColors.primaryTint;
    }
  }

  Color get backgroundColorDark {
    switch (this) {
      case AppToastVariant.success:
        return const Color(0xFF0F3A2E);
      case AppToastVariant.error:
        return const Color(0xFF3B1414);
      case AppToastVariant.warning:
        return const Color(0xFF3A2E0F);
      case AppToastVariant.info:
        return const Color(0xFF3B1425);
    }
  }

  IconData get icon {
    switch (this) {
      case AppToastVariant.success:
        return Icons.check_circle_rounded;
      case AppToastVariant.error:
        return Icons.error_rounded;
      case AppToastVariant.warning:
        return Icons.warning_amber_rounded;
      case AppToastVariant.info:
        return Icons.notifications_active_rounded;
    }
  }
}

// Global Toast Manager with Floating Top Placement and Overlay Animation
class AppToast {
  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  static void show(
    BuildContext context, {
    required String title,
    String? message,
    AppToastVariant variant = AppToastVariant.info,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onTap,
  }) {
    // Dismiss any existing toast first
    dismiss();

    final overlay = Overlay.of(context, rootOverlay: true);

    _currentEntry = OverlayEntry(
      builder: (ctx) => _ToastOverlayWidget(
        title: title,
        message: message,
        variant: variant,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
        onTap: onTap,
        onDismissed: () => dismiss(),
      ),
    );

    overlay.insert(_currentEntry!);
  }

  static void showSuccess(
    BuildContext context, {
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onTap,
  }) {
    show(
      context,
      title: title,
      message: message,
      variant: AppToastVariant.success,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
      onTap: onTap,
    );
  }

  static void showError(
    BuildContext context, {
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onTap,
  }) {
    show(
      context,
      title: title,
      message: message,
      variant: AppToastVariant.error,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
      onTap: onTap,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onTap,
  }) {
    show(
      context,
      title: title,
      message: message,
      variant: AppToastVariant.warning,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
      onTap: onTap,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onTap,
  }) {
    show(
      context,
      title: title,
      message: message,
      variant: AppToastVariant.info,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
      onTap: onTap,
    );
  }

  static void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _ToastOverlayWidget extends StatefulWidget {
  final String title;
  final String? message;
  final AppToastVariant variant;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onTap;
  final VoidCallback onDismissed;

  const _ToastOverlayWidget({
    required this.title,
    this.message,
    required this.variant,
    required this.duration,
    this.actionLabel,
    this.onAction,
    this.onTap,
    required this.onDismissed,
  });

  @override
  State<_ToastOverlayWidget> createState() => _ToastOverlayWidgetState();
}

class _ToastOverlayWidgetState extends State<_ToastOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward();

    _timer = Timer(widget.duration, () {
      _dismiss();
    });
  }

  void _dismiss() async {
    _timer?.cancel();
    if (mounted) {
      await _animController.reverse();
      widget.onDismissed();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      top: topPadding + 10,
      left: 14,
      right: 14,
      child: SlideTransition(
        position: _slideAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.up,
            onDismissed: (_) => widget.onDismissed(),
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  if (widget.onTap != null) {
                    _dismiss();
                    widget.onTap!();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E242C) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Variant Icon Pill
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isDark
                              ? widget.variant.backgroundColorDark
                              : widget.variant.backgroundColorLight,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            widget.variant.icon,
                            size: 20,
                            color: widget.variant.color,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Content Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.message != null && widget.message!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                widget.message!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : const Color(0xFF4B5563),
                                  height: 1.25,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Optional Action Button
                      if (widget.actionLabel != null && widget.onAction != null) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            _dismiss();
                            widget.onAction!();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: widget.variant.color.withValues(alpha: 0.12),
                              borderRadius: AppRadius.full,
                            ),
                            child: Text(
                              widget.actionLabel!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: widget.variant.color,
                              ),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(width: 6),

                      // Close X
                      GestureDetector(
                        onTap: _dismiss,
                        child: Container(
                          width: 24,
                          height: 24,
                          color: Colors.transparent,
                          child: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: isDark
                                ? AppColors.textMutedDark
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
