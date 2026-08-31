import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_semantic_colors.dart';

// Animated Shimmer Skeleton Placeholder
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
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final baseColor = colors.shimmerBase;
    final highlightColor = colors.shimmerHighlight;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final slide = _controller.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: ShapeDecoration(
            shape: widget.shape ??
                RoundedRectangleBorder(
                  borderRadius: widget.borderRadius ?? AppRadius.md,
                ),
            gradient: LinearGradient(
              begin: Alignment(-2.0 + (slide * 4.0), -0.5),
              end: Alignment(-0.5 + (slide * 4.0), 0.5),
              colors: [baseColor, highlightColor, baseColor],
            ),
          ),
        );
      },
    );
  }
}
