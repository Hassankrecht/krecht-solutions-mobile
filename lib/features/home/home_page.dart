import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/image_helper.dart';
import '../../core/widgets/app_network_image.dart';
import '../../models/pricing_category_model.dart';
import '../../models/pricing_package_model.dart';
import '../../models/project_model.dart';
import '../../providers/language_provider.dart';
import '../../providers/services_provider.dart';
import '../../providers/projects_provider.dart';
import '../../providers/pricing_provider.dart';
import '../../providers/settings_provider.dart';
import '../../routes/app_routes.dart';

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

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.accentBlue),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
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
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _ContactCTA extends StatelessWidget {
  const _ContactCTA();

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _digitsOnly(String value) {
    return value.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>().appSettings;
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
            'Need help with a project?',
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.contrast,
              fontSize: 21,
            ),
          ),
          const SizedBox(height: 6),
          Text(
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
                  label: 'Email',
                  onTap: () => _launch(
                    Uri(scheme: 'mailto', path: settings.contactEmail),
                  ),
                ),
              if (settings.contactPhone.isNotEmpty)
                _ContactAction(
                  icon: Icons.call_rounded,
                  label: 'Call',
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
                  label: 'WhatsApp',
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

class _PricingPreview extends StatefulWidget {
  const _PricingPreview({required this.packages, required this.categories});

  final List<PricingPackageModel> packages;
  final List<PricingCategoryModel> categories;

  @override
  State<_PricingPreview> createState() => _PricingPreviewState();
}

class _PricingPreviewState extends State<_PricingPreview> {
  int? _selectedCategoryId;

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
            Text('Pricing Packages', style: AppTextStyles.sectionTitle),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.packages),
              child: const Text('View All'),
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
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _HomePricingCategoryChip(
            label: 'All',
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

class _EmptyPricingFilterState extends StatelessWidget {
  const _EmptyPricingFilterState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(
        'No packages in this category yet.',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.bodyTextMuted),
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  const _PricingCard({required this.packageData, required this.isArabic});

  final PricingPackageModel packageData;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final name = packageData.getLocalizedName(isArabic).isNotEmpty
        ? packageData.getLocalizedName(isArabic)
        : 'Package';
    final category = packageData.getLocalizedCategory(isArabic);
    final features = packageData.getLocalizedFeatures(isArabic);
    final price = _formatPrice(packageData.formattedPrice);

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
                        child: const Text(
                          'Featured',
                          style: TextStyle(
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Details',
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

  String _formatPrice(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Price on request';
    if (trimmed.contains(RegExp(r'[A-Za-z$€£]'))) return trimmed;
    return '\$$trimmed';
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
        child: Container(
          height: 148,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.darkNavy, AppColors.header],
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowMedium,
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned(
                right: -18,
                top: 18,
                child: Container(
                  width: 82,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue.withValues(alpha: 0.34),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Positioned(
                right: 14,
                top: 46,
                child: Container(
                  width: 54,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.contrast.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Positioned(
                right: 24,
                bottom: 18,
                child: Icon(
                  Icons.dashboard_customize_rounded,
                  size: 54,
                  color: AppColors.contrast.withValues(alpha: 0.18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Digital solutions, built cleanly',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.cardTitle.copyWith(
                              color: AppColors.contrast,
                              fontSize: 23,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Apps, dashboards, websites, and systems.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.contrast.withValues(alpha: 0.72),
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 38,
                            child: FilledButton.icon(
                              onPressed: () => Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.projects),
                              icon: const Icon(
                                Icons.workspaces_rounded,
                                size: 17,
                              ),
                              label: const Text('Explore Projects'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.accentBlue,
                                foregroundColor: AppColors.contrast,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 56,
                      height: 76,
                      decoration: BoxDecoration(
                        color: AppColors.contrast.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.contrast.withValues(alpha: 0.12),
                        ),
                      ),
                      child: const Icon(
                        Icons.rocket_launch_rounded,
                        color: AppColors.accentBlue,
                        size: 30,
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

class _ServicesPreview extends StatelessWidget {
  const _ServicesPreview({required this.services});

  final List<Map<String, dynamic>> services;

  @override
  Widget build(BuildContext context) {
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
              Text('Our Services', style: AppTextStyles.sectionTitle),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.services),
                child: const Text('View All'),
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

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});

  final Map<String, dynamic> service;

  @override
  Widget build(BuildContext context) {
    final title =
        service['title'] as String? ?? service['name'] as String? ?? '';
    final description =
        service['short_description'] as String? ??
        service['description'] as String? ??
        '';
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

class _ProjectsPreview extends StatelessWidget {
  const _ProjectsPreview({required this.projects});

  final List<ProjectModel> projects;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            Text('Featured Projects', style: AppTextStyles.sectionTitle),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.projects),
              child: const Text('View All'),
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

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final imageUrl = project.image != null
        ? ImageHelper.buildImageUrl(project.image!)
        : null;
    final categories = project.categories;
    final category = project.category;
    final categoryName = categories != null && categories.isNotEmpty
        ? categories.first.name
        : (category?.name ?? '');

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
                      project.title,
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
