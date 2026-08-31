import 'package:flutter/material.dart';

/// Centralized Corner Radius Tokens (modern_ui_arif Generous Radii Scale)
class AppRadius {
  AppRadius._();

  // Raw Values
  static const double rawXs = 6.0;      // Micro badges, dot indicators
  static const double rawSm = 10.0;     // Category thumbnails, chips
  static const double rawMd = 16.0;     // Action buttons, small cards, inputs
  static const double rawLg = 24.0;     // Content cards, hero banners
  static const double rawXl = 32.0;     // Modal dialogs, bottom sheets
  static const double rawFull = 9999.0; // Pill buttons, search bars, nav docks

  // BorderRadius Helpers
  static const BorderRadius xs = BorderRadius.all(Radius.circular(rawXs));
  static const BorderRadius sm = BorderRadius.all(Radius.circular(rawSm));
  static const BorderRadius md = BorderRadius.all(Radius.circular(rawMd));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(rawLg));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(rawXl));
  static const BorderRadius full = BorderRadius.all(Radius.circular(rawFull));

  // Top-Only (for Bottom Sheets)
  static const BorderRadius sheetTop = BorderRadius.vertical(
    top: Radius.circular(rawXl),
  );

  // Card Radius Default
  static const BorderRadius card = lg;
  static const BorderRadius button = full;
  static const BorderRadius input = md;
  static const BorderRadius chip = full;
}
