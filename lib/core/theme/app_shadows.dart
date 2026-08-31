import 'package:flutter/material.dart';

/// Centralized Shadow Tokens (modern_ui_arif Ambient Multi-Stop Diffuse Shadows)
class AppShadows {
  AppShadows._();

  // Card Ambient Lift Shadow (Light Mode)
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0F141414), // rgba(20, 20, 20, 0.06)
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x08141414), // rgba(20, 20, 20, 0.03)
      offset: Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  // Elevated / Hover State Shadow
  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x1A141414), // rgba(20, 20, 20, 0.10)
      offset: Offset(0, 14),
      blurRadius: 32,
      spreadRadius: 0,
    ),
  ];

  // Floating Navigation Dock & FAB Shadow
  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x1F141414), // rgba(20, 20, 20, 0.12)
      offset: Offset(0, 8),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  // Modal / Bottom Sheet Shadow
  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x2E000000), // rgba(0, 0, 0, 0.18)
      offset: Offset(0, 24),
      blurRadius: 48,
      spreadRadius: 0,
    ),
  ];

  // Dark Mode Subtle Elevation
  static const List<BoxShadow> darkCard = [
    BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0, 6),
      blurRadius: 18,
      spreadRadius: 0,
    ),
  ];

  // Primary Accent Glow
  static const List<BoxShadow> accentGlow = [
    BoxShadow(
      color: Color(0x4DE21B70), // rgba(226, 27, 112, 0.30)
      offset: Offset(0, 8),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];
}
