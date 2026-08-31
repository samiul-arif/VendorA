import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';

// Animated Shimmer Skeleton Placeholder (ui-ux-pro-max loading feedback)
class ShimmerSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final ShapeBorder? shape;

  const ShimmerSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape,
  });

  const ShimmerSkeleton.circular({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = null,
        shape = const CircleBorder();

  const ShimmerSkeleton.card({
    super.key,
    this.width = double.infinity,
    this.height = 120.0,
  })  : borderRadius = AppRadius.card,
        shape = null;

  const ShimmerSkeleton.line({
    super.key,
    this.width = double.infinity,
    this.height = 14.0,
  })  : borderRadius = AppRadius.sm,
        shape = null;

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark ? const Color(0xFF1E242C) : const Color(0xFFE8ECEF);
    final highlightColor = isDark ? const Color(0xFF2B333E) : const Color(0xFFF7F9FA);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: ShapeDecoration(
            shape: widget.shape ??
                RoundedRectangleBorder(
                  borderRadius: widget.borderRadius ?? AppRadius.md,
                ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((s) => s.clamp(0.0, 1.0)).toList(),
              colors: [baseColor, highlightColor, baseColor],
            ),
          ),
        );
      },
    );
  }
}
