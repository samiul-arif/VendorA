import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../controllers/profile_controller.dart';

// 3-Way Theme Mode Selector (System Default / Light Mode / Dark Mode)
class ThemeModeToggleTile extends StatelessWidget {
  const ThemeModeToggleTile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
                  color: isDark ? const Color(0xFF381223) : AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.palette_outlined,
                  size: 20,
                  color: AppColors.primary,
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
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      currentMode == ThemeMode.system
                          ? 'Synchronized with device system settings'
                          : (currentMode == ThemeMode.dark ? 'Dark night theme active' : 'Bright daylight theme active'),
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
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
              color: isDark ? const Color(0xFF232A34) : AppColors.lightSurfaceSubtle,
              borderRadius: AppRadius.full,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.borderLight,
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
                            ? (isDark ? Colors.white : AppColors.ctaPrimary)
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
                                ? (isDark ? AppColors.ctaPrimary : Colors.white)
                                : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected
                                  ? (isDark ? AppColors.ctaPrimary : Colors.white)
                                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
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
