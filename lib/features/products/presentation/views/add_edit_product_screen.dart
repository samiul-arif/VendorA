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
import '../../../../shared/components/shared_select_modal.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/models/product_model.dart';
import '../controllers/product_controller.dart';

// Add / Edit Product View (arif.html Design Specification)
class AddEditProductScreen extends StatefulWidget {
  final ProductModel? productToEdit;

  const AddEditProductScreen({
    super.key,
    this.productToEdit,
  });

  bool get isEditMode => productToEdit != null;

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _descController;

  String _selectedCategory = 'Burgers';
  String _imageUrl = '';
  bool _isAvailable = true;
  bool _isPopular = false;
  bool _isSubmitting = false;

  final List<String> _presetCategories = const [
    'Burgers',
    'Main Course',
    'Sides',
    'Beverages',
    'Desserts',
    'Salads & Bowls',
    'Pizza',
    'Appetizers',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.productToEdit;

    _nameController = TextEditingController(text: p?.name ?? '');
    _priceController = TextEditingController(text: p != null ? p.price.toStringAsFixed(2) : '');
    _quantityController = TextEditingController(text: (p?.stockQuantity ?? 25).toString());
    _descController = TextEditingController(text: p?.description ?? '');

    _selectedCategory = p?.categoryName ?? 'Burgers';
    _imageUrl = p?.imageUrl ?? '';
    _isAvailable = p?.isAvailable ?? true;
    _isPopular = p?.isPopular ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _adjustQuantity(int delta) {
    int current = int.tryParse(_quantityController.text.trim()) ?? 0;
    current = (current + delta).clamp(0, 9999);
    setState(() {
      _quantityController.text = current.toString();
      if (current == 0) {
        _isAvailable = false;
      } else if (!_isAvailable) {
        _isAvailable = true;
      }
    });
  }

  void _openCategorySelectModal() async {
    final options = _presetCategories.map((cat) {
      return SelectOptionItem<String>(
        value: cat,
        title: cat,
        icon: Icons.restaurant_menu_rounded,
      );
    }).toList();

    final selected = await SharedSelectModal.show<String>(
      context: context,
      title: 'Select Category',
      subtitle: 'Group this item under a menu section',
      options: options,
      selectedValue: _selectedCategory,
    );

    if (selected != null) {
      setState(() => _selectedCategory = selected);
    }
  }

  void _mockPickImage() {
    final sampleImages = [
      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
      'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=400&q=80',
      'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400&q=80',
      'https://images.unsplash.com/photo-1544025162-d76694265947?w=400&q=80',
      'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400&q=80',
      'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&q=80',
    ];
    setState(() {
      _imageUrl = (sampleImages..shuffle()).first;
    });
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final authController = context.read<AuthController>();
    final productController = context.read<ProductController>();
    final shopId = authController.activeShop?.id ?? 'shop_01';

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final desc = _descController.text.trim().isNotEmpty
        ? _descController.text.trim()
        : 'Freshly prepared specialty dish';
    final image = _imageUrl.isNotEmpty
        ? _imageUrl
        : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=80';

    if (widget.isEditMode) {
      final updated = widget.productToEdit!.copyWith(
        name: name,
        price: price,
        stockQuantity: quantity,
        categoryName: _selectedCategory,
        description: desc,
        imageUrl: image,
        isAvailable: _isAvailable && quantity > 0,
        isPopular: _isPopular,
        updatedAt: DateTime.now(),
      );

      final result = await productController.updateProduct(updated);
      if (mounted) {
        setState(() => _isSubmitting = false);
        result.when(
          success: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Item "$name" updated successfully!'),
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
    } else {
      final newProduct = ProductModel(
        id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
        shopId: shopId,
        categoryId: 'cat_01',
        categoryName: _selectedCategory,
        name: name,
        description: desc,
        price: price,
        imageUrl: image,
        stockQuantity: quantity,
        isAvailable: _isAvailable && quantity > 0,
        isPopular: _isPopular,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await productController.addProduct(newProduct);
      if (mounted) {
        setState(() => _isSubmitting = false);
        result.when(
          success: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Item "$name" added to menu!'),
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
  }

  void _handleDelete() async {
    if (!widget.isEditMode) return;

    final confirmed = await AppDialog.showConfirmation(
      context: context,
      title: 'Delete Item',
      message: 'Are you sure you want to permanently remove "${widget.productToEdit!.name}" from your store menu?',
      confirmText: 'Delete Item',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      final productController = context.read<ProductController>();
      final result = await productController.deleteProduct(widget.productToEdit!.id);

      if (mounted) {
        result.when(
          success: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('"${widget.productToEdit!.name}" deleted from menu.'),
                backgroundColor: AppColors.statusError,
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
      appBar: AppBar(
        leadingWidth: 90,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            children: const [
              SizedBox(width: 12),
              Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.primary),
              SizedBox(width: 4),
              Text(
                'Products',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        title: Text(
          widget.isEditMode ? 'EDIT PRODUCT' : 'NEW ITEM',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _handleSave,
            child: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Photo Uploader Card
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PRODUCT PHOTO',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                        if (_imageUrl.isNotEmpty)
                          GestureDetector(
                            onTap: () => setState(() => _imageUrl = ''),
                            child: const Text(
                              'Remove',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppColors.statusError,
                              ),
                            ),
                          ),
                      ],
                    ),
                    AppSpacing.vGap12,
                    GestureDetector(
                      onTap: _mockPickImage,
                      child: Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF232A34) : const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : const Color(0xFFD1D5DB),
                            width: 1.5,
                          ),
                        ),
                        child: _imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(_imageUrl, fit: BoxFit.cover),
                                    Container(
                                      color: Colors.black.withValues(alpha: 0.3),
                                      child: const Center(
                                        child: Text(
                                          'Change Photo',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF1A1F26) : Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap to upload item photo',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'JPG, PNG, WebP up to 5MB',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGap16,

              // Details Card
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Item Title *',
                      hint: 'e.g. Truffle Smash Burger',
                      controller: _nameController,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter item title';
                        }
                        return null;
                      },
                    ),

                    AppSpacing.vGap16,

                    Row(
                      children: [
                        // Category Picker with Shared Select Modal
                        Expanded(
                          child: GestureDetector(
                            onTap: _openCategorySelectModal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Category',
                                  style: AppTypography.labelSmall.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF232A34) : AppColors.lightSurfaceSubtle,
                                    borderRadius: AppRadius.md,
                                    border: Border.all(
                                      color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _selectedCategory,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 16,
                                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        AppSpacing.hGap12,

                        // Price Input
                        Expanded(
                          child: AppTextField(
                            label: 'Price (\$) *',
                            hint: '14.99',
                            controller: _priceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            prefixIcon: const Icon(Icons.attach_money_rounded, size: 18),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Required';
                              }
                              final p = double.tryParse(val.trim());
                              if (p == null || p <= 0) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    AppSpacing.vGap16,

                    // Stock Quantity Stepper Controls
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Available Stock Quantity *',
                              style: AppTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                            Text(
                              'Units in Kitchen',
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            // Minus Button
                            GestureDetector(
                              onTap: () => _adjustQuantity(-1),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF232A34) : AppColors.lightSurfaceSubtle,
                                  borderRadius: AppRadius.md,
                                  border: Border.all(
                                    color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                                  ),
                                ),
                                child: const Icon(Icons.remove_rounded, size: 18),
                              ),
                            ),

                            AppSpacing.hGap8,

                            // Center Quantity Field
                            Expanded(
                              child: TextField(
                                controller: _quantityController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  final num = int.tryParse(val) ?? 0;
                                  setState(() {
                                    _isAvailable = num > 0;
                                  });
                                },
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: isDark ? const Color(0xFF232A34) : AppColors.lightSurfaceSubtle,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: AppRadius.md,
                                    borderSide: BorderSide(
                                      color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: AppRadius.md,
                                    borderSide: BorderSide(
                                      color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            AppSpacing.hGap8,

                            // Plus Button
                            GestureDetector(
                              onTap: () => _adjustQuantity(1),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF232A34) : AppColors.lightSurfaceSubtle,
                                  borderRadius: AppRadius.md,
                                  border: Border.all(
                                    color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                                  ),
                                ),
                                child: const Icon(Icons.add_rounded, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    AppSpacing.vGap16,

                    // Description Textarea
                    AppTextField(
                      label: 'Description',
                      hint: 'Fresh ingredients, special chef seasoning, allergen notes...',
                      controller: _descController,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),

              AppSpacing.vGap16,

              // Stock Status & Popular Badges Card
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isAvailable ? 'Stock Available (In Stock)' : 'Marked as Sold Out',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _isAvailable ? const Color(0xFF10B981) : AppColors.statusError,
                              ),
                            ),
                            Text(
                              _isAvailable
                                  ? 'Visible for immediate customer ordering'
                                  : 'Hidden from customer checkout',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                        AppSwitch(
                          value: _isAvailable,
                          onChanged: (val) {
                            setState(() {
                              _isAvailable = val;
                              if (val && int.parse(_quantityController.text.trim()) == 0) {
                                _quantityController.text = '10';
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    Divider(height: 20, color: isDark ? AppColors.darkDivider : AppColors.lightDivider),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Highlight as "Popular"',
                              style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Displays prominent badge on product card',
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

              // Primary Solid CTA (Publish / Save)
              AppButton(
                text: widget.isEditMode ? 'Save Product Changes' : 'Publish Item to Menu',
                isLoading: _isSubmitting,
                onPressed: _handleSave,
                variant: AppButtonVariant.primary,
                size: AppButtonSize.large,
              ),

              if (widget.isEditMode) ...[
                AppSpacing.vGap12,
                AppButton(
                  text: 'Delete Item from Menu',
                  onPressed: _handleDelete,
                  variant: AppButtonVariant.outline,
                  size: AppButtonSize.large,
                ),
              ],

              AppSpacing.vGap32,
            ],
          ),
        ),
      ),
    );
  }
}
