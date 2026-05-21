import 'package:flutter/material.dart';

/// Krecht Solutions design-system color palette.
/// Derived from: public/assets/css/main.css CSS variables.
abstract final class AppColors {
  // ── Brand / Primary ──────────────────────────────────────────────────────
  /// --heading-color  |  Dark Navy
  static const Color darkNavy = Color(0xFF1E3A5A);

  /// Header background
  static const Color header = Color(0xFF3D4D6A);

  /// Dark surface (dark-background --surface-color)
  static const Color darkSurface = Color(0xFF2D4A6A);

  /// Scrolled / semi-transparent header
  static const Color headerScrolled = Color(0xE628385A);

  // ── Accent ───────────────────────────────────────────────────────────────
  /// --accent-color  |  Electric Blue
  static const Color accentBlue = Color(0xFF00B4D8);

  /// Accent hovered (≈ 85 % opacity over white → slightly lighter)
  static const Color accentHover = Color(0xFF00A8C9);

  // ── Backgrounds ──────────────────────────────────────────────────────────
  /// --background-color  |  page default
  static const Color background = Color(0xFFFFFFFF);

  /// .light-background
  static const Color lightBackground = Color(0xFFF5F6F8);

  /// --surface-color  |  cards & boxes
  static const Color surface = Color(0xFFFFFFFF);

  // ── Text ─────────────────────────────────────────────────────────────────
  /// --default-color  |  body text
  static const Color bodyText = Color(0xFF444444);

  /// --contrast-color  |  text on dark/accent
  static const Color contrast = Color(0xFFFFFFFF);

  /// Muted body text (≈ 70 % opacity)
  static const Color bodyTextMuted = Color(0xFF8A8A8A);

  // ── Nav ───────────────────────────────────────────────────────────────────
  static const Color navText = Color(0xFFFFFFFF);
  static const Color navHover = Color(0xFF00B4D8);
  static const Color navDropdownText = Color(0xFF444444);
  static const Color navMobileBackground = Color(0xFFFFFFFF);

  // ── Utility ───────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFDF1529);
  static const Color success = Color(0xFF059652);

  // ── Shadows ───────────────────────────────────────────────────────────────
  /// Card shadow: box-shadow 0px 5px 90px rgba(0,0,0,0.10)
  static const Color shadowSoft = Color(0x1A000000);

  /// Elevated shadow for work-process cards
  static const Color shadowMedium = Color(0x26000000);

  /// Accent-tinted hover shadow
  static const Color shadowAccent = Color(0x2900B4D8);

  // ── Dividers / Borders ────────────────────────────────────────────────────
  static const Color divider = Color(0xFFE8EAED);
  static const Color borderMuted = Color(0xFFCDD2D9);
}
