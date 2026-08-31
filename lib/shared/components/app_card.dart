import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';

// High-Radius Surface Card (modern_ui_arif Card-First Architecture)
class AppCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final bool hasBorder;
  final bool hasShadow;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = AppSpacing.cardPadding,
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.gradient,
    this.borderRadius,
    this.hasBorder = true,
    this.hasShadow = true,
    this.width,
    this.height,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDark;
    final isInteractive = widget.onTap != null;

    final radius = widget.borderRadius ?? AppRadius.card;
    final bgColor = widget.backgroundColor ?? colors.surface;

    final shadows = widget.hasShadow
        ? (isDark ? AppShadows.darkCard : (_isPressed ? AppShadows.elevated : AppShadows.card))
        : <BoxShadow>[];

    final cardContent = AnimatedScale(
      scale: (_isPressed && isInteractive) ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: widget.gradient == null ? bgColor : null,
          gradient: widget.gradient,
          borderRadius: radius,
          boxShadow: shadows,
          border: widget.hasBorder
              ? Border.all(
                  color: colors.border,
                  width: 1.0,
                )
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: isInteractive
              ? InkWell(
                  onTap: widget.onTap,
                  borderRadius: radius,
                  child: Padding(
                    padding: widget.padding,
                    child: widget.child,
                  ),
                )
              : Padding(
                  padding: widget.padding,
                  child: widget.child,
                ),
        ),
      ),
    );

    if (isInteractive) {
      return GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: cardContent,
      );
    }

    return cardContent;
  }
}
