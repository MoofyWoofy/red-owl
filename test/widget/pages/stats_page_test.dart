// Widget tests for the StatsPage.
//
// Uses pump(Duration) instead of pumpAndSettle because fl_chart bar chart
// animations run indefinitely and would cause a timeout.
// Uses a 1080×1920 viewport so the full page fits without overflow.
//
// Verifies: Statistics/Guess Distribution/History headings, share/help/settings
// icons, zero-stats state, stats seeded from SharedPreferences, and help dialog.
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/database/database.dart';
import 'package:red_owl/routes/shared.dart' show StatsPage;
import 'package:red_owl/util/shared.dart'
    show SharedPreferenceService, getDateOnly;

import '../../helpers/test_helpers.dart';

void main() {
  group('StatsPage', () {
    setUp(() async {
      setSharedPreferencesMock({
        'isDarkMode': false,
      });
      await SharedPreferenceService().init();
    });

    Future<void> pumpStatsPage(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(
        makeTestAppRaw(child: const StatsPage()),
      );
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('renders Statistics heading', (tester) async {
      await pumpStatsPage(tester);
      expect(find.text('Statistics'), findsOneWidget);
    });

    testWidgets('renders Guess Distribution heading', (tester) async {
      await pumpStatsPage(tester);
      expect(find.text('Guess Distribution'), findsOneWidget);
    });

    testWidgets('renders History heading', (tester) async {
      await pumpStatsPage(tester);
      expect(find.text('History'), findsOneWidget);
    });

    testWidgets('renders share icon in AppBar', (tester) async {
      await pumpStatsPage(tester);
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('renders help icon in AppBar', (tester) async {
      await pumpStatsPage(tester);
      expect(find.byIcon(Icons.help), findsOneWidget);
    });

    testWidgets('renders settings icon in AppBar', (tester) async {
      await pumpStatsPage(tester);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('shows zero stats when no data exists', (tester) async {
      await pumpStatsPage(tester);
      expect(find.text('0'), findsWidgets);
    });

    testWidgets('renders stats from SharedPreferences', (tester) async {
      setSharedPreferencesMock({
        'isDarkMode': false,
        'statsData': ['10', '7', '3', '5'],
        'guessDistribution': ['1', '2', '3', '1', '0', '0'],
      });
      await SharedPreferenceService().init();
      await pumpStatsPage(tester);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('70'), findsOneWidget);
    });

    testWidgets('renders the wins count and average guesses', (tester) async {
      setSharedPreferencesMock({
        'isDarkMode': false,
        'statsData': ['10', '7', '3', '5'],
        // 1+2+3+1 = 7 wins; (1·1 + 2·2 + 3·3 + 1·4) / 7 = 18/7 = 2.6.
        'guessDistribution': ['1', '2', '3', '1', '0', '0'],
      });
      await SharedPreferenceService().init();
      await pumpStatsPage(tester);
      expect(find.text('Wins'), findsOneWidget);
      expect(find.text('Avg guesses'), findsOneWidget);
      // Wins value (7) and the computed average.
      expect(find.text('7'), findsWidgets);
      expect(find.text('2.6'), findsOneWidget);
    });

    testWidgets('help dialog opens on help tap', (tester) async {
      await pumpStatsPage(tester);
      await tester.tap(find.byIcon(Icons.help));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('reset clears stats and history after confirmation',
        (tester) async {
      setSharedPreferencesMock({
        'isDarkMode': false,
        'statsData': ['10', '7', '3', '5'],
        'guessDistribution': ['1', '2', '3', '1', '0', '0'],
      });
      await SharedPreferenceService().init();
      AppDatabase.setSingleton(
          AppDatabase.forTesting(NativeDatabase.memory()));
      final db = AppDatabase();
      await db.into(db.history).insert(HistoryCompanion.insert(
            word: 'APPLE',
            date: getDateOnly(DateTime.now()),
            gameState: GameState.won.name,
          ));
      addTearDown(() async {
        await AppDatabase().close();
        AppDatabase.resetSingleton();
      });

      await pumpStatsPage(tester);
      expect(find.text('10'), findsOneWidget);

      // Open the reset dialog and confirm.
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('Yes'));
      await tester.pump(const Duration(seconds: 1));

      // Stats are now cleared, and the history rows are gone.
      expect(find.text('10'), findsNothing);
      expect(
        SharedPreferenceService()
            .getStringList(SharedPreferencesKeys.statsData),
        isNull,
      );
      final rows = await AppDatabase().select(AppDatabase().history).get();
      expect(rows, isEmpty);
    });
  });
}
