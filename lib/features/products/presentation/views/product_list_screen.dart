import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/components/app_bottom_sheet.dart';
import '../../../../shared/components/error_state_view.dart';
import '../../../../shared/components/shimmer_skeleton.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../notifications/domain/models/notification_type.dart';
import '../../domain/models/product_model.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/quick_restock_bottom_sheet.dart';
import 'add_edit_product_screen.dart';

/// Product Catalog & Inventory Screen strictly matching Stitch 2x2 Grid brief (`products_2x2_grid_view/code.html`)
/// with Fixed Top App Bar, Fixed Filter Bar, Search with max character limit, Floating Add Button, and Scrollable Product Grid.
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  bool _isSearchVisible = false;

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
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadProducts() {
    if (!mounted) return;
    final authController = context.read<AuthController>();
    final productController = context.read<ProductController>();
    final shopId = authController.activeShop?.id ?? 'shop_01';
    productController.loadProducts(shopId: shopId);
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (_isSearchVisible) {
        _searchFocusNode.requestFocus();
      } else {
        _searchController.clear();
        context.read<ProductController>().setSearchQuery('');
        _searchFocusNode.unfocus();
      }
    });
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
    final isDark = context.isDark;
    final productController = context.watch<ProductController>();
    final notifController = context.watch<NotificationController>();
    final unreadCount = notifController.unreadCount;
    final filteredProducts = productController.filteredProducts;

    return Scaffold(
      backgroundColor: colors.surface,
      // 1. Top App Bar with Products Icon Avatar, "Products" title, Search trigger, and Notifications
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Icon(
                Icons.inventory_2_rounded,
                size: 20,
                color: colors.primary,
              ),
            ),
          ),
        ),
        title: Text(
          'Products',
          style: AppTypography.headlineMedium.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          // Search Icon Button in place of Add Button as requested
          IconButton(
            icon: Icon(
              _isSearchVisible ? Icons.search_off_rounded : Icons.search_rounded,
              color: _isSearchVisible ? colors.primary : colors.textPrimary,
              size: 24,
            ),
            tooltip: _isSearchVisible ? 'Close Search' : 'Search Products',
            onPressed: _toggleSearch,
          ),
          // Notification Bell
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.notifications);
            },
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: colors.textPrimary,
                  size: 24,
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colors.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.surface, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.hGap8,
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 2. Search Input Bar (with max 50 character limit) - Expands or is persistent
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _isSearchVisible ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xs,
                  AppSpacing.lg,
                  AppSpacing.xs,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surfaceLow,
                    borderRadius: AppRadius.md,
                    border: Border.all(color: colors.primary.withValues(alpha: 0.4), width: 1.2),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    maxLength: 50,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    onChanged: (query) => productController.setSearchQuery(query),
                    style: AppTypography.bodyMedium.copyWith(
                      color: colors.textPrimary,
                      fontSize: 13.5,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search products (max 50 chars)...',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: colors.textMuted,
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(Icons.search_rounded, size: 20, color: colors.primary),
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
              ),
            ),

            // 3. Fixed / Pinned Category Filter Bar (Horizontal Pill Chips)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xs,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: CategoryFilterBar(
                categories: productController.categories,
                selectedCategoryId: productController.selectedCategoryId,
                onCategorySelected: (catId) => productController.setCategoryFilter(catId),
              ),
            ),

            // 4. Scrollable Product Bento Grid (2x2 Grid View)
            Expanded(
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
                          child: filteredProducts.isEmpty
                              ? ListView(
                                  padding: const EdgeInsets.fromLTRB(
                                    AppSpacing.lg,
                                    AppSpacing.xs,
                                    AppSpacing.lg,
                                    120,
                                  ),
                                  children: [
                                    _buildEmptyState(colors, isDark),
                                  ],
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                    AppSpacing.lg,
                                    AppSpacing.xs,
                                    AppSpacing.lg,
                                    130, // clearance for floating action button & bottom nav
                                  ),
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
                        ),
            ),
          ],
        ),
      ),
      // 5. Floating Action Button for "+ Add Product" placed above bottom navigation dock
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 76.0),
        child: FloatingActionButton.extended(
          onPressed: () => _openAddEditScreen(),
          backgroundColor: colors.primary,
          foregroundColor: colors.textInverse,
          elevation: 4,
          icon: Icon(Icons.add_rounded, color: colors.textInverse, size: 22),
          label: Text(
            'Add Item',
            style: AppTypography.labelLarge.copyWith(
              color: colors.textInverse,
              fontWeight: FontWeight.w800,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.full,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppSemanticColors colors, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: colors.borderSubtle),
        boxShadow: isDark ? AppShadows.darkCard : AppShadows.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.surfaceLow,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.inventory_2_outlined, size: 40, color: colors.textMuted),
          ),
          AppSpacing.vGap20,
          Text(
            'No Products Found',
            style: AppTypography.headlineMedium.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.vGap6,
          Text(
            'Add your dishes, grocery items, or baked goods to start receiving customer orders.',
            style: AppTypography.bodyMedium.copyWith(
              color: colors.textSecondary,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.vGap24,
          ElevatedButton.icon(
            onPressed: () => _openAddEditScreen(),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.ctaPrimary,
              foregroundColor: colors.ctaPrimaryText,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.full,
              ),
              elevation: 0,
            ),
            icon: Icon(Icons.add_rounded, size: 18, color: colors.ctaPrimaryText),
            label: Text(
              'Add New Product',
              style: AppTypography.labelMedium.copyWith(
                color: colors.ctaPrimaryText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 2x2 Skeleton Shimmer placeholder matching Stitch layout
class _ProductGridSkeleton extends StatelessWidget {
  const _ProductGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 96),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.74,
      ),
      itemBuilder: (_, __) => const ShimmerSkeleton(
        width: double.infinity,
        height: double.infinity,
        borderRadius: AppRadius.md,
      ),
    );
  }
}
