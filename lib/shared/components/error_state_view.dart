import 'package:flutter/material.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import 'app_button.dart';

// Error State Display Component
class ErrorStateView extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback? onRetry;
  final String retryButtonText;
  final IconData icon;

  const ErrorStateView({
    super.key,
    this.title,
    required this.message,
    this.onRetry,
    this.retryButtonText = 'Try Again',
    this.icon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.errorBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 34,
                color: colors.error,
              ),
            ),
            AppSpacing.vGap20,
            Text(
              title ?? 'Something Went Wrong',
              style: AppTypography.headlineSmall.copyWith(
                color: colors.textPrimary,
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
            if (onRetry != null) ...[
              AppSpacing.vGap24,
              AppButton(
                text: retryButtonText,
                onPressed: onRetry,
                size: AppButtonSize.medium,
                isFullWidth: false,
                leadingIcon: const Icon(Icons.refresh, size: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
