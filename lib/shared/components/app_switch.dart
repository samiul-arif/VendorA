import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';

// Custom Animated Toggle Switch (for Shop Open/Closed & Preferences)
class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? activeLabel;
  final String? inactiveLabel;
  final Color? activeColor;
  final bool isLoading;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeLabel,
    this.inactiveLabel,
    this.activeColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final primaryActiveColor = activeColor ?? colors.primary;
    final inactiveTrackColor = colors.surfaceSubtle;

    return ConstrainedBox(
      constraints: AppSpacing.minTouchConstraints,
      child: GestureDetector(
        onTap: isLoading ? null : () => onChanged(!value),
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 52,
              height: 30,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: AppRadius.full,
                color: value ? primaryActiveColor : inactiveTrackColor,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: isLoading
                        ? SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                value ? primaryActiveColor : colors.textMuted,
                              ),
                            ),
                          )
                        : Icon(
                            value ? Icons.check : Icons.close,
                            size: 14,
                            color: value ? primaryActiveColor : colors.textMuted,
                          ),
                  ),
                ),
              ),
            ),
            if (activeLabel != null || inactiveLabel != null) ...[
              const SizedBox(width: 10),
              Text(
                value ? (activeLabel ?? '') : (inactiveLabel ?? ''),
                style: TextStyle(
                  color: value
                      ? primaryActiveColor
                      : colors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
