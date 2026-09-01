import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/analytics_summary_model.dart';

// Interactive Revenue Overview Bar Chart matching Stitch specs
class InteractiveBarChart extends StatefulWidget {
  final List<RevenueBarPoint> points;
  final int? selectedIndex;
  final ValueChanged<int> onBarTapped;

  const InteractiveBarChart({
    super.key,
    required this.points,
    this.selectedIndex,
    required this.onBarTapped,
  });

  @override
  State<InteractiveBarChart> createState() => _InteractiveBarChartState();
}

class _InteractiveBarChartState extends State<InteractiveBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant InteractiveBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.points != widget.points) {
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = colors.surface;
    final primaryColor = colors.primary;
    final borderColor = isDark ? const Color(0xFF2C3039) : const Color(0xFFDFE2EE);
    final gridLineColor = isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFDFE2EE).withValues(alpha: 0.5);

    // Calculate max amount for Y-axis scaling
    double maxAmount = 1000.0;
    for (final p in widget.points) {
      if (p.amount > maxAmount) maxAmount = p.amount;
    }
    final yMax = (maxAmount * 1.15).ceilToDouble();
    final yStep1 = yMax * 0.75;
    final yStep2 = yMax * 0.50;
    final yStep3 = yMax * 0.25;

    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: AppRadius.lg,
        border: Border.all(color: borderColor.withValues(alpha: 0.7), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(21, 23, 28, 0.04),
            offset: Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revenue Overview',
                style: AppTypography.titleMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: colors.textSecondary,
                  size: 20,
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Chart Area
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                // Horizontal Grid Lines & Y-Axis Labels
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGridLine(_formatYLabel(yMax), gridLineColor, isDark),
                      _buildGridLine(_formatYLabel(yStep1), gridLineColor, isDark),
                      _buildGridLine(_formatYLabel(yStep2), gridLineColor, isDark),
                      _buildGridLine(_formatYLabel(yStep3), gridLineColor, isDark),
                      _buildGridLine('৳0', gridLineColor, isDark),
                    ],
                  ),
                ),

                // Animated Bars & Interactive Tap targets
                Positioned(
                  left: 36,
                  right: 8,
                  top: 10,
                  bottom: 0,
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(widget.points.length, (index) {
                          final point = widget.points[index];
                          final isSelected = (widget.selectedIndex == index);
                          final barHeightRatio = (point.amount / yMax).clamp(0.05, 1.0);
                          final animatedHeight = 160.0 * barHeightRatio * _scaleAnimation.value;

                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => widget.onBarTapped(index),
                            child: SizedBox(
                              width: 38,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Floating Tooltip above active bar
                                  if (isSelected)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFFEDF0FC)
                                            : const Color(0xFF2C3039),
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(0, 2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '৳${point.amount.toStringAsFixed(0)}',
                                        style: AppTypography.labelSmall.copyWith(
                                          color: isDark
                                              ? const Color(0xFF171C24)
                                              : Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  else
                                    const SizedBox(height: 22),

                                  // Bar
                                  Container(
                                    height: animatedHeight,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? primaryColor
                                          : primaryColor.withValues(alpha: 0.22),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(6),
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: primaryColor.withValues(alpha: 0.4),
                                                blurRadius: 10,
                                                offset: const Offset(0, -2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // X-Axis Label
                                  Text(
                                    point.label,
                                    style: AppTypography.labelSmall.copyWith(
                                      fontSize: 10,
                                      color: isSelected
                                          ? primaryColor
                                          : colors.textSecondary,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridLine(String label, Color gridLineColor, bool isDark) {
    return Row(
      children: [
        SizedBox(
          width: 32,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFF8E92A0) : const Color(0xFF8E6F76),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: gridLineColor,
          ),
        ),
      ],
    );
  }

  String _formatYLabel(double amount) {
    if (amount >= 1000) {
      return '৳${(amount / 1000).toStringAsFixed(1)}k';
    }
    return '৳${amount.toInt()}';
  }
}
