import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryActiveColor = activeColor ?? AppColors.primary;
    final inactiveTrackColor = isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFE5E7EB);

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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x26000000),
                        offset: Offset(0, 2),
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
                                value ? primaryActiveColor : AppColors.textSecondaryLight,
                              ),
                            ),
                          )
                        : Icon(
                            value ? Icons.check : Icons.close,
                            size: 14,
                            color: value ? primaryActiveColor : AppColors.textMutedLight,
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
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
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
