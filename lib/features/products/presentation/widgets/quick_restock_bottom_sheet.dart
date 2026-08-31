import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_button.dart';
import '../../../../shared/components/app_text_field.dart';
import '../../domain/models/product_model.dart';

// Quick Restock Inventory Bottom Sheet
class QuickRestockBottomSheet extends StatefulWidget {
  final ProductModel product;
  final ValueChanged<int> onRestockConfirmed;

  const QuickRestockBottomSheet({
    super.key,
    required this.product,
    required this.onRestockConfirmed,
  });

  @override
  State<QuickRestockBottomSheet> createState() => _QuickRestockBottomSheetState();
}

class _QuickRestockBottomSheetState extends State<QuickRestockBottomSheet> {
  int _selectedAmount = 10;
  final _customQuantityController = TextEditingController();
  bool _isCustom = false;

  @override
  void dispose() {
    _customQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final chips = [5, 10, 25, 50];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Product Summary Row
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: AppRadius.md,
                color: colors.surfaceSubtle,
              ),
              child: ClipRRect(
                borderRadius: AppRadius.md,
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.fastfood_rounded),
                ),
              ),
            ),
            AppSpacing.hGap12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    'Current Stock: ${widget.product.stockQuantity} units',
                    style: AppTypography.bodySmall.copyWith(
                      color: widget.product.isOutOfStock
                          ? colors.error
                          : (widget.product.isLowStock
                              ? colors.warning
                              : colors.success),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        AppSpacing.vGap20,

        Text(
          'Select Restock Quantity',
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),

        AppSpacing.vGap10,

        // Quick Amount Chips
        Row(
          children: chips.map((amount) {
            final isSelected = !_isCustom && _selectedAmount == amount;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedAmount = amount;
                      _isCustom = false;
                      _customQuantityController.clear();
                    });
                  },
                  borderRadius: AppRadius.full,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.primary
                          : colors.surfaceSubtle,
                      borderRadius: AppRadius.full,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: colors.primary.withValues(alpha: 0.3),
                                offset: const Offset(0, 3),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '+$amount',
                        style: AppTypography.labelMedium.copyWith(
                          color: isSelected
                              ? Colors.white
                              : colors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        AppSpacing.vGap16,

        // Custom Quantity Input
        AppTextField(
          label: 'Or Custom Amount',
          hint: 'e.g. 100',
          controller: _customQuantityController,
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
          onChanged: (val) {
            final parsed = int.tryParse(val);
            if (parsed != null && parsed > 0) {
              setState(() {
                _isCustom = true;
                _selectedAmount = parsed;
              });
            }
          },
        ),

        AppSpacing.vGap24,

        // Confirm Button
        AppButton(
          text: 'Add +$_selectedAmount Units to Inventory',
          onPressed: () {
            widget.onRestockConfirmed(_selectedAmount);
            Navigator.of(context).pop();
          },
          variant: AppButtonVariant.primary,
          size: AppButtonSize.large,
        ),
      ],
    );
  }
}
