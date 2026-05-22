import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/image_helper.dart';
import '../../core/widgets/app_network_image.dart';
import '../../models/category_model.dart';
import '../../models/project_model.dart';
import '../../providers/language_provider.dart';
import '../../providers/projects_provider.dart';
import '../../routes/app_routes.dart';

// Projects index page with category filtering and responsive project cards.
class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProjectsProvider>();
      provider.fetchProjects(refresh: true);
      provider.fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isArabic = context.watch<LanguageProvider>().isArabic;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        foregroundColor: AppColors.contrast,
        title: Text(
          localizations?.projects ?? 'Projects',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<ProjectsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.projects.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentBlue),
            );
          }
          if (provider.error != null && provider.projects.isEmpty) {
            return _ErrorState(
              message: provider.error!,
              onRetry: () => provider.fetchProjects(refresh: true),
            );
          }
          if (provider.projects.isEmpty) {
            return const _EmptyState();
          }

          final projects = provider.filteredProjects;

          return RefreshIndicator(
            color: AppColors.accentBlue,
            onRefresh: () => provider.fetchProjects(refresh: true),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _ProjectsHeader(
                    projectCount: projects.length,
                    categories: provider.categories,
                    selectedCategory: provider.selectedCategory,
                    isArabic: isArabic,
                    onCategoryChanged: (category) {
                      if (category == null) {
                        provider.clearCategory();
                      } else {
                        provider.selectCategory(category);
                      }
                    },
                  ),
                ),
                if (projects.isEmpty)
                  const SliverFillRemaining(child: _EmptyState())
                else
                  SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final availableWidth = (constraints.crossAxisExtent - 32)
                          .clamp(280.0, double.infinity)
                          .toDouble();
                      final isCompact = availableWidth < 640;

                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: isCompact
                                    ? availableWidth
                                    : 360,
                                mainAxisExtent: isCompact ? 440 : 420,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final project = projects[index];
                            return _ProjectCard(
                              key: ValueKey('project-${project.id}'),
                              project: project,
                              categories: provider.categories,
                              isArabic: isArabic,
                            );
                          }, childCount: projects.length),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Dark summary box below the app bar with project count and category filter.
class _ProjectsHeader extends StatelessWidget {
  const _ProjectsHeader({
    required this.projectCount,
    required this.categories,
    required this.selectedCategory,
    required this.isArabic,
    required this.onCategoryChanged,
  });

  final int projectCount;
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;
  final bool isArabic;
  final ValueChanged<CategoryModel?> onCategoryChanged;

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
                    Icons.folder_special_rounded,
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
                        l10n?.get('ourWork') ?? 'Our Work',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.contrast,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        projectCount == 1
                            ? (l10n?.get('projectAvailable') ??
                                    '{count} project available')
                                .replaceFirst('{count}', '$projectCount')
                            : (l10n?.get('projectsAvailable') ??
                                    '{count} projects available')
                                .replaceFirst('{count}', '$projectCount'),
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
              _CategoryMenu(
                categories: categories,
                selectedCategory: selectedCategory,
                isArabic: isArabic,
                onChanged: onCategoryChanged,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Dropdown filter that switches between all projects and one category.
class _CategoryMenu extends StatelessWidget {
  const _CategoryMenu({
    required this.categories,
    required this.selectedCategory,
    required this.isArabic,
    required this.onChanged,
  });

  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;
  final bool isArabic;
  final ValueChanged<CategoryModel?> onChanged;

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

// Project list card that opens the project details screen.
class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    super.key,
    required this.project,
    required this.categories,
    required this.isArabic,
  });

  final ProjectModel project;
  final List<CategoryModel> categories;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final imageUrl = _projectImageUrl(project);
    final title = project.getLocalizedTitle(isArabic);
    final description = _cardDescription(project, isArabic);
    final categoryName = _categoryName(project, categories, isArabic);

    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      onTap: () {
        Navigator.pushNamed(context, '${AppRoutes.projects}/${project.id}');
      },
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          boxShadow: AppTheme.elevatedShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusCard),
              ),
              child: SizedBox(
                height: 145,
                width: double.infinity,
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? AppNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 145,
                        placeholder: (context) => const _ImagePlaceholder(),
                        errorWidget: (context) => const _ImagePlaceholder(),
                      )
                    : const _ImagePlaceholder(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (categoryName.isNotEmpty) ...[
                      _CategoryBadge(label: categoryName),
                      const SizedBox(height: 10),
                    ],
                    Text(
                      title,
                      style: AppTextStyles.serviceTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    if (description.isNotEmpty)
                      Expanded(
                        child: Text(
                          description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.bodyText.withValues(alpha: 0.78),
                          ),
                        ),
                      )
                    else
                      const Spacer(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n?.get('viewDetails') ?? 'View details',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.buttonLabel.copyWith(
                              color: AppColors.accentBlue,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.accentBlue,
                          size: 18,
                        ),
                      ],
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

  // Builds a compact project description preview for the index card.
  String _cardDescription(ProjectModel project, bool isArabic) {
    final candidates = [
      project.getLocalizedShortDescription(isArabic),
      project.getLocalizedDescription(isArabic),
      project.getLocalizedContent(isArabic),
    ];

    for (final candidate in candidates) {
      final normalized = _plainTextSnippet(candidate);
      if (normalized.isNotEmpty) return normalized;
    }
    return '';
  }

  String _plainTextSnippet(String value) {
    final text = value
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (text.length <= 180) return text;

    final boundary = text.lastIndexOf(' ', 180);
    final end = boundary >= 120 ? boundary : 180;
    return '${text.substring(0, end).trim()}...';
  }

  // Adds an update timestamp query value so changed images refresh in cache.
  String? _projectImageUrl(ProjectModel project) {
    return _withVersion(
      ImageHelper.buildImageUrl(project.image ?? ''),
      project.updatedAt ?? project.createdAt,
    );
  }

  // Resolves the visible category name from available project/category data.
  String _categoryName(
    ProjectModel project,
    List<CategoryModel> allCategories,
    bool isArabic,
  ) {
    final categoryId = project.categoryId;
    if (categoryId != null) {
      for (final category in allCategories) {
        if (category.id == categoryId) {
          return category.getLocalizedName(isArabic);
        }
      }
    }
    if (project.category != null) {
      return project.category!.getLocalizedName(isArabic);
    }
    final projectCategories = project.categories;
    if (projectCategories != null && projectCategories.isNotEmpty) {
      return projectCategories.first.getLocalizedName(isArabic);
    }
    return '';
  }

  // Cache-busting helper used for project images.
  String? _withVersion(String? url, String? version) {
    if (url == null || url.isEmpty || version == null || version.isEmpty) {
      return url;
    }
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}v=${Uri.encodeComponent(version)}';
  }
}

// Small category label displayed on project cards.
class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: constraints.maxWidth),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.accentBlue,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Placeholder shown when a project has no image or image loading fails.
class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.accentBlue.withValues(alpha: 0.08),
      child: const Center(
        child: Icon(
          Icons.folder_open_rounded,
          size: 46,
          color: AppColors.accentBlue,
        ),
      ),
    );
  }
}

// Empty state shown when there are no projects to display.
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
            Icons.folder_open_rounded,
            size: 64,
            color: AppColors.accentBlue,
          ),
          const SizedBox(height: 16),
          Text(
            l10n?.get('noProjectsYet') ?? 'No projects yet',
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

// Error state with retry action for failed project loading.
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
