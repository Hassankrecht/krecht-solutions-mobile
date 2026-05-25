import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/image_helper.dart';
import '../../core/widgets/app_network_image.dart';
import '../../core/widgets/social_links_row.dart';
import '../../models/pricing_category_model.dart';
import '../../models/pricing_package_model.dart';
import '../../models/project_model.dart';
import '../../providers/language_provider.dart';
import '../../providers/services_provider.dart';
import '../../providers/projects_provider.dart';
import '../../providers/pricing_provider.dart';
import '../../providers/settings_provider.dart';
import '../../routes/app_routes.dart';

// Home dashboard that loads preview data for services, projects, pricing, and contact CTA.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  // Loads all home data in parallel so the page can render complete previews.
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Future.wait([
        context.read<ServicesProvider>().fetchServices(),
        context.read<ProjectsProvider>().fetchProjects(),
        context.read<PricingProvider>().init(),
        context.read<SettingsProvider>().fetchAppSettings(),
      ]);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load data';
          _isLoading = false;
        });
      }
    }
  }

  // Opens the configured WhatsApp number from app settings.
  Future<void> _launchWhatsApp() async {
    final settingsProvider = context.read<SettingsProvider>();
    final whatsapp = settingsProvider.appSettings?.whatsappNumber;
    if (whatsapp != null && whatsapp.isNotEmpty) {
      final uri = Uri.parse('https://wa.me/$whatsapp');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      floatingActionButton:
          settingsProvider.appSettings?.whatsappNumber.isNotEmpty == true
          ? FloatingActionButton(
              onPressed: _launchWhatsApp,
              backgroundColor: const Color(0xFF25D366),
              child: const Icon(Icons.chat, color: Colors.white),
            )
          : null,
      body: _isLoading
          ? const _LoadingState()
          : _errorMessage != null
          ? _ErrorState(message: _errorMessage!, onRetry: _fetchData)
          : const _HomeContent(),
    );
  }
}

// Loading state used while home preview data is being fetched.
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.accentBlue),
    );
  }
}

// Error state used when one of the home data requests fails.
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(l10n?.retry ?? 'Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// Contact call-to-action shown when email, phone, or WhatsApp settings exist.
class _ContactCTA extends StatelessWidget {
  const _ContactCTA();

  // Opens contact actions outside the app.
  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // Removes formatting characters before building phone/WhatsApp URLs.
  String _digitsOnly(String value) {
    return value.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>().appSettings;
    final l10n = AppLocalizations.of(context);
    if (settings == null ||
        (settings.contactEmail.isEmpty &&
            settings.contactPhone.isEmpty &&
            settings.whatsappNumber.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.darkNavy,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n?.get('needHelpWithProject') ?? 'Need help with a project?',
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.contrast,
              fontSize: 21,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n?.get('contactCtaBody') ??
                'Reach us directly by email, phone, or WhatsApp.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.contrast.withValues(alpha: 0.72),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (settings.contactEmail.isNotEmpty)
                _ContactAction(
                  icon: Icons.alternate_email_rounded,
                  label: l10n?.get('email') ?? 'Email',
                  onTap: () => _launch(
                    Uri(scheme: 'mailto', path: settings.contactEmail),
                  ),
                ),
              if (settings.contactPhone.isNotEmpty)
                _ContactAction(
                  icon: Icons.call_rounded,
                  label: l10n?.get('call') ?? 'Call',
                  onTap: () => _launch(
                    Uri(
                      scheme: 'tel',
                      path: _digitsOnly(settings.contactPhone),
                    ),
                  ),
                ),
              if (settings.whatsappNumber.isNotEmpty)
                _ContactAction(
                  icon: Icons.chat_rounded,
                  label: l10n?.get('whatsApp') ?? 'WhatsApp',
                  onTap: () => _launch(
                    Uri.parse(
                      'https://wa.me/${_digitsOnly(settings.whatsappNumber)}',
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// Compact button used inside the home contact CTA.
class _ContactAction extends StatelessWidget {
  const _ContactAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.contrast.withValues(alpha: 0.12),
        foregroundColor: AppColors.contrast,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// Main scrollable home content assembled from preview sections.
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const _HeroSection(),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverToBoxAdapter(
            child: Consumer<ServicesProvider>(
              builder: (context, servicesProvider, _) {
                if (servicesProvider.services.isEmpty) {
                  return const SizedBox.shrink();
                }
                return _ServicesPreview(services: servicesProvider.services);
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverToBoxAdapter(
            child: Consumer<ProjectsProvider>(
              builder: (context, projectsProvider, _) {
                if (projectsProvider.projects.isEmpty) {
                  return const SizedBox.shrink();
                }
                return _ProjectsPreview(projects: projectsProvider.projects);
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverToBoxAdapter(
            child: Consumer<PricingProvider>(
              builder: (context, pricingProvider, _) {
                if (pricingProvider.packages.isEmpty) {
                  return const SizedBox.shrink();
                }
                return _PricingPreview(
                  packages: pricingProvider.packages,
                  categories: pricingProvider.categories,
                );
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverToBoxAdapter(child: const _ContactCTA()),
        ),
        SliverToBoxAdapter(
          child: Consumer<SettingsProvider>(
            builder: (context, settingsProvider, _) {
              return SizedBox(
                height:
                    settingsProvider.appSettings?.whatsappNumber.isNotEmpty ==
                        true
                    ? 80
                    : 24,
              );
            },
          ),
        ),
      ],
    );
  }
}

// Home preview of pricing packages with local category filtering.
class _PricingPreview extends StatefulWidget {
  const _PricingPreview({required this.packages, required this.categories});

  final List<PricingPackageModel> packages;
  final List<PricingCategoryModel> categories;

  @override
  State<_PricingPreview> createState() => _PricingPreviewState();
}

class _PricingPreviewState extends State<_PricingPreview> {
  int? _selectedCategoryId;

  // Filters packages by the selected category chip.
  List<PricingPackageModel> get _filteredPackages {
    if (_selectedCategoryId == null) return widget.packages;
    return widget.packages
        .where((package) => package.pricingCategoryId == _selectedCategoryId)
        .toList();
  }

  @override
  void didUpdateWidget(covariant _PricingPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedCategoryId == null) return;
    final hasCategory = widget.categories.any(
      (category) => category.id == _selectedCategoryId,
    );
    if (!hasCategory) {
      _selectedCategoryId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LanguageProvider>().isArabic;
    final l10n = AppLocalizations.of(context);
    final visiblePackages = _filteredPackages;
    final previewPackages = visiblePackages.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            Text(
              l10n?.get('pricingPackages') ?? 'Pricing Packages',
              style: AppTextStyles.sectionTitle,
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.packages),
              child: Text(l10n?.get('viewAll') ?? 'View All'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _HomePricingCategoryFilter(
          categories: widget.categories,
          selectedCategoryId: _selectedCategoryId,
          isArabic: isArabic,
          onSelected: (categoryId) {
            setState(() => _selectedCategoryId = categoryId);
          },
        ),
        const SizedBox(height: 16),
        if (previewPackages.isEmpty)
          const _EmptyPricingFilterState()
        else
          SizedBox(
            height: 286,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: previewPackages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: index < 2 ? 16 : 0),
                  child: _PricingCard(
                    packageData: previewPackages[index],
                    isArabic: isArabic,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

// Horizontal pricing category filter for the home preview.
class _HomePricingCategoryFilter extends StatelessWidget {
  const _HomePricingCategoryFilter({
    required this.categories,
    required this.selectedCategoryId,
    required this.isArabic,
    required this.onSelected,
  });

  final List<PricingCategoryModel> categories;
  final int? selectedCategoryId;
  final bool isArabic;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _HomePricingCategoryChip(
            label: l10n?.get('all') ?? 'All',
            isSelected: selectedCategoryId == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: 8),
          ...categories.map((category) {
            final label = category.getLocalizedName(isArabic);
            if (label.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _HomePricingCategoryChip(
                label: label,
                isSelected: selectedCategoryId == category.id,
                onTap: () => onSelected(category.id),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// Selectable category chip used by the home pricing preview.
class _HomePricingCategoryChip extends StatelessWidget {
  const _HomePricingCategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.darkNavy : AppColors.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected ? AppColors.darkNavy : AppColors.divider,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isSelected ? AppColors.contrast : AppColors.bodyText,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// Empty state shown when the selected pricing category has no packages.
class _EmptyPricingFilterState extends StatelessWidget {
  const _EmptyPricingFilterState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(
        l10n?.get('noPackagesInCategory') ??
            'No packages in this category yet.',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.bodyTextMuted),
      ),
    );
  }
}

// Compact pricing package card shown in the horizontal home preview.
class _PricingCard extends StatelessWidget {
  const _PricingCard({required this.packageData, required this.isArabic});

  final PricingPackageModel packageData;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = packageData.getLocalizedName(isArabic).isNotEmpty
        ? packageData.getLocalizedName(isArabic)
        : (l10n?.get('packageFallback') ?? 'Package');
    final category = packageData.getLocalizedCategory(isArabic);
    final features = packageData.getLocalizedFeatures(isArabic);
    final price = _formatPrice(packageData.formattedPrice, context);

    return SizedBox(
      width: 252,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.packages),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.divider),
              boxShadow: AppTheme.cardShadow,
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.inventory_2_rounded,
                        color: AppColors.accentBlue,
                        size: 19,
                      ),
                    ),
                    const Spacer(),
                    if (packageData.isFeatured)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.darkNavy,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          l10n?.get('featured') ?? 'Featured',
                          style: const TextStyle(
                            color: AppColors.contrast,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (category.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    category,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  price,
                  style: AppTextStyles.serviceTitle.copyWith(
                    color: AppColors.accentBlue,
                    fontSize: 19,
                  ),
                ),
                if (features.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    features.first,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.bodyText.withValues(alpha: 0.72),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 14),
                Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n?.get('viewDetails') ?? 'View Details',
                        style: TextStyle(
                          color: AppColors.accentBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.accentBlue,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Normalizes raw price strings before displaying them.
  String _formatPrice(String value, BuildContext context) {
    final trimmed = value.trim();
    final l10n = AppLocalizations.of(context);
    if (trimmed.isEmpty) {
      return l10n?.get('priceOnRequest') ?? 'Price on request';
    }
    if (trimmed.contains(RegExp(r'[A-Za-z$€£]'))) return trimmed;
    return '\$$trimmed';
  }
}

// Top hero card for the home screen.
class _HeroSection extends StatefulWidget {
  const _HeroSection();

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isMobile = width < 720;
            final isTablet = width >= 720 && width < 1024;
            final isVeryCompact = width < 340;
            final horizontalPadding = isVeryCompact
                ? 18.0
                : isMobile
                ? 24.0
                : isTablet
                ? 34.0
                : 44.0;
            final verticalPadding = isMobile ? 26.0 : 42.0;
            final titleSize = isVeryCompact
                ? 30.0
                : isMobile
                ? 36.0
                : isTablet
                ? 44.0
                : 52.0;

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 620),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 18 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Container(
                constraints: BoxConstraints(minHeight: isMobile ? 0 : 430),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isMobile ? 24 : 30),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF071727),
                      Color(0xFF102D4D),
                      AppColors.darkNavy,
                    ],
                    stops: [0, 0.54, 1],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkNavy.withValues(alpha: 0.32),
                      blurRadius: 34,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned(
                      left: -80,
                      top: -90,
                      child: _HeroGlow(
                        size: isMobile ? 190 : 260,
                        color: AppColors.accentBlue.withValues(alpha: 0.24),
                      ),
                    ),
                    Positioned(
                      right: isMobile ? -80 : -40,
                      bottom: isMobile ? 70 : -54,
                      child: _HeroGlow(
                        size: isMobile ? 220 : 320,
                        color: const Color(0xFF49E6FF).withValues(alpha: 0.18),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.contrast.withValues(alpha: 0.05),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding,
                      ),
                      child: isMobile
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _HeroCopy(
                                  l10n: l10n,
                                  titleSize: titleSize,
                                  isVeryCompact: isVeryCompact,
                                ),
                                const SizedBox(height: 28),
                                _HeroVisual(
                                  controller: _floatController,
                                  compact: true,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  flex: isTablet ? 10 : 11,
                                  child: _HeroCopy(
                                    l10n: l10n,
                                    titleSize: titleSize,
                                    isVeryCompact: false,
                                  ),
                                ),
                                SizedBox(width: isTablet ? 26 : 42),
                                Expanded(
                                  flex: isTablet ? 9 : 10,
                                  child: _HeroVisual(
                                    controller: _floatController,
                                    compact: false,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.l10n,
    required this.titleSize,
    required this.isVeryCompact,
  });

  final AppLocalizations? l10n;
  final double titleSize;
  final bool isVeryCompact;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 620),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.contrast.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.contrast.withValues(alpha: 0.14),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentBlue.withValues(alpha: 0.18),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                Icons.auto_awesome_mosaic_rounded,
                color: AppColors.accentBlue,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n?.get('digitalSolutionsTitle') ??
                'Digital solutions, built cleanly',
            softWrap: true,
            style: AppTextStyles.heroTitle.copyWith(
              fontSize: titleSize,
              height: 1.06,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
              color: AppColors.contrast,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            l10n?.get('digitalSolutionsSubtitle') ??
                'Apps, dashboards, websites, and systems.',
            softWrap: true,
            style: AppTextStyles.heroSubtitle.copyWith(
              fontSize: isVeryCompact ? 16 : 18,
              height: 1.55,
              fontWeight: FontWeight.w500,
              color: AppColors.contrast.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, constraints) {
              final projectButton = SizedBox(
                height: 50,
                child: FilledButton.icon(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.projects),
                  icon: const Icon(Icons.workspaces_rounded, size: 19),
                  label: Text(
                    isVeryCompact
                        ? (l10n?.projects ?? 'Projects')
                        : (l10n?.get('exploreProjects') ?? 'Explore Projects'),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: AppColors.contrast,
                    elevation: 0,
                    shadowColor: AppColors.accentBlue.withValues(alpha: 0.32),
                    textStyle: AppTextStyles.buttonLabel.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              );
              final servicesButton = SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.services),
                  icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                  label: Text(
                    isVeryCompact
                        ? (l10n?.services ?? 'Services')
                        : (l10n?.get('ourServices') ?? 'Our Services'),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.contrast,
                    side: BorderSide(
                      color: AppColors.contrast.withValues(alpha: 0.22),
                    ),
                    textStyle: AppTextStyles.buttonLabel.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              );

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: projectButton),
                  const SizedBox(width: 12),
                  Flexible(child: servicesButton),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          const Center(child: _HomeSocialLinks()),
        ],
      ),
    );
  }
}

// Social media shortcuts shown in the home hero.
class _HomeSocialLinks extends StatelessWidget {
  const _HomeSocialLinks();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>().appSettings;
    final whatsapp = settings?.whatsappNumber.trim() ?? '';

    return SocialLinksRow(
      facebookUrl: settings?.facebookUrl,
      instagramUrl: settings?.instagramUrl,
      linkedinUrl: settings?.linkedinUrl,
      whatsappUrl: whatsapp.isNotEmpty
          ? 'https://wa.me/${whatsapp.replaceAll(RegExp(r'[^0-9+]'), '')}'
          : null,
      style: SocialLinksStyle.filled,
      iconSize: 18,
      buttonSize: 40,
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual({required this.controller, required this.compact});

  final Animation<double> controller;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final lift = 10 * controller.value;

        return Transform.translate(offset: Offset(0, -lift), child: child);
      },
      child: SizedBox(
        height: compact ? 318 : 330,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              top: compact ? 24 : 34,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.contrast.withValues(alpha: 0.14),
                      AppColors.contrast.withValues(alpha: 0.05),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.contrast.withValues(alpha: 0.16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 36,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(compact ? 14 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.accentBlue.withValues(
                                alpha: 0.16,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.accentBlue.withValues(
                                  alpha: 0.32,
                                ),
                              ),
                            ),
                            child: const Icon(
                              Icons.dashboard_customize_rounded,
                              color: AppColors.accentBlue,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: compact ? 118 : 148,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: AppColors.contrast.withValues(
                                      alpha: 0.78,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: compact ? 84 : 104,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppColors.contrast.withValues(
                                      alpha: 0.28,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 16 : 22),
                      Row(
                        children: const [
                          Expanded(
                            child: _MetricCard(
                              icon: Icons.trending_up_rounded,
                              value: '98%',
                              label: 'Uptime',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _MetricCard(
                              icon: Icons.bolt_rounded,
                              value: '4.8x',
                              label: 'Faster',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 14 : 18),
                      const _DashboardRow(
                        icon: Icons.phone_iphone_rounded,
                        label: 'Mobile app',
                        progress: 0.82,
                      ),
                      SizedBox(height: compact ? 10 : 12),
                      const _DashboardRow(
                        icon: Icons.web_asset_rounded,
                        label: 'Web platform',
                        progress: 0.68,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: compact ? 10 : 22,
              top: 0,
              child: Container(
                width: compact ? 92 : 112,
                height: compact ? 92 : 112,
                decoration: BoxDecoration(
                  color: const Color(0xFF071727).withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: AppColors.accentBlue.withValues(alpha: 0.32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentBlue.withValues(alpha: 0.24),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(compact ? 14 : 18),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.auto_awesome_mosaic_rounded,
                      color: AppColors.accentBlue,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: compact ? 4 : -18,
              bottom: compact ? 8 : 18,
              child: Container(
                width: compact ? 150 : 178,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.contrast.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 26,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.layers_rounded,
                        color: AppColors.accentBlue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Launch ready',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.darkNavy,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.accentBlue.withValues(
                                alpha: 0.22,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: AlignmentDirectional.centerStart,
                            child: FractionallySizedBox(
                              widthFactor: 0.72,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.accentBlue,
                                  borderRadius: BorderRadius.circular(10),
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
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF071727).withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.contrast.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accentBlue, size: 19),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.contrast,
              fontSize: 23,
              height: 1,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.contrast.withValues(alpha: 0.58),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardRow extends StatelessWidget {
  const _DashboardRow({
    required this.icon,
    required this.label,
    required this.progress,
  });

  final IconData icon;
  final String label;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.contrast.withValues(alpha: 0.72), size: 18),
        const SizedBox(width: 10),
        SizedBox(
          width: 92,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.contrast.withValues(alpha: 0.68),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.contrast.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: AlignmentDirectional.centerStart,
            child: FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accentBlue, Color(0xFF65E8FF)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroGlow extends StatelessWidget {
  const _HeroGlow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

// Home preview section for a small set of services.
class _ServicesPreview extends StatelessWidget {
  const _ServicesPreview({required this.services});

  final List<Map<String, dynamic>> services;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Text(
                l10n?.get('ourServices') ?? 'Our Services',
                style: AppTextStyles.sectionTitle,
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.services),
                child: Text(l10n?.get('viewAll') ?? 'View All'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final spacing = 12.0;
              final cardWidth = constraints.maxWidth >= 620
                  ? (constraints.maxWidth - spacing) / 2
                  : constraints.maxWidth;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: services
                    .take(4)
                    .map(
                      (service) => SizedBox(
                        width: cardWidth,
                        child: _ServiceCard(service: service),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Compact service preview card with inferred icon and accent color.
class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});

  final Map<String, dynamic> service;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LanguageProvider>().isArabic;
    final title = _localizedValue(
      isArabic: isArabic,
      fallback: service['title'] as String? ?? service['name'] as String? ?? '',
      english: service['title_en'] as String? ?? service['name_en'] as String?,
      arabic: service['title_ar'] as String? ?? service['name_ar'] as String?,
    );
    final description = _localizedValue(
      isArabic: isArabic,
      fallback:
          service['short_description'] as String? ??
          service['description'] as String? ??
          '',
      english:
          service['short_description_en'] as String? ??
          service['description_en'] as String?,
      arabic:
          service['short_description_ar'] as String? ??
          service['description_ar'] as String?,
    );
    final icon = service['icon'] as String? ?? '';
    final serviceIcon = _getIconForService(icon, title);
    final accent = _getColorForService(icon, title);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.services),
        child: Container(
          constraints: const BoxConstraints(minHeight: 126),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(serviceIcon, color: accent, size: 25),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.bodyTextMuted.withValues(alpha: 0.75),
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: AppTextStyles.serviceTitle.copyWith(fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 5),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.bodyText.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _localizedValue({
    required bool isArabic,
    required String fallback,
    String? english,
    String? arabic,
  }) {
    if (isArabic && arabic != null && arabic.isNotEmpty) return arabic;
    return english != null && english.isNotEmpty ? english : fallback;
  }

  // Chooses a Material icon based on service keywords.
  IconData _getIconForService(String? icon, String title) {
    final value = '${icon ?? ''} $title'.toLowerCase();
    if (value.contains('web') || value.contains('website')) {
      return Icons.language_rounded;
    }
    if (value.contains('mobile') || value.contains('app')) {
      return Icons.phone_iphone_rounded;
    }
    if (value.contains('dashboard') || value.contains('admin')) {
      return Icons.space_dashboard_rounded;
    }
    if (value.contains('cloud') || value.contains('hosting')) {
      return Icons.cloud_done_rounded;
    }
    if (value.contains('design') ||
        value.contains('ui') ||
        value.contains('ux')) {
      return Icons.draw_rounded;
    }
    if (value.contains('marketing') || value.contains('seo')) {
      return Icons.campaign_rounded;
    }
    if (value.contains('ecommerce') || value.contains('shop')) {
      return Icons.shopping_bag_rounded;
    }
    if (value.contains('support') || value.contains('maintenance')) {
      return Icons.support_agent_rounded;
    }
    return Icons.auto_awesome_rounded;
  }

  // Chooses an accent color based on service keywords.
  Color _getColorForService(String? icon, String title) {
    final value = '${icon ?? ''} $title'.toLowerCase();
    if (value.contains('mobile') || value.contains('app')) {
      return const Color(0xFF6C63FF);
    }
    if (value.contains('design') ||
        value.contains('ui') ||
        value.contains('ux')) {
      return const Color(0xFFDB2777);
    }
    if (value.contains('cloud') || value.contains('hosting')) {
      return const Color(0xFF0891B2);
    }
    if (value.contains('marketing') || value.contains('seo')) {
      return const Color(0xFFEA580C);
    }
    if (value.contains('ecommerce') || value.contains('shop')) {
      return const Color(0xFF16A34A);
    }
    return AppColors.accentBlue;
  }
}

// Home preview section for featured projects.
class _ProjectsPreview extends StatelessWidget {
  const _ProjectsPreview({required this.projects});

  final List<ProjectModel> projects;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            Text(
              l10n?.get('featuredProjects') ?? 'Featured Projects',
              style: AppTextStyles.sectionTitle,
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.projects),
              child: Text(l10n?.get('viewAll') ?? 'View All'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 238,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: projects.take(5).length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: index < 4 ? 16 : 0),
                child: _ProjectCard(project: projects[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Compact image-backed project card shown in the home preview.
class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LanguageProvider>().isArabic;
    final imageUrl = project.image != null
        ? ImageHelper.buildImageUrl(project.image!)
        : null;
    final categories = project.categories;
    final category = project.category;
    final categoryName = categories != null && categories.isNotEmpty
        ? categories.first.getLocalizedName(isArabic)
        : (category?.getLocalizedName(isArabic) ?? '');
    final title = project.getLocalizedTitle(isArabic);

    return SizedBox(
      width: 292,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/projects/${project.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider),
            boxShadow: AppTheme.cardShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: imageUrl != null
                    ? AppNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.accentBlue,
                          ),
                        ),
                        errorWidget: (context) => const Icon(
                          Icons.image_outlined,
                          size: 48,
                          color: AppColors.bodyTextMuted,
                        ),
                      )
                    : Container(
                        color: AppColors.lightBackground,
                        child: const Icon(
                          Icons.image_outlined,
                          size: 48,
                          color: AppColors.bodyTextMuted,
                        ),
                      ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.darkNavy.withValues(alpha: 0.88),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (categoryName.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentBlue,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.contrast,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.contrast,
                        fontSize: 20,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        if (project.status?.isNotEmpty == true)
                          Expanded(
                            child: Text(
                              project.status!,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.contrast.withValues(
                                  alpha: 0.78,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        else
                          const Spacer(),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.contrast.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.arrow_outward_rounded,
                            color: AppColors.contrast,
                            size: 18,
                          ),
                        ),
                      ],
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
