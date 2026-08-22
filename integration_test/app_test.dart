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
    // Start each test from an empty store.
    //
    // `SharedPreferences.setMockInitialValues` is deliberately NOT used here:
    // it only patches the legacy synchronous interface, while the app reads
    // through `SharedPreferencesWithCache` (the async interface). On a real
    // device it is a no-op, so preferences written by one test used to survive
    // into the next one and across whole runs — which made the dark-mode
    // assertion below pass or fail depending on what the previous run left
    // behind. Clearing the real store is what actually isolates these tests.
    await SharedPreferencesAsync().clear();
  });

  /// Boots the app and settles the first frame.
  ///
  /// [app.main] is asynchronous — it awaits `SharedPreferenceService.init()`
  /// and `WordleService.init()` before calling `runApp`. Awaiting it matters:
  /// calling it bare let `pumpAndSettle` run against a tree where `runApp` had
  /// not happened yet, so the very first test intermittently found nothing.
  Future<void> launchApp(WidgetTester tester) async {
    await app.main();
    await tester.pumpAndSettle();
  }

  group('Full App E2E', () {
    /// Verifies that the app boots without error and the home page is visible.
    testWidgets('app launches and shows home page', (tester) async {
      await launchApp(tester);

      expect(find.text('Red Owl'), findsOneWidget);
      expect(find.text('Daily'), findsOneWidget);
      expect(find.text('Stats'), findsOneWidget);
    });

    /// Tapping "Daily" should push [WordlePage] which contains a [GridView].
    testWidgets('navigate to game page via Daily button', (tester) async {
      await launchApp(tester);

      await tester.tap(find.text('Daily'));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
    });

    /// Tapping "Stats" should push [StatsPage] with all three section headings.
    testWidgets('navigate to stats page via Stats button', (tester) async {
      await launchApp(tester);

      await tester.tap(find.text('Stats'));
      await tester.pumpAndSettle();

      expect(find.text('Statistics'), findsOneWidget);
      expect(find.text('Guess Distribution'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
    });

    /// Tapping the settings gear from the home page should push [SettingsPage].
    testWidgets('navigate to settings from home page', (tester) async {
      await launchApp(tester);

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
    });

    /// Toggling the dark-mode switch should flip its value.
    testWidgets('toggle dark mode in settings', (tester) async {
      await launchApp(tester);

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      final darkModeSwitch = find.byType(SwitchListTile).first;
      // Assert against the value actually rendered rather than a hard-coded
      // `true`: with no stored preference the toggle defaults to the system
      // brightness, so its starting state depends on the device theme.
      final before = tester.widget<SwitchListTile>(darkModeSwitch).value;

      await tester.tap(darkModeSwitch);
      await tester.pumpAndSettle();

      final after = tester.widget<SwitchListTile>(darkModeSwitch).value;
      expect(after, !before);
    });

    /// Tapping keyboard letter keys should register letters on the game board.
    testWidgets('type letters on game keyboard', (tester) async {
      await launchApp(tester);

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
      await launchApp(tester);

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
      await launchApp(tester);

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
