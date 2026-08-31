import 'package:flutter/material.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/components/app_card.dart';

// Grouped Settings Card with Item Rows
class SettingsGroupCard extends StatelessWidget {
  final String title;
  final List<SettingsTileItem> items;

  const SettingsGroupCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: colors.textMuted,
            ),
          ),
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: items.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              final isLast = idx == items.length - 1;

              return Column(
                children: [
                  InkWell(
                    onTap: item.onTap,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          // Leading Icon Accent
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: item.iconColor != null
                                  ? item.iconColor!.withValues(alpha: 0.12)
                                  : colors.primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              item.icon,
                              size: 20,
                              color: item.iconColor ?? colors.primary,
                            ),
                          ),

                          AppSpacing.hGap14,

                          // Title and Subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: AppTypography.titleSmall.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: item.isDestructive
                                        ? colors.error
                                        : colors.textPrimary,
                                  ),
                                ),
                                if (item.subtitle != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    item.subtitle!,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: colors.textMuted,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Trailing Widget or Default Chevron
                          if (item.trailing != null)
                            item.trailing!
                          else if (item.onTap != null)
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: colors.textMuted,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 68,
                      endIndent: 16,
                      color: colors.divider,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class SettingsTileItem {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  const SettingsTileItem({
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });
}
