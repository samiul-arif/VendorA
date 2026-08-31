import 'package:flutter/material.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_shadows.dart';

// macOS/iOS-Inspired Premium Circular Back Button Component
class AppCircularBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? iconColor;

  const AppCircularBackButton({
    super.key,
    this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDark;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed ?? () => Navigator.of(context).maybePop(),
          customBorder: const CircleBorder(),
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.borderSubtle,
                  width: 1.0,
                ),
                boxShadow: isDark
                    ? AppShadows.darkCard
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 15,
                    color: iconColor ?? colors.textPrimary,
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
