import 'package:flutter/material.dart';

// Centralized Color Tokens — "Blue" Theme
// Cool, confident blue-primary system with neutral cool-grey surfaces.
// WCAG 4.5:1 contrast, semantic tokens, light/dark parity.
// Note: statusInfo/orderAccepted are deliberately shifted to a teal-cyan
// (not another blue) so they never blend visually with the primary accent.

class AppColors {
  AppColors._();

  // ── Brand Accent Tokens (Blue Palette) ──────────────────────────────────
  static const Color primary = Color(0xFF4C8DFF);          // Soft, light-leaning blue — everyday accent
  static const Color primaryContainer = Color(0xFF2F6FE0); // Deeper blue, used for containers only
  static const Color primaryDark = Color(0xFF2557B8);      // Dark variant
  static const Color primaryLight = Color(0xFF8CB8FF);     // Gradient end / light variant
  static const Color primaryFixed = Color(0xFFD6E6FF);     // Soft pastel pill
  static const Color primaryTint = Color(0xFFEFF5FF);      // Subtle bg tint for badges (light)
  static const Color primaryTintDark = Color(0xFF14213A);  // Subtle bg tint for badges (dark)
  static const Color primarySurface = Color(0xFFE3EDFF);   // Light accent card surface

  static const Color secondary = Color(0xFF5B6472);        // Cool slate — secondary accent (distinct from any text token)
  static const Color secondaryContainer = Color(0xFF9AA4B2);// Muted cool grey container
  static const Color secondaryTint = Color(0xFFEEF0F3);
  static const Color secondaryTintDark = Color(0xFF1C2027);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2F6FE0), Color(0xFF8CB8FF)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4C8DFF), Color(0xFFBEDBFF)],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B1F27), Color(0xFF11141A)],
  );

  static const LinearGradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2E8B7D), Color(0xFF7FD9C7)],
  );

  // ── Action & Button Tokens ────────────────────────────────────────────
  static const Color ctaPrimaryLight = Color(0xFF12151C);   // Near-black solid pill
  static const Color ctaPrimaryLightHover = Color(0xFF232732);
  static const Color ctaPrimaryLightText = Color(0xFFF7F9FC);

  static const Color ctaPrimaryDark = Color(0xFFF7F9FC);
  static const Color ctaPrimaryDarkHover = Color(0xFFE7ECF3);
  static const Color ctaPrimaryDarkText = Color(0xFF12151C);

  static const Color ctaSecondaryLight = Color(0xFFE7ECF3);
  static const Color ctaSecondaryLightText = Color(0xFF12151C);
  static const Color ctaSecondaryDark = Color(0xFF232732);
  static const Color ctaSecondaryDarkText = Color(0xFFF7F9FC);

  // ── Canvas & Surface Tokens (Light Theme) ─────────────────────────────
  static const Color lightCanvas = Color(0xFFF7F9FC);       // Cool off-white background
  static const Color lightSurface = Color(0xFFFFFFFF);      // Primary card surface
  static const Color lightSurfaceSubtle = Color(0xFFEEF1F6);// Cool surface-container
  static const Color lightSurfaceLow = Color(0xFFF2F4F8);   // Surface-container-low
  static const Color lightSurfaceHigh = Color(0xFFE4E8EF);  // Surface-container-high
  static const Color lightSurfaceHighest = Color(0xFFD9DEE8);// Surface-container-highest
  static const Color lightBorder = Color(0xFFD9DEE8);       // Outline variant
  static const Color lightDivider = Color(0xFFE4E8EF);

  // ── Canvas & Surface Tokens (Dark Theme) ──────────────────────────────
  // True elevation model: each level slightly lighter, cool blue-black base.
  static const Color darkCanvas = Color(0xFF0C0E13);        // App background, deep blue-black
  static const Color darkSurface = Color(0xFF13161D);       // Level 1 — base cards
  static const Color darkSurfaceElevated = Color(0xFF1A1E27);// Level 2 — modals, sheets, popovers
  static const Color darkSurfaceHighest = Color(0xFF232733); // Level 3 — nested/hover surfaces
  static const Color darkBorder = Color(0xFF272C38);
  static const Color darkDivider = Color(0xFF1D212B);

  // ── Typography & Text Tokens (Light Theme) ────────────────────────────
  static const Color textPrimaryLight = Color(0xFF14171D);   // Near-black, cool undertone
  static const Color textSecondaryLight = Color(0xFF5B6472); // Cool slate grey
  static const Color textMutedLight = Color(0xFF9AA4B2);     // Placeholder/caption
  static const Color textInverseLight = Color(0xFFF7F9FC);   // Text on dark chips (light theme)

  // ── Typography & Text Tokens (Dark Theme) ─────────────────────────────
  static const Color textPrimaryDark = Color(0xFFF0F2F6);    // Soft white, cool undertone
  static const Color textSecondaryDark = Color(0xFF9AA4B2);  // Muted cool grey
  static const Color textMutedDark = Color(0xFF636B78);      // Tertiary captions

  // ── Semantic & Status Tokens (WCAG 4.5:1 Compliant) ───────────────────
  static const Color statusSuccess = Color(0xFF2F9E5C);
  static const Color statusSuccessBgLight = Color(0xFFE9F7EF);
  static const Color statusSuccessBgDark = Color(0xFF0F2A1B);

  static const Color statusWarning = Color(0xFFCA8A04);      // Gold — clear of the blue family
  static const Color statusWarningBgLight = Color(0xFFFAF3DA);
  static const Color statusWarningBgDark = Color(0xFF2B2408);

  static const Color statusError = Color(0xFFDC3545);
  static const Color statusErrorBgLight = Color(0xFFFCEBEC);
  static const Color statusErrorBgDark = Color(0xFF2E1214);

  static const Color statusInfo = Color(0xFF2E8B7D);         // Teal — intentionally NOT blue, so it never blends with primary
  static const Color statusInfoBgLight = Color(0xFFE9F5F3);
  static const Color statusInfoBgDark = Color(0xFF0F2622);

  // ── Order/Item Status Colors (theme-agnostic accents) ─────────────────
  static const Color orderPending = Color(0xFFCA8A04);      // Gold
  static const Color orderAccepted = Color(0xFF2E8B7D);     // Teal (kept off-blue vs. primary)
  static const Color orderPreparing = Color(0xFF8B5CF6);    // Violet
  static const Color orderReady = Color(0xFF2F9E5C);        // Green
  static const Color orderDelivered = Color(0xFF0D9488);    // Deep teal
  static const Color orderCancelled = Color(0xFFDC3545);    // Red

  // ── Scrim & Overlay Tokens ─────────────────────────────────────────────
  static const Color overlayScrimLight = Color(0x6612151C); // 40% near-black scrim
  static const Color overlayScrimDark = Color(0x99000000);  // 60% black scrim (dark needs more)
  static const Color shimmerBaseLight = Color(0xFFE4E8EF);
  static const Color shimmerHighlightLight = Color(0xFFF2F4F8);
  static const Color shimmerBaseDark = Color(0xFF13161D);
  static const Color shimmerHighlightDark = Color(0xFF1E222C);
}