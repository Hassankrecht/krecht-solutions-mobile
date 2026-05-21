import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/shell/main_shell.dart';
import 'features/about/about_page.dart';
import 'features/contact/contact_page.dart';
import 'features/packages/packages_page.dart';
import 'features/projects/project_details_page.dart';
import 'features/projects/projects_page.dart';
import 'features/services/services_page.dart';
import 'features/settings/privacy_policy_page.dart';
import 'features/settings/terms_page.dart';
import 'features/settings/security_page.dart';
import 'features/settings/data_usage_page.dart';
import 'features/settings/faq_page.dart';
import 'features/settings/maintenance_screen.dart';
import 'providers/language_provider.dart';
import 'providers/settings_provider.dart';
import 'routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final languageProvider = context.watch<LanguageProvider>();

    if (settingsProvider.isInMaintenanceMode) {
      return MaterialApp(
        title: 'Krecht Solutions',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        locale: languageProvider.locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ar')],
        home: Directionality(
          textDirection: languageProvider.textDirection,
          child: const MaintenanceScreen(),
        ),
      );
    }

    return MaterialApp(
      title: 'Krecht Solutions',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      locale: languageProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      initialRoute: AppRoutes.shell,
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('${AppRoutes.projects}/') == true) {
          final projectId = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (_) => ProjectDetailsPage(projectId: projectId),
          );
        }
        return null;
      },
      routes: {
        AppRoutes.shell: (_) => const MainShell(),
        AppRoutes.projects: (_) => const ProjectsPage(),
        AppRoutes.services: (_) => const ServicesPage(),
        AppRoutes.packages: (_) => const PackagesPage(),
        AppRoutes.about: (_) => const AboutPage(),
        AppRoutes.contact: (_) => const ContactPage(),
        AppRoutes.privacyPolicy: (_) => const PrivacyPolicyPage(),
        AppRoutes.terms: (_) => const TermsPage(),
        AppRoutes.security: (_) => const SecurityPage(),
        AppRoutes.dataUsage: (_) => const DataUsagePage(),
        AppRoutes.faq: (_) => const FaqPage(),
      },
      builder: (context, child) {
        return Directionality(
          textDirection: languageProvider.textDirection,
          child: child!,
        );
      },
    );
  }
}
