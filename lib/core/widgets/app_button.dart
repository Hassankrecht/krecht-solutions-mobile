import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Krecht Solutions button variants.
///
/// CSS sources mapped:
///   [AppButton.primary]   → .hero .btn-get-started  /  .header .btn-getstarted
///   [AppButton.outlined]  → .about .read-more  /  .call-to-action .cta-btn (border)
///   [AppButton.cta]       → .call-to-action .cta-btn  /  .btn-contact-submit
///   [AppButton.text]      → plain text links styled in accent
///
/// All share border-radius: 50px (StadiumBorder) per the CSS.
enum _AppButtonVariant { primary, outlined, cta, text }

class AppButton extends StatelessWidget {
  const AppButton._({
    required _AppButtonVariant variant,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    super.key,
  }) : _variant = variant;

  // ── Factories ─────────────────────────────────────────────────────────────

  /// Filled accent-blue button (.btn-get-started, .btn-getstarted)
  /// Padding: 10px 28px  |  font-size 15px  |  border-radius 50px
  factory AppButton.primary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    Widget? icon,
    bool isLoading = false,
    double? width,
  }) =>
      AppButton._(
        key: key,
        variant: _AppButtonVariant.primary,
        label: label,
        onPressed: onPressed,
        icon: icon,
        isLoading: isLoading,
        width: width,
      );

  /// Outlined accent-blue button (.about .read-more)
  /// Border: 2px solid accent  |  padding 8px 28px
  factory AppButton.outlined({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    Widget? icon,
    bool isLoading = false,
    double? width,
  }) =>
      AppButton._(
        key: key,
        variant: _AppButtonVariant.outlined,
        label: label,
        onPressed: onPressed,
        icon: icon,
        isLoading: isLoading,
        width: width,
      );

  /// Large CTA button (.call-to-action .cta-btn, .btn-contact-submit)
  /// Padding: 12px 40px  |  font-size 16px
  factory AppButton.cta({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    Widget? icon,
    bool isLoading = false,
    double? width,
  }) =>
      AppButton._(
        key: key,
        variant: _AppButtonVariant.cta,
        label: label,
        onPressed: onPressed,
        icon: icon,
        isLoading: isLoading,
        width: width,
      );

  /// Plain text/link button
  factory AppButton.text({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    Widget? icon,
  }) =>
      AppButton._(
        key: key,
        variant: _AppButtonVariant.text,
        label: label,
        onPressed: onPressed,
        icon: icon,
      );

  // ── Fields ────────────────────────────────────────────────────────────────
  final _AppButtonVariant _variant;
  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final double? width;

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.contrast,
            ),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: _labelStyle),
                  const SizedBox(width: 6),
                  icon!,
                ],
              )
            : Text(label, style: _labelStyle);

    Widget button;

    switch (_variant) {
      case _AppButtonVariant.primary:
        button = _buildPrimary(child);
      case _AppButtonVariant.outlined:
        button = _buildOutlined(child);
      case _AppButtonVariant.cta:
        button = _buildCta(child);
      case _AppButtonVariant.text:
        button = _buildText(child);
    }

    if (width != null) {
      return SizedBox(width: width, child: button);
    }
    return button;
  }

  // ── Private builders ──────────────────────────────────────────────────────

  Widget _buildPrimary(Widget child) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentBlue,
        foregroundColor: AppColors.contrast,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 11),
        shape: const StadiumBorder(),
      ),
      child: child,
    );
  }

  Widget _buildOutlined(Widget child) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accentBlue,
        side: const BorderSide(color: AppColors.accentBlue, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 9),
        shape: const StadiumBorder(),
      ),
      child: child,
    );
  }

  Widget _buildCta(Widget child) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentBlue,
        foregroundColor: AppColors.contrast,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: const StadiumBorder(),
      ),
      child: child,
    );
  }

  Widget _buildText(Widget child) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accentBlue,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        shape: const StadiumBorder(),
      ),
      child: child,
    );
  }

  // ── Label style helpers ───────────────────────────────────────────────────

  TextStyle get _labelStyle {
    switch (_variant) {
      case _AppButtonVariant.cta:
        return GoogleFonts.jost(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
          color: AppColors.contrast,
        );
      case _AppButtonVariant.outlined:
        return GoogleFonts.jost(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
          color: AppColors.accentBlue,
        );
      case _AppButtonVariant.text:
        return GoogleFonts.jost(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.accentBlue,
        );
      case _AppButtonVariant.primary:
        return GoogleFonts.jost(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
          color: AppColors.contrast,
        );
    }
  }
}
