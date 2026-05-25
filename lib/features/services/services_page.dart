import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/social_links_row.dart';
import '../../providers/language_provider.dart';
import '../../providers/services_provider.dart';
import '../../providers/settings_provider.dart';

// Services index page that loads services and displays them in a responsive grid.
class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicesProvider>().fetchServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: Text(
          l10n?.services ?? 'Services',
          style: const TextStyle(
            color: AppColors.contrast,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<ServicesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.services.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentBlue),
            );
          }
          if (provider.error != null && provider.services.isEmpty) {
            return _ErrorState(
              message: provider.error!,
              onRetry: provider.fetchServices,
            );
          }
          if (provider.services.isEmpty) {
            return const _EmptyState();
          }
          return RefreshIndicator(
            color: AppColors.accentBlue,
            onRefresh: provider.fetchServices,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _ServicesHeader(count: provider.services.length),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          mainAxisExtent: 224,
                        ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return _ServiceCard(
                            service: provider.services[index],
                          );
                        }, childCount: provider.services.length),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Dark summary box shown below the app bar.
class _ServicesHeader extends StatelessWidget {
  const _ServicesHeader({required this.count});

  final int count;

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
                    Icons.auto_awesome_rounded,
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
                        l10n?.get('professionalServices') ??
                            'Professional Services',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.contrast,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        (l10n?.get('solutionsReady') ??
                                '{count} solutions ready for your business')
                            .replaceFirst('{count}', '$count'),
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

// One service card with an inferred icon/color and contact navigation.
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
    final l10n = AppLocalizations.of(context);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed('/contact'),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(18),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(serviceIcon, color: accent, size: 27),
                  ),
                  const Spacer(),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.bodyTextMuted.withValues(alpha: 0.78),
                      size: 19,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.serviceTitle.copyWith(
                  fontSize: 19,
                  height: 1.18,
                ),
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 9),
                Expanded(
                  child: Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      height: 1.45,
                      color: AppColors.bodyText.withValues(alpha: 0.72),
                    ),
                  ),
                ),
              ] else
                const Spacer(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n?.get('discussThisService') ??
                          'Discuss this service',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.bodyTextMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
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

// Empty state shown when the services API returns no results.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.miscellaneous_services_rounded,
            size: 64,
            color: AppColors.accentBlue,
          ),
          const SizedBox(height: 16),
          Text(
            l10n?.noServices ?? 'No services available',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkNavy,
            ),
          ),
        ],
      ),
    );
  }
}

// Error state with retry action for failed service loading.
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: AppColors.bodyTextMuted,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.bodyTextMuted,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: AppColors.contrast,
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
