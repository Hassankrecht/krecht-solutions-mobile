import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/app_provider.dart';
import 'providers/language_provider.dart';
import 'providers/projects_provider.dart';
import 'providers/services_provider.dart';
import 'providers/pricing_provider.dart';
import 'providers/settings_provider.dart';

// Application entry point. Sets up global providers before rendering the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Providers created here are shared across the whole widget tree.
  final appProvider = AppProvider();
  await appProvider.loadThemePreference();
  final settingsProvider = SettingsProvider();
  // Fetch settings but don't block app startup on failure
  settingsProvider.fetchAppSettings().catchError((_) {});

  final languageProvider = LanguageProvider();

  runApp(
    // MultiProvider exposes app state such as language, settings, projects,
    // services, and pricing data to every screen.
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appProvider),
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider(create: (_) => ProjectsProvider()),
        ChangeNotifierProvider(create: (_) => ServicesProvider()),
        ChangeNotifierProvider(create: (_) => PricingProvider()),
      ],
      child: const App(),
    ),
  );
}
