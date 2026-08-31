import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

// Demo Account Quick Fill Helper Chip
class DemoCredentialsChip extends StatelessWidget {
  final VoidCallback onFillCredentials;

  const DemoCredentialsChip({
    super.key,
    required this.onFillCredentials,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onFillCredentials,
        borderRadius: AppRadius.md,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF13294B) : AppColors.statusInfoBg,
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFBFDBFE),
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 18,
                color: AppColors.statusInfo,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tap to autofill demo account',
                      style: AppTypography.labelLarge.copyWith(
                        color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'demo@vendor.com • vendor123',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: AppColors.statusInfo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
