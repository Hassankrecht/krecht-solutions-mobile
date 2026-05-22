import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

// Project details page with gallery, summary metadata, video, and description.
class ProjectDetailsPage extends StatefulWidget {
  const ProjectDetailsPage({super.key, required this.projectId});

  final String projectId;

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  String? _selectedImage;
  int? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectsProvider>().fetchProjectDetails(widget.projectId);
    });
  }

  // Opens external project/video links outside the app.
  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // Resets the selected gallery image when the loaded project changes.
  void _syncSelectedImage(ProjectModel project, List<String> images) {
    if (_selectedProjectId == project.id) return;
    _selectedProjectId = project.id;
    _selectedImage = images.isNotEmpty ? images.first : null;
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
          localizations?.projectDetails ?? 'Project Details',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<ProjectsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.selectedProject == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentBlue),
            );
          }
          if (provider.error != null && provider.selectedProject == null) {
            return _ErrorState(
              message: provider.error!,
              onRetry: () => provider.fetchProjectDetails(widget.projectId),
            );
          }

          final project = provider.selectedProject;
          if (project == null) {
            return const _EmptyState();
          }

          final images = _projectImages(project);
          final imageVersion = project.updatedAt ?? project.createdAt;
          _syncSelectedImage(project, images);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroImage(imagePath: _selectedImage, version: imageVersion),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProjectSummary(
                        project: project,
                        categories: provider.categories,
                        isArabic: isArabic,
                        onLaunchUrl: _launchUrl,
                      ),
                      if (images.length > 1) ...[
                        const SizedBox(height: 20),
                        _GalleryStrip(
                          images: images,
                          selectedImage: _selectedImage,
                          version: imageVersion,
                          onImageSelected: (image) {
                            setState(() => _selectedImage = image);
                          },
                        ),
                      ],
                      if (project.video != null &&
                          project.video!.trim().isNotEmpty) ...[
                        const SizedBox(height: 20),
                        _VideoCard(
                          videoUrl: project.video!.trim(),
                          onPlay: _launchUrl,
                        ),
                      ],
                      const SizedBox(height: 20),
                      if (project.getLocalizedDescription(isArabic).isNotEmpty)
                        _SectionCard(
                          title: 'Description',
                          child: Text(
                            project.getLocalizedDescription(isArabic),
                            style: AppTextStyles.body,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Builds a unique, non-empty image list from main image plus gallery images.
  List<String> _projectImages(ProjectModel project) {
    final images = <String>[
      if (project.image != null && project.image!.trim().isNotEmpty)
        project.image!.trim(),
      ...?project.galleryImages,
    ];
    return images.where((image) => image.trim().isNotEmpty).toSet().toList();
  }
}

// Large main project image at the top of the details page.
class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.imagePath, required this.version});

  final String? imagePath;
  final String? version;

  @override
  Widget build(BuildContext context) {
    final imageUrl = _withVersion(
      ImageHelper.buildImageUrl(imagePath ?? ''),
      version,
    );
    final displaySize = MediaQuery.sizeOf(context);
    final topPadding = MediaQuery.paddingOf(context).top;
    final availableHeight = displaySize.height - topPadding - kToolbarHeight;
    final height = availableHeight.clamp(260.0, 460.0).toDouble();

    return SizedBox(
      width: double.infinity,
      height: height,
      child: imageUrl != null && imageUrl.isNotEmpty
          ? ColoredBox(
              color: AppColors.darkNavy,
              child: ClipRect(
                child: AppNetworkImage(
                  key: ValueKey('project-detail-main-$imageUrl'),
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: height,
                  fit: BoxFit.contain,
                  placeholder: (context) => _LoadingImage(height: height),
                  errorWidget: (context) => _ImagePlaceholder(height: height),
                ),
              ),
            )
          : _ImagePlaceholder(height: height),
    );
  }

  // Adds an update timestamp query value so changed images refresh in cache.
  String? _withVersion(String? url, String? version) {
    if (url == null || url.isEmpty || version == null || version.isEmpty) {
      return url;
    }
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}v=${Uri.encodeComponent(version)}';
  }
}

// Project title, category, short description, metadata, and external CTA.
class _ProjectSummary extends StatelessWidget {
  const _ProjectSummary({
    required this.project,
    required this.categories,
    required this.isArabic,
    required this.onLaunchUrl,
  });

  final ProjectModel project;
  final List<CategoryModel> categories;
  final bool isArabic;
  final ValueChanged<String> onLaunchUrl;

  @override
  Widget build(BuildContext context) {
    final categoryName = _categoryName(project, categories, isArabic);
    final shortDescription = project.getLocalizedShortDescription(isArabic);

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (categoryName.isNotEmpty) ...[
            _CategoryBadge(label: categoryName),
            const SizedBox(height: 12),
          ],
          Text(
            project.getLocalizedTitle(isArabic),
            style: AppTextStyles.cardTitle.copyWith(fontSize: 26),
          ),
          if (shortDescription.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(shortDescription, style: AppTextStyles.bodySmall),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              if (project.client != null && project.client!.isNotEmpty)
                _MetaPill(
                  icon: Icons.business_rounded,
                  label: 'Client',
                  value: project.client!,
                ),
              if (project.status != null && project.status!.isNotEmpty)
                _MetaPill(
                  icon: Icons.task_alt_rounded,
                  label: 'Status',
                  value: project.status!,
                ),
            ],
          ),
          if (project.url != null && project.url!.isNotEmpty) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentBlue,
                  foregroundColor: AppColors.contrast,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => onLaunchUrl(project.url!),
                icon: const Icon(Icons.launch_rounded),
                label: const Text(
                  'View Project',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ],
      ),
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
}

// Horizontal gallery strip for selecting the main project image.
class _GalleryStrip extends StatelessWidget {
  const _GalleryStrip({
    required this.images,
    required this.selectedImage,
    required this.version,
    required this.onImageSelected,
  });

  final List<String> images;
  final String? selectedImage;
  final String? version;
  final ValueChanged<String> onImageSelected;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Gallery',
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: SizedBox(
        height: 94,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final image = images[index];
            final imageUrl = _withVersion(
              ImageHelper.buildImageUrl(image),
              version,
            );
            final isSelected = image == selectedImage;

            return GestureDetector(
              key: ValueKey('gallery-thumb-$imageUrl'),
              onTap: () => onImageSelected(image),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 126,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.accentBlue
                        : AppColors.divider,
                    width: isSelected ? 3 : 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? AppNetworkImage(
                        key: ValueKey('gallery-image-$imageUrl'),
                        imageUrl: imageUrl,
                        width: 126,
                        height: 94,
                        fit: BoxFit.cover,
                        placeholder: (context) =>
                            const _LoadingImage(height: 94),
                        errorWidget: (context) =>
                            const _ImagePlaceholder(height: 94),
                      )
                    : const _ImagePlaceholder(height: 94),
              ),
            );
          },
        ),
      ),
    );
  }

  // Cache-busting helper used for gallery thumbnails.
  String? _withVersion(String? url, String? version) {
    if (url == null || url.isEmpty || version == null || version.isEmpty) {
      return url;
    }
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}v=${Uri.encodeComponent(version)}';
  }
}

// Video preview card that opens the project video externally.
class _VideoCard extends StatelessWidget {
  const _VideoCard({
    required this.videoUrl,
    required this.onPlay,
  });

  final String videoUrl;
  final ValueChanged<String> onPlay;

  @override
  Widget build(BuildContext context) {
    final playableUrl = ImageHelper.buildVideoUrl(videoUrl) ?? videoUrl;
    final thumbnailUrl = _youtubeThumbnail(videoUrl);

    return _SectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text('Project Video', style: AppTextStyles.subheading),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            onTap: () => onPlay(playableUrl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 190,
                      width: double.infinity,
                      child: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                          ? AppNetworkImage(
                              imageUrl: thumbnailUrl,
                              fit: BoxFit.cover,
                              placeholder: (context) =>
                                  const _LoadingImage(height: 190),
                              errorWidget: (context) =>
                                  const _VideoPlaceholder(),
                            )
                          : const _VideoPlaceholder(),
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.contrast,
                        size: 42,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.smart_display_rounded,
                        color: AppColors.accentBlue,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Load project video',
                          style: AppTextStyles.subheading,
                        ),
                      ),
                      const Icon(
                        Icons.open_in_new_rounded,
                        color: AppColors.bodyTextMuted,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Extracts a YouTube video id and returns a thumbnail URL when possible.
  String? _youtubeThumbnail(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    String? id;
    if (uri.host.contains('youtu.be')) {
      id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    } else if (uri.host.contains('youtube.com')) {
      id = uri.queryParameters['v'];
      if (id == null &&
          uri.pathSegments.length >= 2 &&
          uri.pathSegments.first == 'embed') {
        id = uri.pathSegments[1];
      }
    }

    if (id == null || id.isEmpty) return null;
    return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
  }
}

// Reusable white content card for detail sections.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child, this.title, this.padding});

  final Widget child;
  final String? title;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(title!, style: AppTextStyles.subheading),
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

// Compact metadata pill used for project client/status fields.
class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: AppColors.bodyTextMuted),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: AppColors.bodyText),
            ),
          ),
        ],
      ),
    );
  }
}

// Small category label displayed in the project summary.
class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accentBlue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.accentBlue,
        ),
      ),
    );
  }
}

// Loading placeholder for project images.
class _LoadingImage extends StatelessWidget {
  const _LoadingImage({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.lightBackground,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.accentBlue,
        ),
      ),
    );
  }
}

// Placeholder shown when a project image is missing or fails to load.
class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.accentBlue.withValues(alpha: 0.08),
      child: const Icon(
        Icons.folder_open_rounded,
        size: 56,
        color: AppColors.accentBlue,
      ),
    );
  }
}

// Placeholder shown when no video thumbnail can be resolved.
class _VideoPlaceholder extends StatelessWidget {
  const _VideoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.darkNavy,
      child: Center(
        child: Icon(
          Icons.smart_display_rounded,
          color: AppColors.contrast.withValues(alpha: 0.72),
          size: 58,
        ),
      ),
    );
  }
}

// Empty state shown when a project id does not resolve to data.
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
            'Project not found',
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

// Error state with retry action for failed detail loading.
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
