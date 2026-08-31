import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/app_permission_type.dart';

// Permission Rationale Dialog (modern_ui_arif Modal Architecture)
class PermissionRationaleDialog extends StatelessWidget {
  final AppPermissionType permissionType;
  final VoidCallback onAllow;
  final VoidCallback onDeny;

  const PermissionRationaleDialog({
    super.key,
    required this.permissionType,
    required this.onAllow,
    required this.onDeny,
  });

  static Future<bool?> show({
    required BuildContext context,
    required AppPermissionType permissionType,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PermissionRationaleDialog(
        permissionType: permissionType,
        onAllow: () => Navigator.of(ctx).pop(true),
        onDeny: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colors.borderSubtle,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: context.isDark ? 0.4 : 0.12),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Pill Container
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: permissionType.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  permissionType.icon,
                  size: 28,
                  color: permissionType.color,
                ),
              ),
            ),

            AppSpacing.vGap16,

            // Title
            Text(
              permissionType.title,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w900,
                color: colors.textPrimary,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),

            AppSpacing.vGap8,

            // Rationale Message
            Text(
              permissionType.rationalePrompt,
              style: TextStyle(
                fontSize: 12,
                color: colors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            AppSpacing.vGap24,

            // Primary CTA: "Allow Access"
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: onAllow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.full,
                  ),
                ),
                child: const Text(
                  'Allow Access',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            AppSpacing.vGap8,

            // Secondary: "Not Now"
            SizedBox(
              width: double.infinity,
              height: 38,
              child: TextButton(
                onPressed: onDeny,
                child: Text(
                  'Not Now',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: colors.textMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
