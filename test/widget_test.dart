// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
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

  testWidgets('Home layout fits desktop viewport', (WidgetTester tester) async {
    await _pumpAppAtSize(tester, const Size(1440, 900));

    expect(find.byType(App), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home layout fits mobile viewport', (WidgetTester tester) async {
    await _pumpAppAtSize(tester, const Size(390, 844));

    expect(find.byType(App), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home layout fits narrow web viewport', (
    WidgetTester tester,
  ) async {
    await _pumpAppAtSize(tester, const Size(320, 720));

    expect(find.byType(App), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpAppAtSize(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider<ProjectsProvider>(
          create: (_) => _NoopProjectsProvider(),
        ),
        ChangeNotifierProvider<ServicesProvider>(
          create: (_) => _NoopServicesProvider(),
        ),
        ChangeNotifierProvider<PricingProvider>(
          create: (_) => _NoopPricingProvider(),
        ),
      ],
      child: const App(),
    ),
  );

  await tester.pump();
  await tester.pump(const Duration(milliseconds: 800));
}

class _NoopServicesProvider extends ServicesProvider {
  @override
  Future<void> fetchServices() async {}
}

class _NoopProjectsProvider extends ProjectsProvider {
  @override
  Future<void> fetchProjects({bool refresh = false}) async {}
}

class _NoopPricingProvider extends PricingProvider {
  @override
  Future<void> init() async {}
}
