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
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 360,
                            childAspectRatio: 0.95,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final project = projects[index];
                        return _ProjectCard(
                          key: ValueKey('project-${project.id}'),
                          project: project,
                          categories: provider.categories,
                          isArabic: isArabic,
                        );
                      }, childCount: projects.length),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Our Work', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 6),
          Text(
            '$projectCount project${projectCount == 1 ? '' : 's'} available',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.bodyTextMuted,
            ),
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
    );
  }
}

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
            const DropdownMenuItem<String>(
              value: allValue,
              child: Row(
                children: [
                  Icon(Icons.grid_view_rounded, size: 18),
                  SizedBox(width: 10),
                  Text('All categories'),
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
    final imageUrl = _projectImageUrl(project);
    final title = project.getLocalizedTitle(isArabic);
    final description = project.getLocalizedShortDescription(isArabic);
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
                    Expanded(
                      child: Text(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.bodyText.withValues(alpha: 0.78),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'View details',
                          style: AppTextStyles.buttonLabel.copyWith(
                            color: AppColors.accentBlue,
                            letterSpacing: 0,
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

  String? _projectImageUrl(ProjectModel project) {
    return _withVersion(
      ImageHelper.buildImageUrl(project.image ?? ''),
      project.updatedAt ?? project.createdAt,
    );
  }

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

  String? _withVersion(String? url, String? version) {
    if (url == null || url.isEmpty || version == null || version.isEmpty) {
      return url;
    }
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}v=${Uri.encodeComponent(version)}';
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_rounded,
            size: 64,
            color: AppColors.accentBlue,
          ),
          SizedBox(height: 16),
          Text(
            'No projects yet',
            style: TextStyle(
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
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
