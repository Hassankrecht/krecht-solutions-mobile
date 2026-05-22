import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';

// Static privacy/data explanation page shown from Settings.
class DataUsagePage extends StatelessWidget {
  const DataUsagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: Text(
          l10n?.dataUsage ?? 'Data Usage',
          style: const TextStyle(
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
              l10n?.get('dataUsageInformation') ?? 'Data Usage Information',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkNavy,
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: l10n?.get('dataCollection') ?? 'Data Collection',
              content: l10n?.get('dataCollectionBody') ??
                  'We collect data to improve your experience. This includes usage patterns, crash reports, and performance metrics.',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: l10n?.get('dataStorage') ?? 'Data Storage',
              content: l10n?.get('dataStorageBody') ??
                  'Your data is stored securely on our servers. We use industry-standard encryption to protect your information.',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: l10n?.get('dataSharing') ?? 'Data Sharing',
              content: l10n?.get('dataSharingBody') ??
                  'We do not sell your personal data to third parties. Your information is only shared with your consent or as required by law.',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: l10n?.get('yourRights') ?? 'Your Rights',
              content: l10n?.get('yourRightsBody') ??
                  'You have the right to access, correct, or delete your personal data at any time through your account settings.',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: l10n?.get('cookies') ?? 'Cookies',
              content: l10n?.get('cookiesBody') ??
                  'We use cookies to enhance your browsing experience. You can manage cookie preferences in your browser settings.',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: l10n?.get('offlineData') ?? 'Offline Data',
              content: l10n?.get('offlineDataBody') ??
                  'The app may store some data locally on your device for offline access. This data is encrypted and protected.',
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable policy section card for title and body content.
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
