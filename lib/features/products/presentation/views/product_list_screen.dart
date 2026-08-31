import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_bottom_sheet.dart';
import '../../../../shared/components/empty_state_view.dart';
import '../../../../shared/components/error_state_view.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../notifications/domain/models/notification_type.dart';
import '../../../../shared/components/app_toast.dart';
import '../../domain/models/product_model.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/product_search_bar.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/quick_restock_bottom_sheet.dart';
import 'add_edit_product_screen.dart';

// Product Catalog & Inventory Screen (Content-First Merchant Layout)
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  void _loadProducts() {
    final authController = context.read<AuthController>();
    final productController = context.read<ProductController>();
    final shopId = authController.activeShop?.id ?? 'shop_01';
    productController.loadProducts(shopId: shopId);
  }

  void _showRestockModal(ProductModel product) {
    final productController = context.read<ProductController>();

    AppBottomSheet.show(
      context: context,
      title: 'Restock Inventory',
      subtitle: 'Add units to available physical store stock',
      child: QuickRestockBottomSheet(
        product: product,
        onRestockConfirmed: (quantity) async {
          final result = await productController.restockProduct(product.id, quantity);
          if (!mounted) return;

          result.when(
            success: (updated) {
              context.read<NotificationController>().dispatchNotification(
                context,
                title: 'Stock Updated',
                message: 'Added +$quantity units to ${product.name}. Total stock: ${updated.stockQuantity}.',
                type: NotificationType.stock,
                toastVariant: AppToastVariant.success,
              );
            },
            failure: (msg, _) {
              AppToast.showError(context, title: 'Restock Failed', message: msg);
            },
          );
        },
      ),
    );
  }

  void _openAddEditScreen([ProductModel? product]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddEditProductScreen(productToEdit: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final productController = context.watch<ProductController>();
    final filteredProducts = productController.filteredProducts;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
      body: SafeArea(
        bottom: false,
        child: productController.isLoading && productController.products.isEmpty
            ? const _ProductGridSkeleton()
            : productController.hasError && productController.products.isEmpty
                ? ErrorStateView(
                    message: productController.errorMessage ?? 'Failed to load products.',
                    onRetry: _loadProducts,
                  )
                : RefreshIndicator(
                    onRefresh: () async => _loadProducts(),
                    color: AppColors.primary,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 130),
                      children: [
                        // Content-First Header (Scrollable Merchant Title)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product Catalog',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.4,
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${filteredProducts.length} items in inventory',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.textMutedDark : const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        AppSpacing.vGap16,

                        // Search Bar (Standard Input Box Style)
                        ProductSearchBar(
                          initialQuery: productController.searchQuery,
                          onQueryChanged: (q) => productController.setSearchQuery(q),
                          onClear: () => productController.clearSearch(),
                        ),

                        AppSpacing.vGap12,

                        // Horizontal Category Filter Pills
                        CategoryFilterBar(
                          categories: productController.categories,
                          selectedCategoryId: productController.selectedCategoryId,
                          onCategorySelected: (catId) =>
                              productController.setCategoryFilter(catId),
                        ),

                        AppSpacing.vGap16,

                        // Empty State if no matches found
                        if (filteredProducts.isEmpty)
                          EmptyStateView(
                            icon: Icons.inventory_2_outlined,
                            title: 'No Products Found',
                            description: productController.searchQuery.isNotEmpty
                                ? 'No items match "${productController.searchQuery}".'
                                : 'Add your first menu item to begin accepting orders.',
                            actionButtonText: productController.searchQuery.isNotEmpty
                                ? 'Clear Search'
                                : '+ Add New Product',
                            onActionButtonPressed: () {
                              if (productController.searchQuery.isNotEmpty) {
                                productController.clearSearch();
                              } else {
                                _openAddEditScreen();
                              }
                            },
                          )
                        else
                          // 2-Column Responsive High Density Grid
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.80,
                            ),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return ProductCard(
                                product: product,
                                onToggleAvailability: (isAvailable) {
                                  productController.toggleAvailability(
                                    product.id,
                                    isAvailable,
                                  );
                                },
                                onRestockTapped: () => _showRestockModal(product),
                                onEditTapped: () => _openAddEditScreen(product),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
      ),
      // Floating Action Button for Add Item
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 74.0),
        child: FloatingActionButton.extended(
          onPressed: () => _openAddEditScreen(),
          backgroundColor: isDark ? Colors.white : AppColors.ctaPrimary,
          foregroundColor: isDark ? AppColors.ctaPrimary : Colors.white,
          elevation: 4,
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text(
            'Add Item',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          ),
        ),
      ),
    );
  }
}

// Skeleton Placeholder during initial loading
class _ProductGridSkeleton extends StatelessWidget {
  const _ProductGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        const ShimmerSkeleton(width: double.infinity, height: 48, borderRadius: AppRadius.md),
        AppSpacing.vGap12,
        const Row(
          children: [
            ShimmerSkeleton(width: 90, height: 36, borderRadius: AppRadius.full),
            SizedBox(width: 8),
            ShimmerSkeleton(width: 90, height: 36, borderRadius: AppRadius.full),
            SizedBox(width: 8),
            ShimmerSkeleton(width: 90, height: 36, borderRadius: AppRadius.full),
          ],
        ),
        AppSpacing.vGap16,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (_, __) => const ShimmerSkeleton(
            width: double.infinity,
            height: double.infinity,
            borderRadius: AppRadius.card,
          ),
        ),
      ],
    );
  }
}
