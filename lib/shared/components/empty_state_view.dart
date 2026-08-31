import 'package:flutter/material.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import 'app_button.dart';

// Empty State Display Component
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionButtonText;
  final VoidCallback? onActionButtonPressed;
  final Color? iconColor;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionButtonText,
    this.onActionButtonPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final primaryColor = iconColor ?? colors.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 38,
                color: primaryColor,
              ),
            ),
            AppSpacing.vGap24,
            Text(
              title,
              style: AppTypography.headlineMedium.copyWith(
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vGap8,
            Text(
              description,
              style: AppTypography.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionButtonText != null && onActionButtonPressed != null) ...[
              AppSpacing.vGap24,
              AppButton(
                text: actionButtonText!,
                onPressed: onActionButtonPressed,
                size: AppButtonSize.medium,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
