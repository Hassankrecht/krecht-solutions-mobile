import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/app_provider.dart';
import 'providers/language_provider.dart';
import 'providers/projects_provider.dart';
import 'providers/services_provider.dart';
import 'providers/pricing_provider.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appProvider = AppProvider();
  final settingsProvider = SettingsProvider();
  // Fetch settings but don't block app startup on failure
  settingsProvider.fetchAppSettings().catchError((_) {});

  final languageProvider = LanguageProvider();

  runApp(
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
