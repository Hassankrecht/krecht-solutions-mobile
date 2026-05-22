import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Krecht Solutions Flutter theme.
///
/// Usage:
///   MaterialApp(
///     theme: AppTheme.light,
///     darkTheme: AppTheme.dark,
///   )
abstract final class AppTheme {
  // ── Shared radii ──────────────────────────────────────────────────────────
  static const double radiusButton = 50;
  static const double radiusCard = 16;
  static const double radiusInput = 8;
  static const double radiusChip = 50;
  static const double radiusSmall = 4;

  // ── Shared shadows ────────────────────────────────────────────────────────

  /// .services card: box-shadow 0px 5px 90px rgba(0,0,0,0.10)
  static List<BoxShadow> get cardShadow => const [
    BoxShadow(
      color: AppColors.shadowSoft,
      blurRadius: 90,
      offset: Offset(0, 5),
    ),
  ];

  /// .work-process resting shadow (dual-layer)
  static List<BoxShadow> get elevatedShadow => const [
    BoxShadow(color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x17000000), blurRadius: 28, offset: Offset(0, 8)),
  ];

  /// .work-process hover shadow (accent-tinted)
  static List<BoxShadow> get hoverShadow => const [
    BoxShadow(color: Color(0x0F000000), blurRadius: 14, offset: Offset(0, 4)),
    BoxShadow(
      color: AppColors.shadowAccent,
      blurRadius: 42,
      offset: Offset(0, 16),
    ),
  ];

  /// Dropdown nav: box-shadow 0px 0px 30px rgba(0,0,0,0.10)
  static List<BoxShadow> get dropdownShadow => const [
    BoxShadow(color: AppColors.shadowSoft, blurRadius: 30),
  ];

  // ── Light theme ───────────────────────────────────────────────────────────
  // Complete Material theme used for normal app rendering.
  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.darkNavy,
      onPrimary: AppColors.contrast,
      secondary: AppColors.accentBlue,
      onSecondary: AppColors.contrast,
      surface: AppColors.surface,
      onSurface: AppColors.bodyText,
      error: AppColors.error,
      onError: AppColors.contrast,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.openSansTextTheme().copyWith(
        displayLarge: GoogleFonts.jost(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: AppColors.darkNavy,
        ),
        displayMedium: GoogleFonts.jost(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.darkNavy,
        ),
        displaySmall: GoogleFonts.jost(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.darkNavy,
        ),
        headlineLarge: GoogleFonts.jost(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.darkNavy,
        ),
        headlineMedium: GoogleFonts.jost(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.darkNavy,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: AppColors.bodyText,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.bodyText,
        ),
        bodyLarge: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.6,
          color: AppColors.bodyText,
        ),
        bodyMedium: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 24 / 14,
          color: AppColors.bodyText,
        ),
        bodySmall: GoogleFonts.openSans(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.bodyTextMuted,
        ),
        labelLarge: GoogleFonts.jost(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
          color: AppColors.contrast,
        ),
      ),
    );

    return base.copyWith(
      // ── AppBar ─────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.header,
        foregroundColor: AppColors.contrast,
        elevation: 0,
        scrolledUnderElevation: 4,
        shadowColor: AppColors.shadowMedium,
        centerTitle: false,
        titleTextStyle: GoogleFonts.jost(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
          color: AppColors.contrast,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // ── ElevatedButton ─────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentBlue,
          foregroundColor: AppColors.contrast,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.jost(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),

      // ── OutlinedButton ──────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accentBlue,
          side: const BorderSide(color: AppColors.accentBlue, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.jost(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),

      // ── TextButton ──────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentBlue,
          textStyle: GoogleFonts.jost(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // ── Card ────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── InputDecoration ────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: AppColors.borderMuted),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: AppColors.borderMuted),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: AppColors.accentBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: GoogleFonts.openSans(
          fontSize: 14,
          color: AppColors.bodyTextMuted,
        ),
      ),

      // ── Chip ────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightBackground,
        selectedColor: AppColors.accentBlue,
        labelStyle: GoogleFonts.jost(fontSize: 15, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),

      // ── Divider ─────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ── NavigationBar ───────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.header,
        indicatorColor: AppColors.accentBlue.withValues(alpha: 0.20),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.accentBlue);
          }
          return const IconThemeData(color: AppColors.navText);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.accentBlue,
            );
          }
          return GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.navText,
          );
        }),
      ),

      // ── Floating Action Button ──────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentBlue,
        foregroundColor: AppColors.contrast,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // ── Snackbar ────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkNavy,
        contentTextStyle: GoogleFonts.openSans(
          fontSize: 14,
          color: AppColors.contrast,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusInput),
        ),
      ),
    );
  }

  // ── Dark theme ────────────────────────────────────────────────────────────
  // Dark Material theme used when the system/app enables dark mode.
  static ThemeData get dark {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.accentBlue,
      onPrimary: AppColors.contrast,
      secondary: AppColors.accentBlue,
      onSecondary: AppColors.contrast,
      surface: AppColors.darkSurface,
      onSurface: AppColors.contrast,
      error: AppColors.error,
      onError: AppColors.contrast,
    );

    return light.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkNavy,
      appBarTheme: light.appBarTheme.copyWith(
        backgroundColor: AppColors.header,
      ),
      cardTheme: light.cardTheme.copyWith(color: AppColors.darkSurface),
    );
  }
}
