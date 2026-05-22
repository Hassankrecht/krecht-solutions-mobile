import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../models/pricing_category_model.dart';
import '../../models/pricing_package_model.dart';
import '../../providers/pricing_provider.dart';
import '../../providers/language_provider.dart';

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

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: const Text(
          'Pricing Packages',
          style: TextStyle(
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
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (pricingProvider.categories.isEmpty &&
              pricingProvider.packages.isEmpty) {
            return const Center(
              child: Text(
                'No packages available',
                style: TextStyle(color: AppColors.bodyTextMuted),
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
                        'Pricing Packages',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.contrast,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$packageCount package${packageCount == 1 ? '' : 's'} available',
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
            if (categories.isNotEmpty) ...[
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _CategoryChip(
                        label: 'All',
                        isSelected: selectedCategory == null,
                        onTap: onClearCategory,
                      ),
                    ),
                    ...categories.map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _CategoryChip(
                          label: category.getLocalizedName(isArabic),
                          isSelected: selectedCategory?.id == category.id,
                          onTap: () => onCategorySelected(category),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Selectable pricing category chip.
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentBlue : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.accentBlue : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.contrast : AppColors.bodyText,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
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
              mainAxisExtent: 330,
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

// One pricing package card including featured state, description, and CTA.
class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package, required this.isArabic});

  final PricingPackageModel package;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.cardShadow,
        border: package.isFeatured == true
            ? Border.all(color: AppColors.accentBlue, width: 2)
            : null,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (package.isFeatured == true)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Featured',
                      style: TextStyle(
                        color: AppColors.contrast,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  package.getLocalizedName(isArabic),
                  style: AppTextStyles.cardTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  package.getLocalizedDescription(isArabic),
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Text(
                  package.formattedPrice,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.heroTitleMobile.copyWith(
                    color: AppColors.accentBlue,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/contact');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  child: const Text(
                    'View Details',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
