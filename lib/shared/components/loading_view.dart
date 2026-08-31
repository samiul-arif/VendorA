import 'package:flutter/material.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

// Centered Loading View
class LoadingView extends StatelessWidget {
  final String? message;
  final bool isTransparent;

  const LoadingView({
    super.key,
    this.message,
    this.isTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Container(
      color: isTransparent
          ? Colors.transparent
          : theme.scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 38,
                height: 38,
                child: CircularProgressIndicator(
                  strokeWidth: 3.5,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                ),
              ),
              if (message != null) ...[
                AppSpacing.vGap16,
                Text(
                  message!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
