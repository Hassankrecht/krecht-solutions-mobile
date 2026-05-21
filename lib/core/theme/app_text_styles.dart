import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Krecht Solutions typography system.
///
/// CSS source:
///   --heading-font : "Jost"      → headings / section titles / buttons
///   --default-font : "Open Sans" → body / captions
///   --nav-font     : "Poppins"   → navigation / labels
abstract final class AppTextStyles {
  // ── Heading font (Jost) ───────────────────────────────────────────────────

  /// Hero H1: font-size 48px, weight 700, line-height 56px
  static TextStyle get heroTitle => GoogleFonts.jost(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 56 / 48,
    color: AppColors.contrast,
  );

  /// Hero H1 – mobile (≤ 640 px): font-size 28px, line-height 36px
  static TextStyle get heroTitleMobile => GoogleFonts.jost(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 36 / 28,
    color: AppColors.contrast,
  );

  /// Hero subtitle: font-size 22px, weight 600
  static TextStyle get heroSubtitle => GoogleFonts.openSans(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.contrast.withValues(alpha: 0.85),
  );

  /// Section title H2: font-size 32px, weight 700, uppercase
  static TextStyle get sectionTitle => GoogleFonts.jost(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: AppColors.darkNavy,
  );

  /// Page / card H3: font-size 22px, weight 700
  static TextStyle get cardTitle => GoogleFonts.jost(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01 * 22,
    color: AppColors.darkNavy,
  );

  /// Service card H4: font-size 20px, weight 700
  static TextStyle get serviceTitle => GoogleFonts.jost(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.darkNavy,
  );

  /// Logo / brand name: font-size 30px, weight 500, letter-spacing 2px, uppercase
  static TextStyle get logoText => GoogleFonts.jost(
    fontSize: 30,
    fontWeight: FontWeight.w500,
    letterSpacing: 2,
    color: AppColors.contrast,
  );

  /// Footer brand name: font-size 28px, weight 600
  static TextStyle get footerBrand => GoogleFonts.jost(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.darkNavy,
  );

  // ── Nav font (Poppins) ────────────────────────────────────────────────────

  /// Desktop nav link: font-size 15px, weight 400
  static TextStyle get navLink => GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.navText,
  );

  /// Mobile nav link: font-size 17px, weight 500
  static TextStyle get navLinkMobile => GoogleFonts.poppins(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: AppColors.navDropdownText,
  );

  /// Button label (primary / CTA): font-size 15px, weight 500, letter-spacing 1px
  static TextStyle get buttonLabel => GoogleFonts.jost(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 1,
    color: AppColors.contrast,
  );

  /// Button label – large (CTA section): font-size 16px
  static TextStyle get buttonLabelLarge => GoogleFonts.jost(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 1,
    color: AppColors.contrast,
  );

  // ── Default font (Open Sans) ──────────────────────────────────────────────

  /// Body text: font-size 16px, weight 400
  static TextStyle get body => GoogleFonts.openSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.bodyText,
  );

  /// Body small (service card description): font-size 14px, line-height 24px
  static TextStyle get bodySmall => GoogleFonts.openSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 24 / 14,
    color: AppColors.bodyText,
  );

  /// Work-process card body: font-size 15px, line-height 1.65
  static TextStyle get bodyMedium => GoogleFonts.openSans(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.65,
    color: AppColors.bodyText.withValues(alpha: 0.75),
  );

  /// Footer body: font-size 14px
  static TextStyle get footerBody => GoogleFonts.openSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.bodyText,
  );

  /// Caption / credits: font-size 13px
  static TextStyle get caption => GoogleFonts.openSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.bodyTextMuted,
  );

  /// Feature / skill label: font-size 13.5px, weight 500
  static TextStyle get featureLabel => GoogleFonts.openSans(
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    color: AppColors.bodyText.withValues(alpha: 0.80),
  );

  /// Section H4 (footer section headers): font-size 16px, weight 700
  static TextStyle get subheading => GoogleFonts.jost(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.darkNavy,
  );
}
