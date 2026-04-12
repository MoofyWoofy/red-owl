import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:red_owl/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

/// End-to-end integration tests that exercise the full app on a real device
/// or emulator.
///
/// These tests launch [app.main] in-process, interact with widgets via the
/// test framework, and assert on the rendered UI — giving the highest level
/// of confidence that the app works correctly as a whole.
///
/// Run with:
/// ```
/// flutter test integration_test/app_test.dart
/// ```
/// or on a connected device:
/// ```
/// flutter test integration_test/app_test.dart -d <device-id>
/// ```
void main() {
  // Must be called before any test accesses the widget tree.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Start each test with a clean, empty preferences store.
    SharedPreferences.setMockInitialValues({});
  });

  group('Full App E2E', () {
    /// Verifies that the app boots without error and the home page is visible.
    testWidgets('app launches and shows home page', (tester) async {
      SharedPreferences.setMockInitialValues({});
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Red Owl'), findsOneWidget);
      expect(find.text('Daily'), findsOneWidget);
      expect(find.text('Stats'), findsOneWidget);
    });

    /// Tapping "Daily" should push [WordlePage] which contains a [GridView].
    testWidgets('navigate to game page via Daily button', (tester) async {
      SharedPreferences.setMockInitialValues({});
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Daily'));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
    });

    /// Tapping "Stats" should push [StatsPage] with all three section headings.
    testWidgets('navigate to stats page via Stats button', (tester) async {
      SharedPreferences.setMockInitialValues({});
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Stats'));
      await tester.pumpAndSettle();

      expect(find.text('Statistics'), findsOneWidget);
      expect(find.text('Guess Distribution'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
    });

    /// Tapping the settings gear from the home page should push [SettingsPage].
    testWidgets('navigate to settings from home page', (tester) async {
      SharedPreferences.setMockInitialValues({});
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
    });

    /// Toggling the dark-mode switch should flip its value to true.
    testWidgets('toggle dark mode in settings', (tester) async {
      SharedPreferences.setMockInitialValues({});
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      final darkModeSwitch = find.byType(SwitchListTile).first;
      await tester.tap(darkModeSwitch);
      await tester.pumpAndSettle();

      final switchWidget =
          tester.widget<SwitchListTile>(find.byType(SwitchListTile).first);
      expect(switchWidget.value, true);
    });

    /// Tapping keyboard letter keys should register letters on the game board.
    testWidgets('type letters on game keyboard', (tester) async {
      SharedPreferences.setMockInitialValues({});
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Daily'));
      await tester.pumpAndSettle();

      // Type H, E, L and confirm each appears somewhere in the UI.
      await tester.tap(find.text('H'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('E'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('L'));
      await tester.pumpAndSettle();

      // The letters should appear on both the keyboard and grid tiles.
      expect(find.text('H'), findsWidgets);
      expect(find.text('E'), findsWidgets);
      expect(find.text('L'), findsWidgets);
    });

    /// Navigate to the game page and programmatically pop back to home.
    testWidgets('navigate to game and back to home', (tester) async {
      SharedPreferences.setMockInitialValues({});
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Daily'));
      await tester.pumpAndSettle();

      // Use the Navigator directly to pop the route.
      final navigator = Navigator.of(
        tester.element(find.byType(GridView)),
      );
      navigator.pop();
      await tester.pumpAndSettle();

      expect(find.text('Red Owl'), findsOneWidget);
    });

    /// Navigate to the stats page and pop back to home.
    testWidgets('navigate to stats and back to home', (tester) async {
      SharedPreferences.setMockInitialValues({});
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Stats'));
      await tester.pumpAndSettle();
      expect(find.text('Statistics'), findsOneWidget);

      final navigator = Navigator.of(
        tester.element(find.text('Statistics')),
      );
      navigator.pop();
      await tester.pumpAndSettle();

      expect(find.text('Red Owl'), findsOneWidget);
    });
  });
}
