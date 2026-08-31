import 'package:flutter/material.dart';

/// Centralized Spacing Tokens (4/8dp Spatial Rhythm)
/// Enforces consistent padding, margins, and gaps across all feature modules.
class AppSpacing {
  AppSpacing._();

  // Micro Scale (4dp multiples)
  static const double xxxs = 2.0;
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;
  static const double massive = 48.0;

  // Screen Padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
  static const EdgeInsets screenPaddingWide = EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);
  static const EdgeInsets modalPadding = EdgeInsets.all(24.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPaddingDense = EdgeInsets.all(12.0);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0);

  // Common Spacers / Gaps (SizedBox Helpers)
  static const Widget vGap2 = SizedBox(height: xxxs);
  static const Widget vGap4 = SizedBox(height: xxs);
  static const Widget vGap8 = SizedBox(height: xs);
  static const Widget vGap12 = SizedBox(height: sm);
  static const Widget vGap16 = SizedBox(height: md);
  static const Widget vGap20 = SizedBox(height: lg);
  static const Widget vGap24 = SizedBox(height: xl);
  static const Widget vGap32 = SizedBox(height: xxl);
  static const Widget vGap40 = SizedBox(height: xxxl);
  static const Widget vGap48 = SizedBox(height: massive);

  static const Widget hGap4 = SizedBox(width: xxs);
  static const Widget hGap8 = SizedBox(width: xs);
  static const Widget hGap12 = SizedBox(width: sm);
  static const Widget hGap16 = SizedBox(width: md);
  static const Widget hGap20 = SizedBox(width: lg);
  static const Widget hGap24 = SizedBox(width: xl);
  static const Widget hGap32 = SizedBox(width: xxl);

  // Touch Target Sizing (ui-ux-pro-max standard: >=44pt iOS, >=48dp Android)
  static const double minTouchTarget = 48.0;
  static const BoxConstraints minTouchConstraints = BoxConstraints(
    minWidth: minTouchTarget,
    minHeight: minTouchTarget,
  );
}
