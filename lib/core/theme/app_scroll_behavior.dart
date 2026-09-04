import 'dart:ui';
import 'package:flutter/material.dart';

/// AppScrollBehavior:
/// Configures robust, high-performance scrolling across Web, Desktop, and Mobile.
/// - Enables smooth touch, mouse, and trackpad drag & scroll capabilities.
/// - Prevents Flutter Web's unmanaged Scrollbar crash when nested scrollables or
///   shrinkWrapped lists are rendered without explicit individual controllers.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    // Only build scrollbars when a dedicated ScrollController is attached.
    // This eliminates Flutter Web's scrollbar reverse animation null exception.
    if (details.controller == null) {
      return child;
    }
    return super.buildScrollbar(context, child, details);
  }
}
