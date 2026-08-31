import 'package:flutter/material.dart';

// Centralized Color Tokens for Vendor App
// Follows modern_ui_arif (Card-first, solid black CTAs, vibrant food-tech accent)
// and ui-ux-pro-max (WCAG 4.5:1 contrast, semantic tokens, light/dark parity).

class AppColors {
  AppColors._();

  // ── Brand Accent Tokens (Foodpanda / Food-Tech Partner Palette) ──────────
  static const Color primary = Color(0xFFE21B70);          // Signature Merchant Magenta/Pink
  static const Color primaryDark = Color(0xFFC0155C);      // Pressed primary
  static const Color primaryLight = Color(0xFFFF4E9B);     // Light variant
  static const Color primaryTint = Color(0xFFFFF0F6);      // Subtle bg tint for badges (light)
  static const Color primaryTintDark = Color(0xFF3A1428);  // Subtle bg tint for badges (dark)
  static const Color primarySurface = Color(0xFFFDE8F1);   // Light accent card surface

  static const Color secondary = Color(0xFF2FBF9F);        // Fresh Mint / Success Accent
  static const Color secondaryTint = Color(0xFFE6F7F3);
  static const Color secondaryTintDark = Color(0xFF0F2B26);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE21B70), Color(0xFFFF5E9E)],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1C2029), Color(0xFF12151C)],
  );

  static const LinearGradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF35C9A8), Color(0xFFBFEFDD)],
  );

  // ── Action & Button Tokens ────────────────────────────────────────────
  // Light: solid near-black pill. Dark: soft off-white pill (inverted),
  // which reads far more "modern app" than black-on-black in dark mode.
  static const Color ctaPrimaryLight = Color(0xFF15171C);
  static const Color ctaPrimaryLightHover = Color(0xFF272B33);
  static const Color ctaPrimaryLightText = Color(0xFFFFFFFF);

  static const Color ctaPrimaryDark = Color(0xFFF5F6F8);
  static const Color ctaPrimaryDarkHover = Color(0xFFE3E5E9);
  static const Color ctaPrimaryDarkText = Color(0xFF15171C);

  static const Color ctaSecondaryLight = Color(0xFFF1F2F5);
  static const Color ctaSecondaryLightText = Color(0xFF15171C);
  static const Color ctaSecondaryDark = Color(0xFF232732);
  static const Color ctaSecondaryDarkText = Color(0xFFF5F6F8);

  // ── Canvas & Surface Tokens (Light Theme) ─────────────────────────────
  static const Color lightCanvas = Color(0xFFF6F7F9);       // Cool-toned, softer than flat grey
  static const Color lightSurface = Color(0xFFFFFFFF);      // Primary card surface
  static const Color lightSurfaceSubtle = Color(0xFFFBFBFD);// Secondary/nested surface
  static const Color lightBorder = Color(0xFFE7E9EE);       // Card/input outline
  static const Color lightDivider = Color(0xFFEEF0F3);

  // ── Canvas & Surface Tokens (Dark Theme) ──────────────────────────────
  // True elevation model (à la Material 3 / Linear dark): each level gets
  // slightly lighter, not just one flat "dark grey" for everything.
  static const Color darkCanvas = Color(0xFF0B0D12);        // App background, deep blue-black
  static const Color darkSurface = Color(0xFF14161D);       // Level 1 — base cards
  static const Color darkSurfaceElevated = Color(0xFF1B1E27);// Level 2 — modals, sheets, popovers
  static const Color darkSurfaceHighest = Color(0xFF232733); // Level 3 — nested/hover surfaces
  static const Color darkBorder = Color(0xFF272B35);
  static const Color darkDivider = Color(0xFF1E212A);

  // ── Typography & Text Tokens (Light Theme) ────────────────────────────
  static const Color textPrimaryLight = Color(0xFF15171C);   // Near-black, cool undertone
  static const Color textSecondaryLight = Color(0xFF60646E); // Medium cool-grey
  static const Color textMutedLight = Color(0xFF9AA0AC);     // Placeholder/caption
  static const Color textInverseLight = Color(0xFFFFFFFF);   // Text on dark chips (light theme)

  // ── Typography & Text Tokens (Dark Theme) ─────────────────────────────
  static const Color textPrimaryDark = Color(0xFFF3F4F7);    // Soft white, not pure #FFF
  static const Color textSecondaryDark = Color(0xFFA3A8B3);  // Muted cool-grey
  static const Color textMutedDark = Color(0xFF6C7280);      // Tertiary captions

  // ── Semantic & Status Tokens (WCAG 4.5:1 Compliant) ───────────────────
  static const Color statusSuccess = Color(0xFF16A34A);
  static const Color statusSuccessBgLight = Color(0xFFECFDF3);
  static const Color statusSuccessBgDark = Color(0xFF10291C);

  static const Color statusWarning = Color(0xFFD97706);
  static const Color statusWarningBgLight = Color(0xFFFEF6E7);
  static const Color statusWarningBgDark = Color(0xFF2E2109);

  static const Color statusError = Color(0xFFDC2626);
  static const Color statusErrorBgLight = Color(0xFFFDF0F0);
  static const Color statusErrorBgDark = Color(0xFF2E1212);

  static const Color statusInfo = Color(0xFF2563EB);
  static const Color statusInfoBgLight = Color(0xFFEEF3FE);
  static const Color statusInfoBgDark = Color(0xFF10203D);

  // ── Order Status Colors (theme-agnostic accents) ──────────────────────
  static const Color orderPending = Color(0xFFD97706);      // Amber
  static const Color orderAccepted = Color(0xFF2563EB);     // Blue
  static const Color orderPreparing = Color(0xFF7C3AED);    // Violet
  static const Color orderReady = Color(0xFF16A34A);        // Green
  static const Color orderDelivered = Color(0xFF0D9488);    // Teal
  static const Color orderCancelled = Color(0xFFDC2626);    // Red

  // ── Scrim & Overlay Tokens ─────────────────────────────────────────────
  static const Color overlayScrimLight = Color(0x66000000); // 40% black scrim
  static const Color overlayScrimDark = Color(0x99000000);  // 60% black scrim (dark needs more)
  static const Color shimmerBaseLight = Color(0xFFE4E6EA);
  static const Color shimmerHighlightLight = Color(0xFFF6F7F9);
  static const Color shimmerBaseDark = Color(0xFF1E212A);
  static const Color shimmerHighlightDark = Color(0xFF2A2E38);
}