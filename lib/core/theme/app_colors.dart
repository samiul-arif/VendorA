import 'package:flutter/material.dart';

// Centralized Color Tokens for Vendor App
// Follows modern_ui_arif (Card-first, solid black CTAs, vibrant food-tech accent)
// and ui-ux-pro-max (WCAG 4.5:1 contrast, semantic tokens, light/dark parity).

class AppColors {
  AppColors._();

  // ── Brand Accent Tokens (Stitch Merchant Hub Palette) ───────────────────
  static const Color primary = Color(0xFFB90058);          // Deep Vibrant Magenta
  static const Color primaryContainer = Color(0xFFFFF0F6); // Soft Pastel Pink/Magenta Container
  static const Color primaryContainerSolid = Color(0xFFE21B70); // Lively Fuchsia/Pink Container
  static const Color primaryDark = Color(0xFF8F0042);      // Dark variant
  static const Color primaryLight = Color(0xFFFF5E9E);     // Gradient end / light variant
  static const Color primaryFixed = Color(0xFFFFD9E0);     // Soft pastel pill
  static const Color primaryTint = Color(0xFFFFF0F6);      // Subtle bg tint for badges (light)
  static const Color primaryTintDark = Color(0xFF3A1428);  // Subtle bg tint for badges (dark)
  static const Color primarySurface = Color(0xFFFDE8F1);   // Light accent card surface

  static const Color secondary = Color(0xFF006B57);        // Rich Emerald / Secondary Accent
  static const Color secondaryContainer = Color(0xFF75F9D6);// Mint Teal Container
  static const Color secondaryTint = Color(0xFFE6F7F3);
  static const Color secondaryTintDark = Color(0xFF0F2B26);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE21B70), Color(0xFFFF5E9E)],
  );

  static const LinearGradient heroGradient = LinearGradient(
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
    colors: [Color(0xFF006B57), Color(0xFF75F9D6)],
  );

  // ── Action & Button Tokens ────────────────────────────────────────────
  static const Color ctaPrimaryLight = Color(0xFF171C24);   // Stitch on-background solid pill
  static const Color ctaPrimaryLightHover = Color(0xFF2C3039);
  static const Color ctaPrimaryLightText = Color(0xFFFFFFFF);

  static const Color ctaPrimaryDark = Color(0xFFF9F9FF);
  static const Color ctaPrimaryDarkHover = Color(0xFFEAEDF9);
  static const Color ctaPrimaryDarkText = Color(0xFF171C24);

  static const Color ctaSecondaryLight = Color(0xFFEAEDF9);
  static const Color ctaSecondaryLightText = Color(0xFF171C24);
  static const Color ctaSecondaryDark = Color(0xFF232732);
  static const Color ctaSecondaryDarkText = Color(0xFFF9F9FF);

  // ── Canvas & Surface Tokens (Light Theme) ─────────────────────────────
  static const Color lightCanvas = Color(0xFFF9F9FF);       // Stitch background
  static const Color lightSurface = Color(0xFFFFFFFF);      // Primary card surface
  static const Color lightSurfaceSubtle = Color(0xFFEAEDF9);// Stitch surface-container
  static const Color lightSurfaceLow = Color(0xFFF0F3FF);   // Stitch surface-container-low
  static const Color lightSurfaceHigh = Color(0xFFE5E8F4);  // Stitch surface-container-high
  static const Color lightSurfaceHighest = Color(0xFFDFE2EE);// Stitch surface-container-highest
  static const Color lightBorder = Color(0xFFDFE2EE);       // Outline variant
  static const Color lightDivider = Color(0xFFEAEDF9);

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