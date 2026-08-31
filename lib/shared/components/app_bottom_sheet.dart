import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

// High-Radius Modal Bottom Sheet (modern_ui_arif Sheet Design)
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final bool showCloseButton;

  const AppBottomSheet({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(20, 0, 20, 24),
    this.showCloseButton = true,
  });

  // Static Helper to Display Bottom Sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    String? subtitle,
    Widget? trailing,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AppBottomSheet(
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.sheetTop,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.borderSubtle,
                  borderRadius: AppRadius.full,
                ),
              ),
            ),

            // Header (if title or close button present)
            if (title != null || showCloseButton) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null)
                            Text(
                              title!,
                              style: AppTypography.headlineSmall.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          if (subtitle != null) ...[
                            AppSpacing.vGap4,
                            Text(
                              subtitle!,
                              style: AppTypography.bodySmall.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trailing != null) trailing!,
                    if (showCloseButton)
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 22),
                        color: colors.textSecondary,
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Close',
                      ),
                  ],
                ),
              ),
              Divider(
                color: colors.divider,
                height: 1,
              ),
              AppSpacing.vGap16,
            ],

            // Body Content
            Padding(
              padding: padding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
