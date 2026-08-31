import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

// Button Style Variants
enum AppButtonVariant {
  primary,     // Solid near-black pill (modern_ui_arif)
  brand,       // Vibrant food-tech magenta
  secondary,   // Neutral surface pill
  outline,     // Subtle border pill
  ghost,       // Text only
  destructive, // Error red
}

// Button Size Scale
enum AppButtonSize {
  small,  // 36dp height
  medium, // 46dp height
  large,  // 54dp height (Default CTA)
}

// Reusable App Button Component
class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final EdgeInsetsGeometry? customPadding;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.large,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.customPadding,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    // Resolve Dimensions
    final double height = switch (widget.size) {
      AppButtonSize.small => 38.0,
      AppButtonSize.medium => 46.0,
      AppButtonSize.large => 54.0,
    };

    final TextStyle textStyle = switch (widget.size) {
      AppButtonSize.small => AppTypography.buttonSmall,
      AppButtonSize.medium => AppTypography.buttonMedium,
      AppButtonSize.large => AppTypography.buttonLarge,
    };

    final EdgeInsetsGeometry padding = widget.customPadding ??
        switch (widget.size) {
          AppButtonSize.small => const EdgeInsets.symmetric(horizontal: 14),
          AppButtonSize.medium => const EdgeInsets.symmetric(horizontal: 20),
          AppButtonSize.large => const EdgeInsets.symmetric(horizontal: 24),
        };

    final colors = context.appColors;

    // Resolve Colors by Variant & Theme
    Color backgroundColor;
    Color foregroundColor;
    BorderSide? borderSide;

    switch (widget.variant) {
      case AppButtonVariant.primary:
        backgroundColor = colors.ctaPrimary;
        foregroundColor = colors.ctaPrimaryText;
        break;

      case AppButtonVariant.brand:
        backgroundColor = colors.primary;
        foregroundColor = colors.textInverse;
        break;

      case AppButtonVariant.secondary:
        backgroundColor = colors.ctaSecondary;
        foregroundColor = colors.ctaSecondaryText;
        break;

      case AppButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = colors.textPrimary;
        borderSide = BorderSide(
          color: colors.border,
          width: 1.5,
        );
        break;

      case AppButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = colors.primary;
        break;

      case AppButtonVariant.destructive:
        backgroundColor = colors.error;
        foregroundColor = colors.textInverse;
        break;
    }

    if (!isEnabled) {
      backgroundColor = colors.surfaceSubtle;
      foregroundColor = colors.textMuted;
      borderSide = null;
    }

    // Touch Target Wrapper (ui-ux-pro-max: min 48dp)
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: AppSpacing.minTouchTarget,
        minWidth: widget.isFullWidth ? double.infinity : AppSpacing.minTouchTarget,
      ),
      child: GestureDetector(
        onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: AppRadius.button,
              border: borderSide != null ? Border.fromBorderSide(borderSide) : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isEnabled ? widget.onPressed : null,
                borderRadius: AppRadius.button,
                child: Padding(
                  padding: padding,
                  child: Center(
                    child: widget.isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                            ),
                          )
                        : Row(
                            mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.leadingIcon != null) ...[
                                widget.leadingIcon!,
                                const SizedBox(width: 8),
                              ],
                              Flexible(
                                child: Text(
                                  widget.text,
                                  style: textStyle.copyWith(color: foregroundColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.trailingIcon != null) ...[
                                const SizedBox(width: 8),
                                widget.trailingIcon!,
                              ],
                            ],
                          ),
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
