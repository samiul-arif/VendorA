import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'app_bottom_sheet.dart';

// Generic Option Item for Shared Select Modal
class SelectOptionItem<T> {
  final T value;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;

  const SelectOptionItem({
    required this.value,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
  });
}

// Shared Select Modal
class SharedSelectModal<T> extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<SelectOptionItem<T>> options;
  final T? selectedValue;
  final bool showSearch;

  const SharedSelectModal({
    super.key,
    required this.title,
    this.subtitle,
    required this.options,
    this.selectedValue,
    this.showSearch = false,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required List<SelectOptionItem<T>> options,
    T? selectedValue,
    bool showSearch = false,
  }) async {
    return await AppBottomSheet.show<T>(
      context: context,
      title: title,
      subtitle: subtitle,
      child: SharedSelectModal<T>(
        title: title,
        subtitle: subtitle,
        options: options,
        selectedValue: selectedValue,
        showSearch: showSearch,
      ),
    );
  }

  @override
  State<SharedSelectModal<T>> createState() => _SharedSelectModalState<T>();
}

class _SharedSelectModalState<T> extends State<SharedSelectModal<T>> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredOptions = widget.options.where((opt) {
      if (_searchQuery.isEmpty) return true;
      return opt.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (opt.subtitle?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showSearch) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF232A34) : AppColors.lightSurfaceSubtle,
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.borderLight,
              ),
            ),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              decoration: const InputDecoration(
                hintText: 'Search options...',
                prefixIcon: Icon(Icons.search_rounded, size: 18),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
        ],

        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 340),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: filteredOptions.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
            itemBuilder: (context, index) {
              final item = filteredOptions[index];
              final isSelected = widget.selectedValue == item.value;

              return InkWell(
                onTap: () => Navigator.of(context).pop(item.value),
                borderRadius: AppRadius.md,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Row(
                    children: [
                      if (item.icon != null) ...[
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: item.iconColor != null
                                ? item.iconColor!.withValues(alpha: 0.12)
                                : (isDark ? const Color(0xFF232A34) : AppColors.primaryTint),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item.icon,
                            size: 18,
                            color: item.iconColor ?? AppColors.primary,
                          ),
                        ),
                        AppSpacing.hGap12,
                      ],

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                              ),
                            ),
                            if (item.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle!,
                                style: AppTypography.bodySmall.copyWith(
                                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      if (isSelected)
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        )
                      else
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                              width: 1.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
