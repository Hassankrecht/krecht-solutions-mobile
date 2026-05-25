import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/social_links_row.dart';

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
          _LogoHero(),
          const SizedBox(height: 24),
          _Section(
            title:
                l10n?.get('aboutKrechtSolutions') ?? 'About Krecht Solutions',
            content:
                l10n?.get('aboutCompanyBody') ??
                'Krecht Solutions is a leading technology company specializing in innovative digital solutions. We provide cutting-edge web development, mobile applications, and cloud services to help businesses transform and grow in the digital age.',
          ),
          const SizedBox(height: 24),
          _Section(
            title: l10n?.get('ourMission') ?? 'Our Mission',
            content:
                l10n?.get('ourMissionBody') ??
                'To empower businesses with innovative technology solutions that drive growth, efficiency, and success in the digital marketplace.',
          ),
          const SizedBox(height: 24),
          _Section(
            title: l10n?.get('ourServices') ?? 'Our Services',
            content:
                l10n?.get('ourServicesBody') ??
                'We specialize in web development, mobile app development, cloud solutions, UI/UX design, and digital transformation consulting.',
          ),
          const SizedBox(height: 28),
          _SocialSection(),
          const SizedBox(height: 16),
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

// Branded logo hero card shown at the top of the About page.
class _LogoHero extends StatelessWidget {
  const _LogoHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.darkNavy, AppColors.header],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/logo.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.accentBlue.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.auto_awesome_mosaic_rounded,
                  color: AppColors.accentBlue,
                  size: 40,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.logoText.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
              children: const [
                TextSpan(text: 'Krecht'),
                TextSpan(
                  text: ' Solutions',
                  style: TextStyle(
                    color: AppColors.accentBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Digital solutions, built cleanly',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.contrast.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

// Social media links section shown at the bottom of the About page.
class _SocialSection extends StatelessWidget {
  const _SocialSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n?.get('followUs') ?? 'Follow Us',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n?.get('connectWithUs') ?? 'Connect with us on social media',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.bodyTextMuted,
            ),
          ),
          const SizedBox(height: 14),
          const SocialLinksRow(),
        ],
      ),
    );
  }
}
