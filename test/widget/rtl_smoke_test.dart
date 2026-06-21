// Smoke tests that the main screens build without overflow or error when the
// UI is laid out right-to-left (e.g. for a future RTL locale).
//
// RTL is forced via the MaterialApp `builder`, which wraps all page content in
// a right-to-left Directionality. A successful build (no overflow exception
// during pump) plus the expected content proves the layout survives mirroring.
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show lightTheme;
import 'package:red_owl/database/database.dart';
import 'package:red_owl/l10n/app_localizations.dart';
import 'package:red_owl/main.dart' show HomePage;
import 'package:red_owl/routes/shared.dart'
    show SettingsPage, StatsPage, WordlePage, PracticePage;
import 'package:red_owl/util/shared.dart'
    show SharedPreferenceService, WordleService;

import '../helpers/test_helpers.dart';

const _testWords = ['apple', 'berry', 'chair', 'dwarf'];

/// Builds the app with all page content forced to a right-to-left layout.
Widget makeRtlApp(Widget child) => ProviderScope(
      child: MaterialApp(
        theme: lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        builder: (context, c) =>
            Directionality(textDirection: TextDirection.rtl, child: c!),
        home: child,
      ),
    );

void main() {
  setUp(() async {
    setSharedPreferencesMock({'isDarkMode': false});
    await SharedPreferenceService().init();
    await installFakePathProvider();
    setAssetBundleMock(_testWords);
    AppDatabase.setSingleton(AppDatabase.forTesting(NativeDatabase.memory()));
    await WordleService().init();
  });

  tearDown(() async {
    await AppDatabase().close();
    AppDatabase.resetSingleton();
    setAssetBundleMock(null);
  });

  Future<void> pumpRtl(WidgetTester tester, Widget page) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(makeRtlApp(page));
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('HomePage builds in RTL', (tester) async {
    // HomePage shows the Logo image; drop the word-list asset mock so the real
    // bundle can serve the asset manifest.
    setAssetBundleMock(null);
    await pumpRtl(tester, const HomePage(title: 'Red Owl'));
    expect(find.text('Daily'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
  });

  testWidgets('WordlePage builds in RTL', (tester) async {
    await pumpRtl(tester, const WordlePage());
    // The hint action proves the app bar built under RTL.
    expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
  });

  testWidgets('PracticePage builds in RTL', (tester) async {
    await pumpRtl(tester, const PracticePage());
    expect(find.text('Practice'), findsOneWidget);
  });

  testWidgets('SettingsPage builds in RTL', (tester) async {
    await pumpRtl(tester, const SettingsPage());
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('StatsPage builds in RTL', (tester) async {
    await pumpRtl(tester, const StatsPage());
    expect(find.text('Statistics'), findsOneWidget);
  });
}
