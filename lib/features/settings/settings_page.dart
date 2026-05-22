import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/settings_provider.dart';
import '../../routes/app_routes.dart';

// Settings and support hub for app preferences, policy pages, and contact links.
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

  // Refreshes app settings so contact links and version data stay current.
  Future<void> _fetchAppSettings() async {
    final settingsProvider = context.read<SettingsProvider>();
    await settingsProvider.fetchAppSettings();
  }

  // Clears locally cached preferences and shows feedback to the user.
  Future<void> _clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cache cleared successfully')),
      );
    }
  }

  // Opens WhatsApp support when a configured phone number exists.
  Future<void> _launchWhatsApp(String? number) async {
    if (number == null || number.isEmpty) return;
    final Uri whatsappUri = Uri.parse('https://wa.me/${_digitsOnly(number)}');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchPhone(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  // Opens the default email client for the configured support address.
  Future<void> _launchEmail(String? email) async {
    if (email == null || email.isEmpty) return;
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  // Opens configured social or website links outside the app.
  Future<void> _launchUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _digitsOnly(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appProvider = context.watch<AppProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final languageProvider = context.watch<LanguageProvider>();
    final appSettings = settingsProvider.appSettings;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.bodyTextMuted,
                    fontSize: 14,
                  ),
                ),
                onTap: () => _showLanguageDialog(languageProvider),
              ),
              _SettingsTile(
                icon: Icons.brightness_auto_outlined,
                label: 'Theme',
                trailing: Text(
                  appProvider.themeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.bodyTextMuted,
                    fontSize: 14,
                  ),
                ),
                onTap: () => _showThemeDialog(appProvider),
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
                  icon: Icons.chat_outlined,
                  label: 'WhatsApp',
                  onTap: () => _launchWhatsApp(appSettings.whatsappNumber),
                ),
              if (appSettings?.contactPhone != null &&
                  appSettings!.contactPhone.isNotEmpty)
                _SettingsTile(
                  icon: Icons.call_outlined,
                  label: 'Call',
                  onTap: () => _launchPhone(appSettings.contactPhone),
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
                icon: Icons.info_outline_rounded,
                label: 'App Version',
                trailing: Text(
                  appSettings?.appVersion ?? '1.0.0',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.bodyTextMuted,
                    fontSize: 14,
                  ),
                ),
              ),
              _SettingsTile(
                icon: Icons.code_outlined,
                label: 'Developed by Krecht Solutions',
                trailing: const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Shows the language picker and writes the selected language to the provider.
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

  void _showThemeDialog(AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOptionTile(
              title: 'Auto',
              subtitle: 'Use phone settings',
              selected:
                  appProvider.themePreference == AppThemePreference.system,
              onTap: () {
                appProvider.setThemePreference(AppThemePreference.system);
                Navigator.of(context).pop();
              },
            ),
            _ThemeOptionTile(
              title: 'Light',
              subtitle: 'Always use light mode',
              selected: appProvider.themePreference == AppThemePreference.light,
              onTap: () {
                appProvider.setThemePreference(AppThemePreference.light);
                Navigator.of(context).pop();
              },
            ),
            _ThemeOptionTile(
              title: 'Dark',
              subtitle: 'Always use dark mode',
              selected: appProvider.themePreference == AppThemePreference.dark,
              onTap: () {
                appProvider.setThemePreference(AppThemePreference.dark);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: selected
          ? const Icon(Icons.check, color: AppColors.accentBlue)
          : null,
      onTap: onTap,
    );
  }
}

// Visual group wrapper for related settings rows.
class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.items});

  final String title;
  final List<_SettingsTile> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            color: colorScheme.surface,
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

// One tappable row in the settings screen.
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
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final trailingMaxWidth = (constraints.maxWidth * 0.35)
            .clamp(56.0, 140.0)
            .toDouble();

        return ListTile(
          leading: Icon(icon, color: colorScheme.primary, size: 22),
          title: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
          ),
          trailing: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: trailingMaxWidth),
            child:
                trailing ??
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.bodyTextMuted,
                  size: 20,
                ),
          ),
          onTap: onTap,
        );
      },
    );
  }
}
