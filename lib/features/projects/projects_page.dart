import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/image_helper.dart';
import '../../core/widgets/app_network_image.dart';
import '../../models/project_model.dart';
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
      context.read<ProjectsProvider>().fetchProjects(refresh: true);
      context.read<ProjectsProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: const Text(
          'Projects',
          style: TextStyle(
            color: AppColors.contrast,
            fontWeight: FontWeight.bold,
          ),
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
          return CustomScrollView(
            slivers: [
              if (provider.categories.isNotEmpty)
                SliverToBoxAdapter(
                  child: _CategoryFilter(
                    categories: provider.categories,
                    selectedCategory: provider.selectedCategory,
                    onCategorySelected: (category) {
                      provider.selectCategory(category);
                    },
                    onClearCategory: () {
                      provider.clearCategory();
                    },
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    childAspectRatio: 0.52,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final project = projects[index];
                    return _ProjectCard(project: project);
                  }, childCount: projects.length),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onClearCategory,
  });

  final List categories;
  final dynamic selectedCategory;
  final Function(dynamic) onCategorySelected;
  final VoidCallback onClearCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _CategoryChip(
            label: 'All',
            isSelected: selectedCategory == null,
            onTap: onClearCategory,
          ),
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _CategoryChip(
                label: category.name,
                isSelected: selectedCategory?.id == category.id,
                onTap: () => onCategorySelected(category),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});
  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final imageUrl = project.image;
    final title = project.title;
    final description = project.shortDescription ?? project.description ?? '';
    final categories = project.categories;
    final category = project.category;
    final categoryName = categories != null && categories.isNotEmpty
        ? categories.first.name
        : (category?.name ?? '');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 130,
            width: double.infinity,
            child: imageUrl != null && imageUrl.isNotEmpty
                ? AppNetworkImage(
                    imageUrl: ImageHelper.buildImageUrl(imageUrl) ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context) => const _ImagePlaceholder(),
                    errorWidget: (context) => const _ImagePlaceholder(),
                  )
                : const _ImagePlaceholder(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (categoryName.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    title,
                    style: AppTextStyles.serviceTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkNavy,
                        foregroundColor: AppColors.contrast,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '${AppRoutes.projects}/${project.id}',
                        );
                      },
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppColors.accentBlue.withValues(alpha: 0.08),
      child: const Icon(
        Icons.folder_open_rounded,
        size: 48,
        color: AppColors.accentBlue,
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
