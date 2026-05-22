import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../providers/settings_provider.dart';

// Displays local static security information.
class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isArabic = context.watch<LanguageProvider>().isArabic;
    final content = context.watch<SettingsProvider>().securityFor(isArabic);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: Text(
          l10n?.security ?? 'Security',
          style: const TextStyle(
            color: AppColors.contrast,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(
          content,
          style: TextStyle(
            fontSize: 15,
            color: theme.colorScheme.onSurface,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}
