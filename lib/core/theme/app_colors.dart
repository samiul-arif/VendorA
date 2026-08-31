import 'package:flutter/material.dart';

/// Centralized Color Tokens for Vendor App
/// Follows modern_ui_arif (Card-first, solid black CTAs, vibrant food-tech accent)
/// and ui-ux-pro-max (WCAG 4.5:1 contrast, semantic tokens, light/dark parity).
class AppColors {
  AppColors._();

  // Brand Accent Tokens (Foodpanda / Food-Tech Partner Palette)
  static const Color primary = Color(0xFFE21B70);          // Signature Merchant Magenta/Pink
  static const Color primaryDark = Color(0xFFC0155C);      // Pressed primary
  static const Color primaryLight = Color(0xFFFF4E9B);     // Light variant
  static const Color primaryTint = Color(0xFFFFF0F6);      // Subtle background tint for badges
  static const Color primarySurface = Color(0xFFFDE8F1);   // Light accent card surface

  static const Color secondary = Color(0xFF2FBF9F);        // Fresh Mint / Success Accent
  static const Color secondaryTint = Color(0xFFE6F7F3);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE21B70), Color(0xFFFF5E9E)],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E232A), Color(0xFF14171C)],
  );

  static const LinearGradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF35C9A8), Color(0xFFBFEFDD)],
  );

  // Action & Button Tokens (modern_ui_arif: Solid Near-Black Primary CTAs)
  static const Color ctaPrimary = Color(0xFF141414);       // Solid black pill button
  static const Color ctaPrimaryHover = Color(0xFF262626);  // Hover / Pressed state
  static const Color ctaPrimaryText = Color(0xFFFFFFFF);   // High-contrast text on CTA
  static const Color ctaSecondary = Color(0xFFF3F4F6);     // Neutral pill button
  static const Color ctaSecondaryText = Color(0xFF141414);

  // Canvas & Surface Tokens (Light Theme)
  static const Color lightCanvas = Color(0xFFF5F6F8);       // Soft muted neutral backdrop
  static const Color lightSurface = Color(0xFFFFFFFF);      // Primary high-radius card surface
  static const Color lightSurfaceSubtle = Color(0xFFFAFAFC);// Secondary card surface
  static const Color lightBorder = Color(0xFFE8EAED);       // Subtle card/input outline
  static const Color lightDivider = Color(0xFFF0F1F3);

  // Canvas & Surface Tokens (Dark Theme)
  static const Color darkCanvas = Color(0xFF101318);        // Deep charcoal backdrop
  static const Color darkSurface = Color(0xFF1A1F26);       // Elevated card surface
  static const Color darkSurfaceSubtle = Color(0xFF232A34); // Nested surface
  static const Color darkBorder = Color(0xFF2A3340);
  static const Color darkDivider = Color(0xFF232A34);

  // Typography & Text Tokens (Light Theme)
  static const Color textPrimaryLight = Color(0xFF141414);   // Near-black headings & labels
  static const Color textSecondaryLight = Color(0xFF6B7280); // Medium-grey descriptions
  static const Color textMutedLight = Color(0xFF9CA3AF);     // Tertiary/placeholder captions
  static const Color textInverse = Color(0xFFFFFFFF);        // Text on dark surfaces

  // Typography & Text Tokens (Dark Theme)
  static const Color textPrimaryDark = Color(0xFFF9FAFB);    // Crisp white headings
  static const Color textSecondaryDark = Color(0xFF9CA3AF);  // Muted grey descriptions
  static const Color textMutedDark = Color(0xFF6B7280);      // Tertiary captions

  // Semantic & Status Tokens (WCAG 4.5:1 Compliant)
  static const Color statusSuccess = Color(0xFF10B981);
  static const Color statusSuccessBg = Color(0xFFECFDF5);
  static const Color statusSuccessDarkBg = Color(0xFF064E3B);

  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color statusWarningBg = Color(0xFFFFFBEB);
  static const Color statusWarningDarkBg = Color(0xFF78350F);

  static const Color statusError = Color(0xFFEF4444);
  static const Color statusErrorBg = Color(0xFFFEF2F2);
  static const Color statusErrorDarkBg = Color(0xFF7F1D1D);

  static const Color statusInfo = Color(0xFF3B82F6);
  static const Color statusInfoBg = Color(0xFFEFF6FF);
  static const Color statusInfoDarkBg = Color(0xFF1E3A8A);

  // Order Status Colors
  static const Color orderPending = Color(0xFFF59E0B);      // Amber
  static const Color orderAccepted = Color(0xFF3B82F6);     // Blue
  static const Color orderPreparing = Color(0xFF8B5CF6);    // Purple
  static const Color orderReady = Color(0xFF10B981);        // Green
  static const Color orderDelivered = Color(0xFF059669);    // Deep Green
  static const Color orderCancelled = Color(0xFFEF4444);    // Red

  // Scrim & Overlay Tokens
  static const Color overlayScrim = Color(0x66000000);      // 40% black scrim
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}
