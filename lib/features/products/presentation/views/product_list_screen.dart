import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_bottom_sheet.dart';
import '../../../../shared/components/error_state_view.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../notifications/domain/models/notification_type.dart';
import '../../../../shared/components/app_toast.dart';
import '../../domain/models/product_model.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/quick_restock_bottom_sheet.dart';
import 'add_edit_product_screen.dart';

/// Product Catalog & Inventory Screen matching Stitch 2x2 Grid brief (`products_2x2_grid_view/code.html`)
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    final colors = context.appColors;
    final productController = context.watch<ProductController>();
    final filteredProducts = productController.filteredProducts;

    return Scaffold(
      backgroundColor: colors.surface,
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
                    color: colors.primary,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 120),
                      children: [
                        // Top Header: Title & "+ Add" Action Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Products',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: colors.textPrimary,
                                letterSpacing: -0.4,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _openAddEditScreen(),
                              icon: const Icon(Icons.add_rounded, size: 18),
                              label: const Text('Add'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                                elevation: 0,
                                textStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),

                        AppSpacing.vGap14,

                        // Search Input Bar matching Stitch
                        Container(
                          decoration: BoxDecoration(
                            color: colors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: colors.borderSubtle),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (query) => productController.setSearchQuery(query),
                            style: TextStyle(color: colors.textPrimary, fontSize: 13.5),
                            decoration: InputDecoration(
                              hintText: 'Search products by name or category...',
                              hintStyle: TextStyle(color: colors.textMuted, fontSize: 13),
                              prefixIcon: Icon(Icons.search_rounded, size: 20, color: colors.textMuted),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded, size: 16),
                                      onPressed: () {
                                        _searchController.clear();
                                        productController.setSearchQuery('');
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                        ),

                        AppSpacing.vGap14,

                        // Category Chips Bar
                        CategoryFilterBar(
                          categories: productController.categories,
                          selectedCategoryId: productController.selectedCategoryId,
                          onCategorySelected: (catId) => productController.setCategoryFilter(catId),
                        ),

                        AppSpacing.vGap16,

                        // 2x2 Product Bento Grid
                        if (filteredProducts.isEmpty)
                          _buildEmptyState(colors)
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredProducts.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.74,
                            ),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return ProductCard(
                                product: product,
                                onToggleAvailability: (available) async {
                                  final result = await productController.toggleAvailability(product.id, available);
                                  if (!context.mounted) return;
                                  result.when(
                                    success: (_) => AppToast.showSuccess(
                                      context,
                                      title: 'Availability Updated',
                                      message: '${product.name} is now ${available ? "available" : "sold out"}.',
                                    ),
                                    failure: (msg, _) => AppToast.showError(context, title: 'Error', message: msg),
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
    );
  }

  Widget _buildEmptyState(AppSemanticColors colors) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.primaryContainer.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.inventory_2_outlined, size: 28, color: colors.primary),
          ),
          AppSpacing.vGap16,
          Text(
            'No Products Found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add your kitchen items, dishes, or baked goods to start selling.',
            style: TextStyle(
              fontSize: 12.5,
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.vGap20,
          ElevatedButton.icon(
            onPressed: () => _openAddEditScreen(),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add First Product'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.ctaPrimary,
              foregroundColor: colors.ctaPrimaryText,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
              textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// Skeleton Loading Grid
class _ProductGridSkeleton extends StatelessWidget {
  const _ProductGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 96),
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerSkeleton(width: 120, height: 24),
            ShimmerSkeleton(width: 70, height: 32, borderRadius: AppRadius.full),
          ],
        ),
        AppSpacing.vGap14,
        const ShimmerSkeleton(width: double.infinity, height: 44, borderRadius: BorderRadius.all(Radius.circular(14))),
        AppSpacing.vGap14,
        const ShimmerSkeleton(width: double.infinity, height: 36, borderRadius: AppRadius.full),
        AppSpacing.vGap16,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.74,
          ),
          itemBuilder: (_, __) => const ShimmerSkeleton(
            width: double.infinity,
            height: double.infinity,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ],
    );
  }
}
