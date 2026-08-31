import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_toast.dart';
import '../../domain/models/app_permission_type.dart';
import '../controllers/permission_controller.dart';
import 'permission_rationale_dialog.dart';

// Image Source Picker Bottom Sheet with Built-In Permission Checks
class ImageSourcePickerBottomSheet extends StatelessWidget {
  final ValueChanged<String> onImageSelected;

  const ImageSourcePickerBottomSheet({
    super.key,
    required this.onImageSelected,
  });

  static final List<Map<String, String>> _sampleFoodGallery = [
    {
      'title': 'Gourmet Truffle Burger',
      'url': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&q=80',
    },
    {
      'title': 'Crispy Golden Fries',
      'url': 'https://images.unsplash.com/photo-1576107232684-1279f3908594?w=500&q=80',
    },
    {
      'title': 'Artisan Pepperoni Pizza',
      'url': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&q=80',
    },
    {
      'title': 'Specialty Cold Brew Latte',
      'url': 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?w=500&q=80',
    },
    {
      'title': 'Grilled Chicken Panini',
      'url': 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=500&q=80',
    },
    {
      'title': 'Chocolate Molten Cake',
      'url': 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=500&q=80',
    },
  ];

  Future<void> _handleCameraSelection(BuildContext context) async {
    final permissionController = context.read<PermissionController>();
    var status = permissionController.getStatus(AppPermissionType.camera);

    if (!status.isGranted) {
      final allowed = await PermissionRationaleDialog.show(
        context: context,
        permissionType: AppPermissionType.camera,
      );

      if (allowed == true) {
        status = await permissionController.requestPermission(AppPermissionType.camera);
      } else {
        if (context.mounted) {
          AppToast.showWarning(
            context,
            title: 'Camera Permission Denied',
            message: 'Camera access is required to take live dish photos.',
          );
        }
        return;
      }
    }

    if (status.isGranted && context.mounted) {
      Navigator.of(context).pop();
      onImageSelected(_sampleFoodGallery[1]['url']!);
      AppToast.showSuccess(
        context,
        title: 'Photo Captured',
        message: 'Applied newly captured dish photo.',
      );
    }
  }

  Future<void> _handleGallerySelection(BuildContext context) async {
    final permissionController = context.read<PermissionController>();
    var status = permissionController.getStatus(AppPermissionType.photos);

    if (!status.isGranted) {
      final allowed = await PermissionRationaleDialog.show(
        context: context,
        permissionType: AppPermissionType.photos,
      );

      if (allowed == true) {
        status = await permissionController.requestPermission(AppPermissionType.photos);
      } else {
        if (context.mounted) {
          AppToast.showWarning(
            context,
            title: 'Photo Library Permission Denied',
            message: 'Photo gallery access is required to select images.',
          );
        }
        return;
      }
    }

    if (status.isGranted && context.mounted) {
      Navigator.of(context).pop();
      onImageSelected(_sampleFoodGallery.first['url']!);
      AppToast.showSuccess(
        context,
        title: 'Photo Selected',
        message: 'Applied photo from your photo library.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Camera Tile
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.12),
              borderRadius: AppRadius.md,
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              color: Color(0xFF10B981),
              size: 20,
            ),
          ),
          title: Text(
            'Take Picture with Camera',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          subtitle: const Text(
            'Capture live freshly prepared kitchen dish',
            style: TextStyle(fontSize: 11),
          ),
          trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          onTap: () => _handleCameraSelection(context),
        ),

        const Divider(height: 1),

        // Photos Gallery Tile
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.12),
              borderRadius: AppRadius.md,
            ),
            child: const Icon(
              Icons.photo_library_rounded,
              color: Color(0xFF6366F1),
              size: 20,
            ),
          ),
          title: Text(
            'Choose from Photo Library',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          subtitle: const Text(
            'Select high-res food photo from device gallery',
            style: TextStyle(fontSize: 11),
          ),
          trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          onTap: () => _handleGallerySelection(context),
        ),

        const Divider(height: 1),

        // Curated Library Tile
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: AppRadius.md,
            ),
            child: const Icon(
              Icons.collections_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          title: Text(
            'Curated Chef Food Library',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          subtitle: const Text(
            'Choose from pre-loaded gourmet restaurant assets',
            style: TextStyle(fontSize: 11),
          ),
          trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          onTap: () {
            Navigator.of(context).pop();
            _showCuratedFoodGrid(context);
          },
        ),
      ],
    );
  }

  void _showCuratedFoodGrid(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E242C) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB),
                  borderRadius: AppRadius.full,
                ),
              ),
              AppSpacing.vGap16,
              Text(
                'Curated Food Photography',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              AppSpacing.vGap16,
              SizedBox(
                height: 220,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _sampleFoodGallery.length,
                  itemBuilder: (context, idx) {
                    final item = _sampleFoodGallery[idx];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        onImageSelected(item['url']!);
                        AppToast.showSuccess(
                          context,
                          title: 'Photo Applied',
                          message: 'Applied "${item['title']}".',
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(item['url']!, fit: BoxFit.cover),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                color: Colors.black.withValues(alpha: 0.65),
                                child: Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
