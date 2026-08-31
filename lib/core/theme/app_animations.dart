import 'package:flutter/material.dart';

/// Centralized Animation & Motion Tokens (ui-ux-pro-max standard)
class AppAnimations {
  AppAnimations._();

  // Durations
  static const Duration fast = Duration(milliseconds: 150);      // Micro-interactions, hover
  static const Duration standard = Duration(milliseconds: 250);  // Sheet open, transitions
  static const Duration slow = Duration(milliseconds: 400);      // Page reveals, complex layout
  static const Duration exit = Duration(milliseconds: 180);      // Faster exits for snappy feel

  // Curves
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve snappyCurve = Curves.fastOutSlowIn;
  static const Curve enterCurve = Curves.easeOutQuart;
  static const Curve exitCurve = Curves.easeInCubic;
  static const Curve bounceCurve = Curves.elasticOut;
}
