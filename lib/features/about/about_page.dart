import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: const Text(
          'About Us',
          style: TextStyle(
            color: AppColors.contrast,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildContent(),
    );
  }

  // Builds the page content as reusable title/body sections.
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: 'About Krecht Solutions',
            content:
                'Krecht Solutions is a leading technology company specializing in innovative digital solutions. We provide cutting-edge web development, mobile applications, and cloud services to help businesses transform and grow in the digital age.',
          ),
          const SizedBox(height: 24),
          _Section(
            title: 'Our Mission',
            content:
                'To empower businesses with innovative technology solutions that drive growth, efficiency, and success in the digital marketplace.',
          ),
          const SizedBox(height: 24),
          _Section(
            title: 'Our Services',
            content:
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
