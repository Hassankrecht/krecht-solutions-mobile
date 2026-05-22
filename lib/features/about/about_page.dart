import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';

// Static company information screen.
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: Text(
          l10n?.aboutUs ?? 'About Us',
          style: const TextStyle(
            color: AppColors.contrast,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildContent(context),
    );
  }

  // Builds the page content as reusable title/body sections.
  Widget _buildContent(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: l10n?.get('aboutKrechtSolutions') ??
                'About Krecht Solutions',
            content: l10n?.get('aboutCompanyBody') ??
                'Krecht Solutions is a leading technology company specializing in innovative digital solutions. We provide cutting-edge web development, mobile applications, and cloud services to help businesses transform and grow in the digital age.',
          ),
          const SizedBox(height: 24),
          _Section(
            title: l10n?.get('ourMission') ?? 'Our Mission',
            content: l10n?.get('ourMissionBody') ??
                'To empower businesses with innovative technology solutions that drive growth, efficiency, and success in the digital marketplace.',
          ),
          const SizedBox(height: 24),
          _Section(
            title: l10n?.get('ourServices') ?? 'Our Services',
            content: l10n?.get('ourServicesBody') ??
                'We specialize in web development, mobile app development, cloud solutions, UI/UX design, and digital transformation consulting.',
          ),
        ],
      ),
    );
  }
}

// Reusable about-page block with a heading and bordered text surface.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkNavy,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.bodyText,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
