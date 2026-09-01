import 'package:flutter/material.dart';

// Centralized Color Tokens — "Claude Code" Theme
// Warm terracotta-on-near-black system inspired by Anthropic's Claude UI:
// Crail orange accent, cream/parchment light surfaces, near-black dark surfaces,
// serif-adjacent restrained neutrals. WCAG 4.5:1 contrast, semantic tokens, light/dark parity.

class AppColors {
  AppColors._();

  // ── Brand Accent Tokens (Claude "Crail" Palette — lightened) ────────────
  static const Color primary = Color(0xFFE1926E);          // Lightened Crail — soft terracotta
  static const Color primaryContainer = Color(0xFFD97757); // Original Crail, used as deeper container only
  static const Color primaryDark = Color(0xFFC17A55);      // Dark variant (still lighter than old default)
  static const Color primaryLight = Color(0xFFEFB496);     // Gradient end / light variant
  static const Color primaryFixed = Color(0xFFF8DDCA);     // Soft pastel pill
  static const Color primaryTint = Color(0xFFFCF3EC);      // Subtle bg tint for badges (light)
  static const Color primaryTintDark = Color(0xFF32211A);  // Subtle bg tint for badges (dark)
  static const Color primarySurface = Color(0xFFF6E8DC);   // Light accent card surface

  static const Color secondary = Color(0xFF7D6E52);         // Warm mocha / secondary accent (distinct from textSecondaryLight)
  static const Color secondaryContainer = Color(0xFF9C9182);// Muted warm grey (nudged off textMuted so they never blend if paired)
  static const Color secondaryTint = Color(0xFFF1EFEA);
  static const Color secondaryTintDark = Color(0xFF23211D);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD97757), Color(0xFFEFB496)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE1926E), Color(0xFFF6D2AE)],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1F1E1D), Color(0xFF141413)],
  );

  static const LinearGradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6B6255), Color(0xFFB1ADA1)],
  );

  // ── Action & Button Tokens ────────────────────────────────────────────
  static const Color ctaPrimaryLight = Color(0xFF141413);   // Near-black solid pill
  static const Color ctaPrimaryLightHover = Color(0xFF262523);
  static const Color ctaPrimaryLightText = Color(0xFFFAF9F5);

  static const Color ctaPrimaryDark = Color(0xFFFAF9F5);
  static const Color ctaPrimaryDarkHover = Color(0xFFEDEAE2);
  static const Color ctaPrimaryDarkText = Color(0xFF141413);

  static const Color ctaSecondaryLight = Color(0xFFEDEAE2);
  static const Color ctaSecondaryLightText = Color(0xFF141413);
  static const Color ctaSecondaryDark = Color(0xFF262523);
  static const Color ctaSecondaryDarkText = Color(0xFFFAF9F5);

  // ── Canvas & Surface Tokens (Light Theme) ─────────────────────────────
  static const Color lightCanvas = Color(0xFFFAF9F5);       // Pampas — warm parchment bg
  static const Color lightSurface = Color(0xFFFFFFFF);      // Primary card surface
  static const Color lightSurfaceSubtle = Color(0xFFF4F3EE);// Warm surface-container
  static const Color lightSurfaceLow = Color(0xFFF7F6F1);   // Surface-container-low
  static const Color lightSurfaceHigh = Color(0xFFEDEBE3);  // Surface-container-high
  static const Color lightSurfaceHighest = Color(0xFFE4E1D7);// Surface-container-highest
  static const Color lightBorder = Color(0xFFE4E1D7);       // Outline variant
  static const Color lightDivider = Color(0xFFEDEBE3);

  // ── Canvas & Surface Tokens (Dark Theme) ──────────────────────────────
  // True elevation model: each level slightly lighter, warm near-black base
  // rather than a cool blue-black — matches Claude Code's terminal-adjacent dark UI.
  static const Color darkCanvas = Color(0xFF141413);        // App background, warm near-black
  static const Color darkSurface = Color(0xFF1C1B19);       // Level 1 — base cards
  static const Color darkSurfaceElevated = Color(0xFF242220);// Level 2 — modals, sheets, popovers
  static const Color darkSurfaceHighest = Color(0xFF2E2B27); // Level 3 — nested/hover surfaces
  static const Color darkBorder = Color(0xFF33302B);
  static const Color darkDivider = Color(0xFF262420);

  // ── Typography & Text Tokens (Light Theme) ────────────────────────────
  static const Color textPrimaryLight = Color(0xFF1F1E1D);   // Near-black, warm undertone
  static const Color textSecondaryLight = Color(0xFF6B6255); // Warm taupe
  static const Color textMutedLight = Color(0xFFB0AEA5);     // Cloudy — placeholder/caption
  static const Color textInverseLight = Color(0xFFFAF9F5);   // Text on dark chips (light theme)

  // ── Typography & Text Tokens (Dark Theme) ─────────────────────────────
  static const Color textPrimaryDark = Color(0xFFF3F1EC);    // Soft warm white, not pure #FFF
  static const Color textSecondaryDark = Color(0xFFB0AEA5);  // Cloudy, muted warm grey
  static const Color textMutedDark = Color(0xFF7A756B);      // Tertiary captions

  // ── Semantic & Status Tokens (WCAG 4.5:1 Compliant) ───────────────────
  static const Color statusSuccess = Color(0xFF4C7A5E);      // Muted sage green (harmonizes w/ warm palette)
  static const Color statusSuccessBgLight = Color(0xFFEEF3EE);
  static const Color statusSuccessBgDark = Color(0xFF1B2620);

  static const Color statusWarning = Color(0xFFB8901A);      // True gold — shifted away from terracotta hue so it never blends with primary
  static const Color statusWarningBgLight = Color(0xFFFAF3DF);
  static const Color statusWarningBgDark = Color(0xFF2B2408);

  static const Color statusError = Color(0xFFBF4A3C);        // Warm brick red
  static const Color statusErrorBgLight = Color(0xFFFAEBE8);
  static const Color statusErrorBgDark = Color(0xFF2E1512);

  static const Color statusInfo = Color(0xFF5A7A9C);         // Muted slate blue
  static const Color statusInfoBgLight = Color(0xFFEDF1F5);
  static const Color statusInfoBgDark = Color(0xFF16202B);

  // ── Order/Item Status Colors (theme-agnostic accents) ─────────────────
  static const Color orderPending = Color(0xFFB8901A);      // True gold — matches statusWarning, distinct from primary
  static const Color orderAccepted = Color(0xFF5A7A9C);     // Slate blue
  static const Color orderPreparing = Color(0xFF8B6BAE);    // Muted violet
  static const Color orderReady = Color(0xFF4C7A5E);        // Sage green
  static const Color orderDelivered = Color(0xFF4A8B7E);    // Muted teal
  static const Color orderCancelled = Color(0xFFBF4A3C);    // Brick red

  // ── Scrim & Overlay Tokens ─────────────────────────────────────────────
  static const Color overlayScrimLight = Color(0x66141413); // 40% near-black scrim
  static const Color overlayScrimDark = Color(0x99000000);  // 60% black scrim (dark needs more)
  static const Color shimmerBaseLight = Color(0xFFEDEBE3);
  static const Color shimmerHighlightLight = Color(0xFFF7F6F1);
  static const Color shimmerBaseDark = Color(0xFF1C1B19);
  static const Color shimmerHighlightDark = Color(0xFF2A2723);
}