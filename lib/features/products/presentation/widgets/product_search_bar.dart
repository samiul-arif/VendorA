import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';

// Product Catalog Search Bar Component (Matched to Standard Input Field Box Style)
class ProductSearchBar extends StatefulWidget {
  final String initialQuery;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;

  const ProductSearchBar({
    super.key,
    required this.initialQuery,
    required this.onQueryChanged,
    required this.onClear,
  });

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceSubtle,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: colors.borderSubtle,
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (val) {
          widget.onQueryChanged(val);
          setState(() {});
        },
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search items by name or category...',
          hintStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colors.textMuted,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: colors.textMuted,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    size: 18,
                    color: colors.textMuted,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onClear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}
