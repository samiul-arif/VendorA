import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../controllers/profile_controller.dart';

// 3-Way Theme Mode Selector (System Default / Light Mode / Dark Mode)
class ThemeModeToggleTile extends StatelessWidget {
  const ThemeModeToggleTile({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final profileController = context.watch<ProfileController>();
    final currentMode = profileController.themeMode;

    final options = [
      {'mode': ThemeMode.light, 'label': 'Light', 'icon': Icons.light_mode_outlined, 'selectedIcon': Icons.light_mode_rounded},
      {'mode': ThemeMode.dark, 'label': 'Dark', 'icon': Icons.dark_mode_outlined, 'selectedIcon': Icons.dark_mode_rounded},
      {'mode': ThemeMode.system, 'label': 'System', 'icon': Icons.brightness_auto_outlined, 'selectedIcon': Icons.brightness_auto_rounded},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.palette_outlined,
                  size: 20,
                  color: colors.primary,
                ),
              ),
              AppSpacing.hGap14,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Display Theme',
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      currentMode == ThemeMode.system
                          ? 'Synchronized with device system settings'
                          : (currentMode == ThemeMode.dark ? 'Dark night theme active' : 'Bright daylight theme active'),
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          AppSpacing.vGap16,

          // 3-Way Segment Selector
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colors.surfaceSubtle,
              borderRadius: AppRadius.full,
              border: Border.all(
                color: colors.borderSubtle,
              ),
            ),
            child: Row(
              children: options.map((opt) {
                final mode = opt['mode'] as ThemeMode;
                final isSelected = currentMode == mode;
                final label = opt['label'] as String;
                final icon = isSelected ? (opt['selectedIcon'] as IconData) : (opt['icon'] as IconData);

                return Expanded(
                  child: GestureDetector(
                    onTap: () => profileController.setThemeMode(mode),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.ctaPrimary
                            : Colors.transparent,
                        borderRadius: AppRadius.full,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            size: 16,
                            color: isSelected
                                ? colors.ctaPrimaryText
                                : colors.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected
                                  ? colors.ctaPrimaryText
                                  : colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
