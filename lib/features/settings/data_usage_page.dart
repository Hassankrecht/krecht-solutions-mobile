import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class DataUsagePage extends StatelessWidget {
  const DataUsagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: const Text(
          'Data Usage',
          style: TextStyle(
            color: AppColors.contrast,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Usage Information',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkNavy,
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Data Collection',
              content: 'We collect data to improve your experience. This includes usage patterns, crash reports, and performance metrics.',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Data Storage',
              content: 'Your data is stored securely on our servers. We use industry-standard encryption to protect your information.',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Data Sharing',
              content: 'We do not sell your personal data to third parties. Your information is only shared with your consent or as required by law.',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Your Rights',
              content: 'You have the right to access, correct, or delete your personal data at any time through your account settings.',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Cookies',
              content: 'We use cookies to enhance your browsing experience. You can manage cookie preferences in your browser settings.',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Offline Data',
              content: 'The app may store some data locally on your device for offline access. This data is encrypted and protected.',
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.bodyText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
