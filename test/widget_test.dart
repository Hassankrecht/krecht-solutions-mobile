// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:solutions_app/app.dart';
import 'package:solutions_app/providers/app_provider.dart';
import 'package:solutions_app/providers/language_provider.dart';
import 'package:solutions_app/providers/settings_provider.dart';
import 'package:solutions_app/providers/projects_provider.dart';
import 'package:solutions_app/providers/services_provider.dart';
import 'package:solutions_app/providers/pricing_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => ProjectsProvider()),
          ChangeNotifierProvider(create: (_) => ServicesProvider()),
          ChangeNotifierProvider(create: (_) => PricingProvider()),
        ],
        child: const App(),
      ),
    );

    // Verify that the app loads without errors
    expect(find.byType(App), findsOneWidget);
  });
}
