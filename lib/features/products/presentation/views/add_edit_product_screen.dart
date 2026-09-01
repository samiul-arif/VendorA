import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/components/app_button.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/app_dialog.dart';
import '../../../../shared/components/app_switch.dart';
import '../../../../shared/components/app_text_field.dart';
import '../../../../shared/components/app_bottom_sheet.dart';
import '../../../../shared/components/shared_select_modal.dart';
import '../../../../shared/components/app_circular_back_button.dart';
import '../../../../shared/components/app_header_action_button.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../notifications/domain/models/notification_type.dart';
import '../../../permissions/presentation/widgets/image_source_picker_bottom_sheet.dart';
import '../../domain/models/product_model.dart';
import '../controllers/product_controller.dart';

// Add / Edit Product Screen
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
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  late String _selectedCategory;
  late bool _isAvailable;
  late bool _isPopular;
  late String _imageUrl;

  bool _isSubmitting = false;
  bool _hasPhotoPermission = false;

  final List<String> _defaultCategories = [
    'Burgers',
    'Beverages',
    'Snacks',
    'Desserts',
    'Combos',
    'Sides',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.productToEdit;

    _nameController = TextEditingController(text: p?.name ?? '');
    _descController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(text: p != null ? p.price.toStringAsFixed(2) : '');
    _quantityController = TextEditingController(text: p != null ? p.stockQuantity.toString() : '20');

    _selectedCategory = p?.categoryName ?? 'Burgers';
    _isAvailable = p?.isAvailable ?? true;
    _isPopular = p?.isPopular ?? false;
    _imageUrl = p?.imageUrl ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _adjustQuantity(int delta) {
    final current = int.tryParse(_quantityController.text.trim()) ?? 0;
    final next = (current + delta).clamp(0, 9999);
    _quantityController.text = next.toString();
    setState(() {
      _isAvailable = next > 0;
    });
  }

  void _openCategorySelectModal() async {
    final options = _defaultCategories.map((cat) {
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

  void _handleImageUploadRequest() {
    if (_hasPhotoPermission) {
      _showImagePickerPopup();
    } else {
      _showPermissionRationaleModal();
    }
  }

  void _showPermissionRationaleModal() {
    final colors = context.appColors;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.photo_library_rounded,
                color: colors.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Allow Photo Access?',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Vendor Partner needs access to your device photo gallery so you can upload and showcase appetizing item pictures on your menu.',
              style: TextStyle(
                fontSize: 12,
                color: colors.textMuted,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Not Now',
                      style: TextStyle(
                        color: colors.textMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      setState(() => _hasPhotoPermission = true);
                      _showImagePickerPopup();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
                    ),
                    child: const Text(
                      'Allow Access',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerPopup() {
    AppBottomSheet.show(
      context: context,
      title: 'Select Product Photo',
      subtitle: 'Upload a picture with device camera, gallery, or curated stock',
      child: ImageSourcePickerBottomSheet(
        onImageSelected: (url) {
          setState(() {
            _imageUrl = url;
          });
        },
      ),
    );
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
            context.read<NotificationController>().dispatchNotification(
              context,
              title: 'Product Updated',
              message: '"$name" changes saved to store menu.',
              type: NotificationType.stock,
              toastVariant: AppToastVariant.success,
            );
            Navigator.of(context).pop();
          },
          failure: (msg, _) {
            AppToast.showError(context, title: 'Update Failed', message: msg);
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
            context.read<NotificationController>().dispatchNotification(
              context,
              title: 'Product Added to Menu',
              message: '"$name" ($quantity units) is now live for ordering.',
              type: NotificationType.stock,
              toastVariant: AppToastVariant.success,
            );
            Navigator.of(context).pop();
          },
          failure: (msg, _) {
            AppToast.showError(context, title: 'Failed to Add Product', message: msg);
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
      final productName = widget.productToEdit!.name;
      final result = await productController.deleteProduct(widget.productToEdit!.id);

      if (mounted) {
        result.when(
          success: (_) {
            context.read<NotificationController>().dispatchNotification(
              context,
              title: 'Product Removed',
              message: '"$productName" deleted from store catalog.',
              type: NotificationType.stock,
              toastVariant: AppToastVariant.warning,
            );
            Navigator.of(context).pop();
          },
          failure: (msg, _) {
            AppToast.showError(context, title: 'Delete Failed', message: msg);
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 56,
        leading: const AppCircularBackButton(),
        title: Text(
          widget.isEditMode ? 'Edit Product' : 'New Item',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          AppHeaderActionButton(
            text: 'Save',
            isLoading: _isSubmitting,
            onPressed: _handleSave,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: colors.borderSubtle,
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Photo Uploader Card with Permission Trigger
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
                            color: colors.textMuted,
                          ),
                        ),
                        if (_imageUrl.isNotEmpty)
                          GestureDetector(
                            onTap: () => setState(() => _imageUrl = ''),
                            child: Text(
                              'Remove',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: colors.error,
                              ),
                            ),
                          ),
                      ],
                    ),
                    AppSpacing.vGap12,
                    GestureDetector(
                      onTap: _handleImageUploadRequest,
                      child: Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          color: colors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colors.borderSubtle,
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
                                      color: colors.surface,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: colors.primary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap to upload item photo',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'JPG, PNG, WebP up to 5MB',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: colors.textMuted,
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
                                    color: colors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: colors.surfaceSubtle,
                                    borderRadius: AppRadius.md,
                                    border: Border.all(
                                      color: colors.borderSubtle,
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
                                            color: colors.textPrimary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 16,
                                        color: colors.textMuted,
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
                            label: 'Price (৳) *',
                            hint: '14.99',
                            controller: _priceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            prefixIcon: Center(
                              widthFactor: 1.0,
                              child: Text(
                                '৳',
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colors.primary,
                                ),
                              ),
                            ),
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
                                color: colors.textSecondary,
                              ),
                            ),
                            Text(
                              'Units in Kitchen',
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.textMuted,
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
                                  color: colors.surfaceSubtle,
                                  borderRadius: AppRadius.md,
                                  border: Border.all(
                                    color: colors.borderSubtle,
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
                                  fillColor: colors.surfaceSubtle,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: AppRadius.md,
                                    borderSide: BorderSide(
                                      color: colors.borderSubtle,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: AppRadius.md,
                                    borderSide: BorderSide(
                                      color: colors.borderSubtle,
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
                                  color: colors.surfaceSubtle,
                                  borderRadius: AppRadius.md,
                                  border: Border.all(
                                    color: colors.borderSubtle,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isAvailable ? 'Stock Available (In Stock)' : 'Marked as Sold Out',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: _isAvailable ? colors.success : colors.error,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _isAvailable
                                    ? 'Visible for immediate customer ordering'
                                    : 'Hidden from customer checkout',
                                style: AppTypography.bodySmall.copyWith(
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.hGap16,
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
                    Divider(height: 24, color: colors.divider),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Highlight as "Popular"',
                                style: AppTypography.titleSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Displays prominent badge on product card',
                                style: AppTypography.bodySmall.copyWith(
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.hGap16,
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
