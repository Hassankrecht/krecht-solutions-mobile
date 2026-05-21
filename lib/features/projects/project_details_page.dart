import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/image_helper.dart';
import '../../core/widgets/app_network_image.dart';
import '../../providers/projects_provider.dart';

class ProjectDetailsPage extends StatefulWidget {
  const ProjectDetailsPage({super.key, required this.projectId});
  final String projectId;

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectsProvider>().fetchProjectDetails(widget.projectId);
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: const Text(
          'Project Details',
          style: TextStyle(
            color: AppColors.contrast,
            fontWeight: FontWeight.bold,
          ),
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
          final categories = project.categories;
          final categoryName = categories != null && categories.isNotEmpty
              ? categories.first.name
              : (project.category?.name ?? '');
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (project.image != null && project.image!.isNotEmpty)
                  ClipRRect(
                    child: AppNetworkImage(
                      imageUrl: ImageHelper.buildImageUrl(project.image!) ?? '',
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      placeholder: (context) => Container(
                        width: double.infinity,
                        height: 250,
                        color: AppColors.lightBackground,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.accentBlue,
                          ),
                        ),
                      ),
                      errorWidget: (context) => const _ImagePlaceholder(),
                    ),
                  )
                else
                  const _ImagePlaceholder(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (categoryName.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentBlue.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            categoryName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Text(project.title, style: AppTextStyles.cardTitle),
                      const SizedBox(height: 16),
                      if (project.client != null) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.business_rounded,
                              size: 18,
                              color: AppColors.bodyTextMuted,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Client: ${project.client}',
                                style: AppTextStyles.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (project.description != null) ...[
                        Text('Description', style: AppTextStyles.subheading),
                        const SizedBox(height: 8),
                        Text(project.description!, style: AppTextStyles.body),
                        const SizedBox(height: 20),
                      ],
                      if (project.galleryImages != null &&
                          project.galleryImages!.isNotEmpty) ...[
                        Text('Gallery', style: AppTextStyles.subheading),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: project.galleryImages!.length,
                            itemBuilder: (context, index) {
                              final imageUrl = ImageHelper.buildImageUrl(
                                project.galleryImages![index],
                              );
                              return Padding(
                                padding: EdgeInsets.only(
                                  right:
                                      index == project.galleryImages!.length - 1
                                      ? 0
                                      : 12,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: AppNetworkImage(
                                    imageUrl: imageUrl ?? '',
                                    width: 160,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    placeholder: (context) => Container(
                                      width: 160,
                                      height: 120,
                                      color: AppColors.lightBackground,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.accentBlue,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context) => Container(
                                          width: 160,
                                          height: 120,
                                          color: AppColors.accentBlue
                                              .withValues(alpha: 0.08),
                                          child: const Icon(
                                            Icons.broken_image_rounded,
                                            color: AppColors.accentBlue,
                                          ),
                                        ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      if (project.url != null && project.url!.isNotEmpty) ...[
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
                            onPressed: () => _launchUrl(project.url!),
                            icon: const Icon(Icons.launch_rounded),
                            label: const Text(
                              'View Project',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      color: AppColors.accentBlue.withValues(alpha: 0.08),
      child: const Icon(
        Icons.folder_open_rounded,
        size: 64,
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
