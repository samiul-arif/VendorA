import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_shadows.dart';

// Navigation Item Configuration
class NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int badgeCount;

  const NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badgeCount = 0,
  });
}

// Floating Rounded Pill Bottom Navigation Dock (modern_ui_arif Floating Dock)
class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavItem> items;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDark;

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding > 0 ? bottomPadding + 4 : 16),
      child: Container(
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: colors.surface.withValues(alpha: 0.95),
          borderRadius: AppRadius.full,
          boxShadow: isDark ? AppShadows.darkCard : AppShadows.floating,
          border: Border.all(
            color: colors.borderSubtle,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == currentIndex;

            return _NavBarItemWidget(
              item: item,
              isSelected: isSelected,
              onTap: () => onTap(index),
            );
          }),
        ),
      ),
    );
  }
}

class _NavBarItemWidget extends StatefulWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavBarItemWidget> createState() => _NavBarItemWidgetState();
}

class _NavBarItemWidgetState extends State<_NavBarItemWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final activeBgColor = colors.ctaPrimary;
    final activeFgColor = colors.ctaPrimaryText;
    final inactiveFgColor = colors.textSecondary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: widget.isSelected ? 14 : 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected ? activeBgColor : Colors.transparent,
            borderRadius: AppRadius.full,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    widget.isSelected ? widget.item.selectedIcon : widget.item.icon,
                    size: 20,
                    color: widget.isSelected ? activeFgColor : inactiveFgColor,
                  ),
                  if (!widget.isSelected && widget.item.badgeCount > 0)
                    Positioned(
                      top: -4,
                      right: -7,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.surface,
                            width: 1.5,
                          ),
                        ),
                        constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                        child: Text(
                          '${widget.item.badgeCount}',
                          style: TextStyle(
                            color: colors.textInverse,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              if (widget.isSelected) ...[
                const SizedBox(width: 6),
                Text(
                  widget.item.label,
                  style: TextStyle(
                    color: activeFgColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
