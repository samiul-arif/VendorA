import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_button.dart';
import '../../../../shared/components/app_text_field.dart';
import '../../domain/models/category_model.dart';

// Add & Edit Category Bottom Sheet Modal
// Strictly contains Category Name and Description fields per business requirement
class AddEditCategoryBottomSheet extends StatefulWidget {
  final CategoryModel? categoryToEdit;
  final Future<void> Function(String name, String description) onSave;

  const AddEditCategoryBottomSheet({
    super.key,
    this.categoryToEdit,
    required this.onSave,
  });

  @override
  State<AddEditCategoryBottomSheet> createState() =>
      _AddEditCategoryBottomSheetState();
}

class _AddEditCategoryBottomSheetState
    extends State<AddEditCategoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isSaving = false;

  bool get _isEditMode => widget.categoryToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.categoryToEdit?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.categoryToEdit?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await widget.onSave(
        _nameController.text.trim(),
        _descriptionController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      // Error handled by caller controller
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Category Name Field
          AppTextField(
            label: 'Category Name',
            hint: 'e.g. Burgers & Wraps, Cold Drinks, Desserts',
            controller: _nameController,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter a category name';
              }
              if (val.trim().length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),

          AppSpacing.vGap16,

          // 2. Category Description Field
          AppTextField(
            label: 'Description (Optional)',
            hint: 'Brief description of items included in this menu section...',
            controller: _descriptionController,
            maxLines: 3,
          ),

          AppSpacing.vGap24,

          // 3. Action Submit Button (modern_ui_arif Solid Black Primary CTA)
          AppButton(
            text: _isEditMode ? 'Save Changes' : 'Create Category',
            isLoading: _isSaving,
            onPressed: _handleSubmit,
            variant: AppButtonVariant.primary,
            size: AppButtonSize.large,
          ),
        ],
      ),
    );
  }
}
