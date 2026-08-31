import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
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
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onFillCredentials,
        borderRadius: AppRadius.md,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: colors.infoBg,
            borderRadius: AppRadius.md,
            border: Border.all(
              color: colors.info.withValues(alpha: 0.3),
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 18,
                color: colors.info,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tap to autofill demo account',
                      style: AppTypography.labelLarge.copyWith(
                        color: colors.info,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'demo@vendor.com • vendor123',
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.info.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: colors.info,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
