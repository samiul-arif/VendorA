import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import 'app_button.dart';

// Confirmation & Destructive Action Dialog (modern_ui_arif High-Radius Modal)
class AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final IconData? icon;
  final bool isLoading;

  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.icon,
    this.isLoading = false,
  });

  // Static Helper to Show Confirmation Modal
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
    IconData? icon,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AppDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        icon: icon ?? (isDestructive ? Icons.warning_amber_rounded : Icons.info_outline),
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final headerIconBg = isDestructive ? colors.errorBg : colors.primaryContainer;
    final headerIconColor = isDestructive ? colors.error : colors.primary;

    return Dialog(
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.xl),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: headerIconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: headerIconColor,
                ),
              ),
              AppSpacing.vGap16,
            ],
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vGap8,
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vGap24,
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: cancelText,
                    variant: AppButtonVariant.secondary,
                    size: AppButtonSize.medium,
                    onPressed: isLoading ? null : (onCancel ?? () => Navigator.of(context).pop(false)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    text: confirmText,
                    variant: isDestructive ? AppButtonVariant.destructive : AppButtonVariant.primary,
                    size: AppButtonSize.medium,
                    isLoading: isLoading,
                    onPressed: onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
