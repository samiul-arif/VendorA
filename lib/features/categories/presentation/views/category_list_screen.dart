import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/components/app_bottom_sheet.dart';
import '../../../../shared/components/app_dialog.dart';
import '../../../../shared/components/empty_state_view.dart';
import '../../../../shared/components/error_state_view.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../../shared/components/app_circular_back_button.dart';
import '../../../../shared/components/app_header_action_button.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../notifications/domain/models/notification_type.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/models/category_model.dart';
import '../controllers/category_controller.dart';
import '../widgets/category_card.dart';
import '../widgets/add_edit_category_bottom_sheet.dart';

// Category Management Screen
class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCategories() {
    final authController = context.read<AuthController>();
    final categoryController = context.read<CategoryController>();
    final shopId = authController.activeShop?.id ?? 'shop_01';
    categoryController.loadCategories(shopId: shopId);
  }

  void _showAddEditBottomSheet([CategoryModel? category]) {
    final categoryController = context.read<CategoryController>();
    final isEdit = category != null;

    AppBottomSheet.show(
      context: context,
      title: isEdit ? 'Edit Category' : 'Add New Category',
      subtitle: isEdit
          ? 'Update category details and menu organization'
          : 'Define a new menu category for your store items',
      child: AddEditCategoryBottomSheet(
        categoryToEdit: category,
        onSave: (name, description) async {
          final result = isEdit
              ? await categoryController.updateCategory(
                  category: category,
                  newName: name,
                  newDescription: description,
                )
              : await categoryController.addCategory(
                  name: name,
                  description: description,
                );

          if (!mounted) return;

          result.when(
            success: (_) {
              context.read<NotificationController>().dispatchNotification(
                context,
                title: isEdit ? 'Category Updated' : 'Category Created',
                message: isEdit
                    ? 'Changes saved to category "$name".'
                    : 'Category "$name" is now available for grouping items.',
                type: NotificationType.stock,
                toastVariant: AppToastVariant.success,
              );
            },
            failure: (msg, _) {
              AppToast.showError(context, title: 'Category Failed', message: msg);
            },
          );
        },
      ),
    );
  }

  void _handleDeleteCategory(CategoryModel category) async {
    final confirmed = await AppDialog.showConfirmation(
      context: context,
      title: 'Delete Category',
      message:
          'Are you sure you want to delete "${category.name}"? Products in this category will become unassigned.',
      confirmText: 'Delete',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      final categoryController = context.read<CategoryController>();
      final catName = category.name;
      final result = await categoryController.deleteCategory(category.id);

      if (!mounted) return;

      result.when(
        success: (_) {
          context.read<NotificationController>().dispatchNotification(
            context,
            title: 'Category Removed',
            message: 'Category "$catName" has been deleted.',
            type: NotificationType.stock,
            toastVariant: AppToastVariant.warning,
          );
        },
        failure: (msg, _) {
          AppToast.showError(context, title: 'Delete Failed', message: msg);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categoryController = context.watch<CategoryController>();
    final categories = categoryController.filteredCategories;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF161B22) : const Color(0xFFFFFFFF),
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 56,
        leading: const AppCircularBackButton(),
        title: Text(
          'Store Categories',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        actions: [
          AppHeaderActionButton(
            text: 'Add Category',
            icon: Icons.add_rounded,
            onPressed: () => _showAddEditBottomSheet(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: isDark ? AppColors.darkBorder : const Color(0xFFEEF0F2),
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: categoryController.isLoading && categoryController.categories.isEmpty
            ? const _CategorySkeletonLoading()
            : categoryController.hasError && categoryController.categories.isEmpty
                ? ErrorStateView(
                    message: categoryController.errorMessage ?? 'Failed to load categories.',
                    onRetry: _loadCategories,
                  )
                : RefreshIndicator(
                    onRefresh: () async => _loadCategories(),
                    color: AppColors.primary,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                      children: [
                        // Search Bar Container
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : Colors.white,
                            borderRadius: AppRadius.full,
                            border: Border.all(
                              color: isDark ? const Color(0xFF2D3748) : AppColors.borderLight,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => categoryController.setSearchQuery(val),
                            decoration: InputDecoration(
                              hintText: 'Search categories...',
                              prefixIcon: const Icon(Icons.search_rounded, size: 20),
                              suffixIcon: categoryController.searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close_rounded, size: 18),
                                      onPressed: () {
                                        _searchController.clear();
                                        categoryController.clearSearch();
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),

                        AppSpacing.vGap16,

                        // Categories Count Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'All Categories (${categories.length})',
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                            Text(
                              'Organize Menu',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.textMutedDark
                                    : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),

                        AppSpacing.vGap12,

                        // Empty State if no results
                        if (categories.isEmpty)
                          EmptyStateView(
                            icon: Icons.category_outlined,
                            title: 'No Categories Found',
                            description: categoryController.searchQuery.isNotEmpty
                                ? 'No category matches "${categoryController.searchQuery}".'
                                : 'Create menu categories to organize and group your food items.',
                            actionButtonText: categoryController.searchQuery.isNotEmpty
                                ? 'Clear Search'
                                : '+ Create Category',
                            onActionButtonPressed: () {
                              if (categoryController.searchQuery.isNotEmpty) {
                                _searchController.clear();
                                categoryController.clearSearch();
                              } else {
                                _showAddEditBottomSheet();
                              }
                            },
                          )
                        else
                          // Category Cards List
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categories.length,
                            separatorBuilder: (_, __) => AppSpacing.vGap12,
                            itemBuilder: (context, index) {
                              final cat = categories[index];
                              return CategoryCard(
                                category: cat,
                                onEdit: () => _showAddEditBottomSheet(cat),
                                onDelete: () => _handleDeleteCategory(cat),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditBottomSheet(),
        backgroundColor: AppColors.ctaPrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text(
          'Add Category',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

// Skeleton Placeholder
class _CategorySkeletonLoading extends StatelessWidget {
  const _CategorySkeletonLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        const ShimmerSkeleton(width: double.infinity, height: 48, borderRadius: AppRadius.full),
        AppSpacing.vGap16,
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerSkeleton(width: 140, height: 16),
            ShimmerSkeleton(width: 80, height: 16),
          ],
        ),
        AppSpacing.vGap12,
        ...List.generate(
          4,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: ShimmerSkeleton(
              width: double.infinity,
              height: 110,
              borderRadius: AppRadius.card,
            ),
          ),
        ),
      ],
    );
  }
}
