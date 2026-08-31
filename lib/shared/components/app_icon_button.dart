import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';

// Reusable Circular / Rounded Icon Button
class AppIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final int badgeCount;
  final bool hasBorder;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.iconColor,
    this.size = 48.0, // Minimum touch target standard
    this.iconSize = 22.0,
    this.badgeCount = 0,
    this.hasBorder = false,
  });

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isEnabled = widget.onPressed != null;

    final bgColor = widget.backgroundColor ?? colors.surfaceSubtle;
    final fgColor = widget.iconColor ?? colors.textPrimary;

    final buttonWidget = GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: widget.hasBorder
                ? Border.all(
                    color: colors.border,
                    width: 1.0,
                  )
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: widget.onPressed,
              customBorder: const CircleBorder(),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: widget.iconSize,
                    color: isEnabled ? fgColor : colors.textMuted,
                  ),
                  if (widget.badgeCount > 0)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: AppRadius.full,
                          border: Border.all(
                            color: colors.surface,
                            width: 1.5,
                          ),
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          widget.badgeCount > 99 ? '99+' : '${widget.badgeCount}',
                          style: TextStyle(
                            color: colors.textInverse,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return ConstrainedBox(
      constraints: AppSpacing.minTouchConstraints,
      child: widget.tooltip != null
          ? Tooltip(message: widget.tooltip!, child: buttonWidget)
          : buttonWidget,
    );
  }
}
