import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/components/app_button.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/app_dialog.dart';
import '../../../../shared/components/app_switch.dart';
import '../../../../shared/components/app_text_field.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/models/product_model.dart';
import '../controllers/product_controller.dart';

// Add and Edit Product Form Screen (modern_ui_arif Card-First Form)
class AddEditProductScreen extends StatefulWidget {
  final ProductModel? productToEdit;

  const AddEditProductScreen({
    super.key,
    this.productToEdit,
  });

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _originalPriceController;
  late TextEditingController _stockController;
  late TextEditingController _lowStockThresholdController;
  late TextEditingController _prepTimeController;
  late TextEditingController _imageUrlController;

  String _selectedCategoryId = 'cat_01';
  String _selectedCategoryName = 'Burgers & Sandwiches';
  bool _isAvailable = true;
  bool _isPopular = false;

  bool get _isEditMode => widget.productToEdit != null;

  final List<Map<String, String>> _categories = const [
    {'id': 'cat_01', 'name': 'Burgers & Sandwiches'},
    {'id': 'cat_02', 'name': 'Sides & Appetizers'},
    {'id': 'cat_03', 'name': 'Beverages & Drinks'},
    {'id': 'cat_04', 'name': 'Desserts & Sweets'},
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.productToEdit;

    _nameController = TextEditingController(text: p?.name ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(text: p != null ? '${p.price}' : '');
    _originalPriceController =
        TextEditingController(text: p?.originalPrice != null ? '${p!.originalPrice}' : '');
    _stockController = TextEditingController(text: p != null ? '${p.stockQuantity}' : '20');
    _lowStockThresholdController =
        TextEditingController(text: p != null ? '${p.lowStockThreshold}' : '3');
    _prepTimeController =
        TextEditingController(text: p != null ? '${p.preparationTimeMinutes}' : '15');
    _imageUrlController = TextEditingController(
      text: p?.imageUrl ??
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
    );

    if (p != null) {
      _selectedCategoryId = p.categoryId;
      _selectedCategoryName = p.categoryName;
      _isAvailable = p.isAvailable;
      _isPopular = p.isPopular;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _stockController.dispose();
    _lowStockThresholdController.dispose();
    _prepTimeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = context.read<AuthController>();
    final productController = context.read<ProductController>();
    final activeShop = authController.activeShop;

    if (activeShop == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active shop session found.')),
      );
      return;
    }

    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final originalPrice = double.tryParse(_originalPriceController.text.trim());
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;
    final threshold = int.tryParse(_lowStockThresholdController.text.trim()) ?? 3;
    final prepTime = int.tryParse(_prepTimeController.text.trim()) ?? 15;

    final product = ProductModel(
      id: widget.productToEdit?.id ?? '',
      shopId: activeShop.id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: price,
      originalPrice: originalPrice,
      stockQuantity: stock,
      lowStockThreshold: threshold,
      isAvailable: _isAvailable,
      isManualOutOfStock: !_isAvailable,
      categoryId: _selectedCategoryId,
      categoryName: _selectedCategoryName,
      imageUrl: _imageUrlController.text.trim(),
      preparationTimeMinutes: prepTime,
      isPopular: _isPopular,
      createdAt: widget.productToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = _isEditMode
        ? await productController.updateProduct(product)
        : await productController.addProduct(product);

    if (!mounted) return;

    result.when(
      success: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Product updated successfully!'
                  : 'New product added to catalog!',
            ),
            backgroundColor: AppColors.statusSuccess,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop();
      },
      failure: (msg, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: AppColors.statusError,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  void _handleDelete() async {
    if (widget.productToEdit == null) return;

    final confirmed = await AppDialog.showConfirmation(
      context: context,
      title: 'Delete Product',
      message:
          'Are you sure you want to remove "${widget.productToEdit!.name}" from your catalog?',
      confirmText: 'Delete',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      final productController = context.read<ProductController>();
      final result = await productController.deleteProduct(widget.productToEdit!.id);

      if (!mounted) return;

      result.when(
        success: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product removed from catalog.'),
              backgroundColor: AppColors.statusSuccess,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pop();
        },
        failure: (msg, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: AppColors.statusError,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final productController = context.watch<ProductController>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Product' : 'Add New Product'),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.statusError),
              tooltip: 'Delete Product',
              onPressed: _handleDelete,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Section 1: Basic Info
                AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'General Details',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      AppSpacing.vGap16,
                      AppTextField(
                        label: 'Product Title',
                        hint: 'e.g. Signature Truffle Burger',
                        controller: _nameController,
                        validator: (val) =>
                            val == null || val.trim().isEmpty ? 'Please enter a product name' : null,
                      ),
                      AppSpacing.vGap16,
                      AppTextField(
                        label: 'Description',
                        hint: 'Describe ingredients, preparation, allergens...',
                        controller: _descriptionController,
                        maxLines: 3,
                      ),
                      AppSpacing.vGap16,
                      Text(
                        'Category',
                        style: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      AppSpacing.vGap8,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: AppRadius.md,
                          border: Border.all(
                            color: isDark ? const Color(0xFF2D3748) : AppColors.borderLight,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCategoryId,
                            isExpanded: true,
                            dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
                            items: _categories.map((c) {
                              return DropdownMenuItem<String>(
                                value: c['id'],
                                child: Text(
                                  c['name']!,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedCategoryId = val;
                                  _selectedCategoryName = _categories.firstWhere((c) => c['id'] == val)['name']!;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                AppSpacing.vGap16,

                // Section 2: Pricing & Inventory
                AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pricing & Inventory Control',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      AppSpacing.vGap16,
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Price (\$)',
                              hint: '14.99',
                              controller: _priceController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return 'Enter price';
                                final num = double.tryParse(val.trim());
                                if (num == null || num <= 0) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                          AppSpacing.hGap12,
                          Expanded(
                            child: AppTextField(
                              label: 'Original Price (Optional)',
                              hint: '17.99',
                              controller: _originalPriceController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.vGap16,
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Initial Stock Units',
                              hint: '25',
                              controller: _stockController,
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return 'Enter stock';
                                final num = int.tryParse(val.trim());
                                if (num == null || num < 0) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                          AppSpacing.hGap12,
                          Expanded(
                            child: AppTextField(
                              label: 'Low Stock Alert At',
                              hint: '3',
                              controller: _lowStockThresholdController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                AppSpacing.vGap16,

                // Section 3: Availability & Switches
                AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Item Available Online',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                              Text(
                                'Toggle off if sold out in physical store counter',
                                style: AppTypography.bodySmall.copyWith(
                                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                ),
                              ),
                            ],
                          ),
                          AppSwitch(
                            value: _isAvailable,
                            onChanged: (val) => setState(() => _isAvailable = val),
                          ),
                        ],
                      ),
                      AppSpacing.vGap16,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Highlight as Popular',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                              Text(
                                'Display featured badge on store front',
                                style: AppTypography.bodySmall.copyWith(
                                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                ),
                              ),
                            ],
                          ),
                          AppSwitch(
                            value: _isPopular,
                            onChanged: (val) => setState(() => _isPopular = val),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                AppSpacing.vGap24,

                // Save Action CTA Button (modern_ui_arif Solid Black)
                AppButton(
                  text: _isEditMode ? 'Update Product' : 'Publish Product to Catalog',
                  isLoading: productController.isLoading,
                  onPressed: _handleSave,
                  variant: AppButtonVariant.primary,
                  size: AppButtonSize.large,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
