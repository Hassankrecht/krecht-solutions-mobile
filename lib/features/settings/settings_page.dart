import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/settings_provider.dart';
import '../../routes/app_routes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAppSettings();
    });
  }

  Future<void> _fetchAppSettings() async {
    final settingsProvider = context.read<SettingsProvider>();
    await settingsProvider.fetchAppSettings();
  }

  Future<void> _clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cache cleared successfully')),
      );
    }
  }

  Future<void> _launchWhatsApp(String? number) async {
    if (number == null || number.isEmpty) return;
    final Uri whatsappUri = Uri.parse('https://wa.me/$number');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail(String? email) async {
    if (email == null || email.isEmpty) return;
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final languageProvider = context.watch<LanguageProvider>();
    final appSettings = settingsProvider.appSettings;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: const Text(
          'More',
          style: TextStyle(
            color: AppColors.contrast,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SettingsGroup(
            title: 'App Configuration',
            items: [
              _SettingsTile(
                icon: Icons.language_rounded,
                label: 'Language',
                trailing: Text(
                  languageProvider.isArabic ? 'Arabic' : 'English',
                  style: const TextStyle(
                    color: AppColors.bodyTextMuted,
                    fontSize: 14,
                  ),
                ),
                onTap: () => _showLanguageDialog(languageProvider),
              ),
              _SettingsTile(
                icon: Icons.dark_mode_outlined,
                label: 'Dark Mode',
                trailing: Switch(
                  value: appProvider.isDarkMode,
                  onChanged: (value) {
                    context.read<AppProvider>().toggleDarkMode();
                  },
                  activeThumbColor: AppColors.accentBlue,
                ),
              ),
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                label: 'App Version',
                trailing: Text(
                  appSettings?.appVersion ?? '1.0.0',
                  style: const TextStyle(
                    color: AppColors.bodyTextMuted,
                    fontSize: 14,
                  ),
                ),
              ),
              _SettingsTile(
                icon: Icons.cleaning_services_rounded,
                label: 'Clear Cache',
                onTap: _clearCache,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsGroup(
            title: 'Privacy & Security',
            items: [
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.privacyPolicy);
                },
              ),
              _SettingsTile(
                icon: Icons.gavel_outlined,
                label: 'Terms & Conditions',
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.terms);
                },
              ),
              _SettingsTile(
                icon: Icons.security_outlined,
                label: 'Security',
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.security);
                },
              ),
              _SettingsTile(
                icon: Icons.data_usage_rounded,
                label: 'Data Usage',
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.dataUsage);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsGroup(
            title: 'Support',
            items: [
              _SettingsTile(
                icon: Icons.contact_support_outlined,
                label: 'Contact Support',
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.contact);
                },
              ),
              if (appSettings?.whatsappNumber != null &&
                  appSettings!.whatsappNumber.isNotEmpty)
                _SettingsTile(
                  icon: Icons.message_outlined,
                  label: 'WhatsApp',
                  onTap: () => _launchWhatsApp(appSettings.whatsappNumber),
                ),
              if (appSettings?.contactEmail != null &&
                  appSettings!.contactEmail.isNotEmpty)
                _SettingsTile(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  onTap: () => _launchEmail(appSettings.contactEmail),
                ),
              _SettingsTile(
                icon: Icons.bug_report_outlined,
                label: 'Report Problem',
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.contact);
                },
              ),
              _SettingsTile(
                icon: Icons.help_outline_rounded,
                label: 'FAQ',
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.faq);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsGroup(
            title: 'Social',
            items: [
              if (appSettings?.facebookUrl != null &&
                  appSettings!.facebookUrl!.isNotEmpty)
                _SettingsTile(
                  icon: Icons.facebook,
                  label: 'Facebook',
                  onTap: () => _launchUrl(appSettings.facebookUrl),
                ),
              if (appSettings?.instagramUrl != null &&
                  appSettings!.instagramUrl!.isNotEmpty)
                _SettingsTile(
                  icon: Icons.camera_alt,
                  label: 'Instagram',
                  onTap: () => _launchUrl(appSettings.instagramUrl),
                ),
              if (appSettings?.linkedinUrl != null &&
                  appSettings!.linkedinUrl!.isNotEmpty)
                _SettingsTile(
                  icon: Icons.work,
                  label: 'LinkedIn',
                  onTap: () => _launchUrl(appSettings.linkedinUrl),
                ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsGroup(
            title: 'About',
            items: [
              _SettingsTile(
                icon: Icons.business_outlined,
                label: 'About Krecht Solutions',
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.about);
                },
              ),
              _SettingsTile(
                icon: Icons.code_outlined,
                label: 'Developer Info',
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.about);
                },
              ),
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                label: 'App Version',
                trailing: Text(
                  appSettings?.appVersion ?? '1.0.0',
                  style: const TextStyle(
                    color: AppColors.bodyTextMuted,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showLanguageDialog(LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              trailing: !languageProvider.isArabic
                  ? const Icon(Icons.check, color: AppColors.accentBlue)
                  : null,
              onTap: () {
                languageProvider.setLanguage(AppLanguage.english);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Arabic'),
              trailing: languageProvider.isArabic
                  ? const Icon(Icons.check, color: AppColors.accentBlue)
                  : null,
              onTap: () {
                languageProvider.setLanguage(AppLanguage.arabic);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.items});

  final String title;
  final List<_SettingsTile> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.bodyTextMuted,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
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
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.darkNavy, size: 22),
      title: Text(
        label,
        style: const TextStyle(fontSize: 15, color: AppColors.bodyText),
      ),
      trailing:
          trailing ??
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.bodyTextMuted,
            size: 20,
          ),
      onTap: onTap,
    );
  }
}
