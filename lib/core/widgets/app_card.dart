import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Krecht Solutions card variants.
///
/// CSS sources:
///   [AppCard.service]  → .services .service-item
///                         box-shadow: 0px 5px 90px rgba(0,0,0,0.10)
///                         padding: 50px 30px
///                         hover: translateY(-10px)
///
///   [AppCard.process]  → .work-process .steps-item
///                         border-radius: 16px
///                         dual-layer shadow
///                         hover: translateY(-6px) + accent-tinted shadow
///
///   [AppCard.surface]  → generic white surface card (surface-color)
///                         soft single shadow

// ── Service Card ──────────────────────────────────────────────────────────────

/// Maps to `.services .service-item`.
/// Shows an accent icon, a bold title, and a description.
class AppServiceCard extends StatefulWidget {
  const AppServiceCard({
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  State<AppServiceCard> createState() => _AppServiceCardState();
}

class _AppServiceCardState extends State<AppServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          transform: Matrix4.translationValues(0, _hovered ? -10 : 0, 0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            boxShadow: AppTheme.cardShadow,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 36,
                  color: _hovered
                      ? AppColors.accentHover
                      : AppColors.accentBlue,
                ),
                child: Icon(
                  widget.icon,
                  size: 36,
                  color: _hovered
                      ? AppColors.accentHover
                      : AppColors.accentBlue,
                ),
              ),
              const SizedBox(height: 10),
              // Title
              Text(
                widget.title,
                style: GoogleFonts.jost(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _hovered ? AppColors.accentBlue : AppColors.darkNavy,
                ),
              ),
              const SizedBox(height: 15),
              // Description
              Text(
                widget.description,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  height: 24 / 14,
                  color: AppColors.bodyText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Process / Steps Card ──────────────────────────────────────────────────────

/// Maps to `.work-process .steps-item`.
/// Includes a cover image, floating step number badge, title, body, and
/// optional feature bullet list.
class AppProcessCard extends StatefulWidget {
  const AppProcessCard({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.imageProvider,
    this.features = const [],
    this.onTap,
    super.key,
  });

  final int stepNumber;
  final String title;
  final String description;
  final ImageProvider? imageProvider;
  final List<String> features;
  final VoidCallback? onTap;

  @override
  State<AppProcessCard> createState() => _AppProcessCardState();
}

class _AppProcessCardState extends State<AppProcessCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            boxShadow: _hovered
                ? AppTheme.hoverShadow
                : AppTheme.elevatedShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image area
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.radiusCard),
                ),
                child: SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: widget.imageProvider != null
                      ? AnimatedScale(
                          scale: _hovered ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          child: Image(
                            image: widget.imageProvider!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ColoredBox(
                          color: AppColors.lightBackground,
                          child: Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: AppColors.borderMuted,
                          ),
                        ),
                ),
              ),

              // ── Content area
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 40, 30, 30),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.title,
                          style: GoogleFonts.jost(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.22,
                            color: AppColors.darkNavy,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Description
                        Text(
                          widget.description,
                          style: GoogleFonts.openSans(
                            fontSize: 15,
                            height: 1.65,
                            color: AppColors.bodyText.withValues(alpha: 0.75),
                          ),
                        ),
                        if (widget.features.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          // Feature list
                          ...widget.features.map(
                            (f) => Padding(
                              padding: const EdgeInsets.only(bottom: 11),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 16,
                                    color: AppColors.accentBlue,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      f,
                                      style: GoogleFonts.openSans(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.bodyText.withValues(
                                          alpha: 0.80,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    // ── Floating step-number badge
                    Positioned(
                      top: -70,
                      left: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _hovered
                              ? AppColors.accentBlue
                              : AppColors.accentBlue.withValues(alpha: 0.12),
                          border: Border.all(
                            color: _hovered
                                ? AppColors.accentBlue
                                : AppColors.accentBlue.withValues(alpha: 0.45),
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${widget.stepNumber}',
                          style: GoogleFonts.jost(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _hovered
                                ? AppColors.contrast
                                : AppColors.accentBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Generic Surface Card ──────────────────────────────────────────────────────

/// A plain white surface card with soft shadow.
/// Use for FAQ items, testimonials, stat boxes, etc.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding,
    this.borderRadius,
    this.color,
    this.shadows,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? color;
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius:
            borderRadius ?? BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: shadows ?? AppTheme.elevatedShadow,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}
