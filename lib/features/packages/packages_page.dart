import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/social_links_row.dart';
import '../../models/pricing_category_model.dart';
import '../../models/pricing_package_model.dart';
import '../../providers/pricing_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/settings_provider.dart';

// Pricing packages page with category filtering and responsive package cards.
class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PricingProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: Text(
          l10n?.get('pricingPackages') ?? 'Pricing Packages',
          style: const TextStyle(
            color: AppColors.contrast,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<PricingProvider>(
        builder: (context, pricingProvider, _) {
          if (pricingProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentBlue),
            );
          }

          if (pricingProvider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      pricingProvider.error!,
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => pricingProvider.init(),
                      child: Text(l10n?.retry ?? 'Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (pricingProvider.categories.isEmpty &&
              pricingProvider.packages.isEmpty) {
            return Center(
              child: Text(
                l10n?.get('noPackagesAvailable') ?? 'No packages available',
                style: const TextStyle(color: AppColors.bodyTextMuted),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _PricingHeader(
                  packageCount: pricingProvider.selectedCategory == null
                      ? pricingProvider.packages.length
                      : pricingProvider.packagesByCategory.length,
                  categories: pricingProvider.categories,
                  selectedCategory: pricingProvider.selectedCategory,
                  onCategorySelected: (category) {
                    pricingProvider.selectCategory(category);
                  },
                  onClearCategory: () {
                    pricingProvider.clearSelectedCategory();
                  },
                  isArabic: languageProvider.isArabic,
                ),
              ),
              if (pricingProvider.packages.isNotEmpty)
                _PackagesSection(
                  packages: pricingProvider.selectedCategory == null
                      ? pricingProvider.packages
                      : pricingProvider.packagesByCategory,
                  isArabic: languageProvider.isArabic,
                ),
            ],
          );
        },
      ),
    );
  }
}

// Dark summary box below the app bar with package count and filters.
class _PricingHeader extends StatelessWidget {
  const _PricingHeader({
    required this.packageCount,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onClearCategory,
    required this.isArabic,
  });

  final int packageCount;
  final List<PricingCategoryModel> categories;
  final PricingCategoryModel? selectedCategory;
  final Function(PricingCategoryModel) onCategorySelected;
  final VoidCallback onClearCategory;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.darkNavy,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.contrast.withValues(alpha: 0.08)),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.contrast.withValues(alpha: 0.10),
                    ),
                  ),
                  child: const Icon(
                    Icons.inventory_2_rounded,
                    color: AppColors.accentBlue,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n?.get('pricingPackages') ?? 'Pricing Packages',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.contrast,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        packageCount == 1
                            ? (l10n?.get('packageAvailable') ??
                                    '{count} package available')
                                .replaceFirst('{count}', '$packageCount')
                            : (l10n?.get('packagesAvailable') ??
                                    '{count} packages available')
                                .replaceFirst('{count}', '$packageCount'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.contrast.withValues(alpha: 0.72),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Center(child: _HeaderSocialLinks()),
            const SizedBox(height: 16),
            _CategoryMenu(
              categories: categories,
              selectedCategory: selectedCategory,
              isArabic: isArabic,
              onChanged: (category) {
                if (category == null) {
                  onClearCategory();
                } else {
                  onCategorySelected(category);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSocialLinks extends StatelessWidget {
  const _HeaderSocialLinks();

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

// Dropdown filter that switches between all packages and one category.
class _CategoryMenu extends StatelessWidget {
  const _CategoryMenu({
    required this.categories,
    required this.selectedCategory,
    required this.isArabic,
    required this.onChanged,
  });

  final List<PricingCategoryModel> categories;
  final PricingCategoryModel? selectedCategory;
  final bool isArabic;
  final ValueChanged<PricingCategoryModel?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const allValue = 'all';
    final selectedValue = selectedCategory?.id.toString() ?? allValue;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          borderRadius: BorderRadius.circular(8),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          items: [
            DropdownMenuItem<String>(
              value: allValue,
              child: Row(
                children: [
                  const Icon(Icons.grid_view_rounded, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n?.get('allCategories') ?? 'All categories',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            ...categories.map(
              (category) => DropdownMenuItem<String>(
                value: category.id.toString(),
                child: Row(
                  children: [
                    const Icon(Icons.category_rounded, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        category.getLocalizedName(isArabic),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          onChanged: (value) {
            if (value == null || value == allValue) {
              onChanged(null);
              return;
            }
            for (final category in categories) {
              if (category.id.toString() == value) {
                onChanged(category);
                return;
              }
            }
          },
        ),
      ),
    );
  }
}

// Responsive grid section for pricing package cards.
class _PackagesSection extends StatelessWidget {
  const _PackagesSection({required this.packages, required this.isArabic});

  final List<PricingPackageModel> packages;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.crossAxisExtent;
          final columns = width >= 900
              ? 3
              : width >= 620
              ? 2
              : 1;

          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisExtent: 396,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return _PackageCard(package: packages[index], isArabic: isArabic);
            }, childCount: packages.length),
          );
        },
      ),
    );
  }
}

// One pricing package card including featured state, feature list, and CTA.
class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package, required this.isArabic});

  final PricingPackageModel package;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final features = package.getLocalizedFeatures(isArabic);
    final description = package.getLocalizedDescription(isArabic);
    final isFeatured = package.isFeatured == true;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: isFeatured ? AppTheme.elevatedShadow : AppTheme.cardShadow,
        border: isFeatured
            ? Border.all(color: AppColors.accentBlue, width: 2)
            : Border.all(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.inventory_2_rounded,
                    color: AppColors.accentBlue,
                    size: 22,
                  ),
                ),
                const Spacer(),
                if (isFeatured)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n?.get('featured') ?? 'Featured',
                      style: const TextStyle(
                        color: AppColors.contrast,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              package.getLocalizedName(isArabic),
              style: AppTextStyles.cardTitle.copyWith(fontSize: 20),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                description,
                style: AppTextStyles.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Text(
              package.formattedPrice,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.heroTitleMobile.copyWith(
                color: AppColors.accentBlue,
                fontSize: 26,
              ),
            ),
            if (features.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: 12),
              ...features.take(4).map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: AppColors.accentBlue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.bodyText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const Spacer(),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/contact');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFeatured
                      ? AppColors.accentBlue
                      : AppColors.darkNavy,
                  foregroundColor: AppColors.contrast,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  l10n?.get('viewDetails') ?? 'View Details',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
