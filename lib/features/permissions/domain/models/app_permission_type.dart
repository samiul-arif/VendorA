import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

// App Permission Types with Meta Information and User Rationale
enum AppPermissionType {
  camera,
  photos,
  notifications;

  String get title {
    switch (this) {
      case AppPermissionType.camera:
        return 'Camera Access';
      case AppPermissionType.photos:
        return 'Photo Library Access';
      case AppPermissionType.notifications:
        return 'Push Notifications';
    }
  }

  String get description {
    switch (this) {
      case AppPermissionType.camera:
        return 'Take live photos of freshly prepared kitchen dishes to list directly on your menu.';
      case AppPermissionType.photos:
        return 'Select high-quality dish and storefront imagery from your device gallery.';
      case AppPermissionType.notifications:
        return 'Receive instantaneous order dispatch alerts, courier pickups, and stock warnings.';
    }
  }

  String get rationalePrompt {
    switch (this) {
      case AppPermissionType.camera:
        return 'To capture and upload fresh dish pictures directly from your kitchen station, please enable camera access.';
      case AppPermissionType.photos:
        return 'To browse and attach dish photography to your product catalog, please enable photo library access.';
      case AppPermissionType.notifications:
        return 'Stay updated on new incoming live customer orders and kitchen alerts in real-time.';
    }
  }

  IconData get icon {
    switch (this) {
      case AppPermissionType.camera:
        return Icons.camera_alt_rounded;
      case AppPermissionType.photos:
        return Icons.photo_library_rounded;
      case AppPermissionType.notifications:
        return Icons.notifications_active_rounded;
    }
  }

  Color get color {
    switch (this) {
      case AppPermissionType.camera:
        return const Color(0xFF10B981);
      case AppPermissionType.photos:
        return const Color(0xFF6366F1);
      case AppPermissionType.notifications:
        return AppColors.primary;
    }
  }
}
