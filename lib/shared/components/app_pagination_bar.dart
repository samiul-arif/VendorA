import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_typography.dart';
import '../models/pagination_model.dart';

/// Reusable Merchant & Admin Dashboard Pagination Component
/// Follows Shopify Merchant, Foodpanda Partner, and Uber Merchant UI patterns.
class AppPaginationBar extends StatelessWidget {
  final PaginatedList pagination;
  final String itemLabelPlural; // e.g. "products", "orders"
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int>? onPageSizeChanged;
  final List<int> availablePageSizes;
  final bool isLoading;

  const AppPaginationBar({
    super.key,
    required this.pagination,
    required this.itemLabelPlural,
    required this.onPageChanged,
    this.onPageSizeChanged,
    this.availablePageSizes = const [10, 20, 50, 100],
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDark;

    if (pagination.totalItems == 0 && !isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: colors.borderSubtle),
        boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Top Row: Summary ("Showing 1–20 of 2,483 products") + Page Size Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Summary label
              Expanded(
                child: Row(
                  children: [
                    if (isLoading) ...[
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: Text(
                        pagination.showingSummary(itemLabelPlural),
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Page Size Selector
              if (onPageSizeChanged != null)
                _buildPageSizeSelector(context, colors, isDark),
            ],
          ),

          const SizedBox(height: 12),
          Divider(color: colors.divider, height: 1, thickness: 0.8),
          const SizedBox(height: 12),

          // 2. Bottom Row: Prev + Numbered Pages + Next + Quick Jump
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous Button
              _buildNavButton(
                context: context,
                label: 'Prev',
                icon: Icons.chevron_left_rounded,
                isLeft: true,
                isEnabled: pagination.hasPreviousPage && !isLoading,
                onTap: () {
                  if (pagination.hasPreviousPage && !isLoading) {
                    onPageChanged(pagination.currentPage - 1);
                  }
                },
                colors: colors,
              ),

              const SizedBox(width: 4),

              // Dynamic Numeric Page Pills with Smart Ellipses
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _buildPageButtons(context, colors),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 4),

              // Next Button
              _buildNavButton(
                context: context,
                label: 'Next',
                icon: Icons.chevron_right_rounded,
                isLeft: false,
                isEnabled: pagination.hasNextPage && !isLoading,
                onTap: () {
                  if (pagination.hasNextPage && !isLoading) {
                    onPageChanged(pagination.currentPage + 1);
                  }
                },
                colors: colors,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageSizeSelector(BuildContext context, AppSemanticColors colors, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: AppRadius.sm,
        border: Border.all(color: colors.borderSubtle, width: 0.8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: pagination.pageSize,
          isDense: true,
          icon: Icon(Icons.arrow_drop_down_rounded, size: 18, color: colors.textSecondary),
          dropdownColor: colors.surface,
          borderRadius: AppRadius.md,
          items: availablePageSizes.map((size) {
            return DropdownMenuItem<int>(
              value: size,
              child: Text(
                '$size / page',
                style: AppTypography.labelSmall.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            );
          }).toList(),
          onChanged: (newSize) {
            if (newSize != null && newSize != pagination.pageSize && !isLoading) {
              onPageSizeChanged?.call(newSize);
            }
          },
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isLeft,
    required bool isEnabled,
    required VoidCallback onTap,
    required AppSemanticColors colors,
  }) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: AppRadius.full,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: isEnabled ? 1.0 : 0.4,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isEnabled ? colors.surfaceLow : colors.surfaceSubtle.withValues(alpha: 0.5),
            borderRadius: AppRadius.full,
            border: Border.all(
              color: isEnabled ? colors.borderSubtle : Colors.transparent,
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLeft) Icon(icon, size: 16, color: colors.textPrimary),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: isEnabled ? colors.textPrimary : colors.textMuted,
                  fontWeight: FontWeight.w800,
                  fontSize: 11.5,
                ),
              ),
              if (!isLeft) Icon(icon, size: 16, color: colors.textPrimary),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageButtons(BuildContext context, AppSemanticColors colors) {
    final total = pagination.totalPages;
    final current = pagination.currentPage;

    if (total <= 1) {
      return [
        _buildPagePill(
          context: context,
          pageNumber: 1,
          isSelected: true,
          colors: colors,
        ),
      ];
    }

    final List<Widget> widgets = [];

    // Helper to generate a set of page numbers
    final Set<int> pagesToShow = {};

    // Always include page 1 and last page
    pagesToShow.add(1);
    pagesToShow.add(total);

    // Current and neighbors
    pagesToShow.add(current);
    if (current - 1 >= 1) pagesToShow.add(current - 1);
    if (current + 1 <= total) pagesToShow.add(current + 1);

    if (current <= 3) {
      pagesToShow.add(2);
      if (total >= 3) pagesToShow.add(3);
      if (total >= 4) pagesToShow.add(4);
    }
    if (current >= total - 2) {
      if (total - 1 >= 1) pagesToShow.add(total - 1);
      if (total - 2 >= 1) pagesToShow.add(total - 2);
      if (total - 3 >= 1) pagesToShow.add(total - 3);
    }

    final sortedPages = pagesToShow.where((p) => p >= 1 && p <= total).toList()..sort();

    int lastPrintedPage = 0;

    for (final page in sortedPages) {
      if (lastPrintedPage != 0 && page > lastPrintedPage + 1) {
        // Add Ellipsis with Jump Trigger
        widgets.add(_buildEllipsis(context, colors));
      }

      widgets.add(
        _buildPagePill(
          context: context,
          pageNumber: page,
          isSelected: page == current,
          colors: colors,
        ),
      );
      widgets.add(const SizedBox(width: 3));

      lastPrintedPage = page;
    }

    // Quick Jump Icon Trigger
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: Tooltip(
          message: 'Jump to specific page',
          child: InkWell(
            onTap: () => _showJumpToPageDialog(context, colors),
            borderRadius: AppRadius.full,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: colors.surfaceLow,
                shape: BoxShape.circle,
                border: Border.all(color: colors.borderSubtle, width: 0.8),
              ),
              child: Icon(Icons.swap_calls_rounded, size: 13, color: colors.primary),
            ),
          ),
        ),
      ),
    );

    return widgets;
  }

  Widget _buildPagePill({
    required BuildContext context,
    required int pageNumber,
    required bool isSelected,
    required AppSemanticColors colors,
  }) {
    return InkWell(
      onTap: isSelected || isLoading ? null : () => onPageChanged(pageNumber),
      borderRadius: AppRadius.full,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isSelected ? colors.ctaPrimary : Colors.transparent,
          borderRadius: AppRadius.full,
          border: isSelected
              ? null
              : Border.all(color: colors.borderSubtle.withValues(alpha: 0.5), width: 0.8),
        ),
        alignment: Alignment.center,
        child: Text(
          '$pageNumber',
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? colors.ctaPrimaryText : colors.textSecondary,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
            fontSize: 11.5,
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis(BuildContext context, AppSemanticColors colors) {
    return InkWell(
      onTap: () => _showJumpToPageDialog(context, colors),
      borderRadius: AppRadius.sm,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          '…',
          style: AppTypography.labelMedium.copyWith(
            color: colors.textMuted,
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _showJumpToPageDialog(BuildContext context, AppSemanticColors colors) {
    final controller = TextEditingController(text: '${pagination.currentPage}');

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
          title: Text(
            'Jump to Page',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter page number (1 to ${pagination.totalPages}):',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType: TextInputType.number,
                style: AppTypography.titleMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
                decoration: InputDecoration(
                  hintText: 'Page #',
                  filled: true,
                  fillColor: colors.surfaceLow,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.md,
                    borderSide: BorderSide(color: colors.borderSubtle),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.md,
                    borderSide: BorderSide(color: colors.primary, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(
                'Cancel',
                style: AppTypography.labelMedium.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                final page = int.tryParse(text);
                if (page != null && page >= 1 && page <= pagination.totalPages) {
                  Navigator.of(dialogCtx).pop();
                  onPageChanged(page);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.ctaPrimary,
                foregroundColor: colors.ctaPrimaryText,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.full,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              ),
              child: Text(
                'Go to Page',
                style: AppTypography.labelMedium.copyWith(
                  color: colors.ctaPrimaryText,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
