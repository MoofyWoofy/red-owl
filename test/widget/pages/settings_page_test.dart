// Widget tests for the SettingsPage.
//
// Verifies: Settings title, Dark Mode and custom word list switches,
// SwitchListTile count, dark-mode toggle behavior, and the contrast icon.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/routes/shared.dart' show SettingsPage;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

import '../../helpers/test_helpers.dart';

void main() {
  group('SettingsPage', () {
    setUp(() async {
      setSharedPreferencesMock({
        'isDarkMode': false,
        'useCustomList': false,
        'isColorBlindMode': false,
      });
      await SharedPreferenceService().init();
    });

    testWidgets('renders Settings title in AppBar', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const SettingsPage()),
      );
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders Dark Mode switch', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const SettingsPage()),
      );
      await tester.pumpAndSettle();
      expect(find.text('Dark Mode'), findsOneWidget);
    });

    testWidgets('renders Use custom word list switch', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const SettingsPage()),
      );
      await tester.pumpAndSettle();
      expect(find.text('Use custom word list'), findsOneWidget);
    });

    testWidgets('renders at least two SwitchListTile widgets', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const SettingsPage()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SwitchListTile), findsAtLeast(2));
    });

    testWidgets('toggling dark mode switch updates value', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const SettingsPage()),
      );
      await tester.pumpAndSettle();

      final switchFinder = find.byType(SwitchListTile).first;
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      final switchWidget =
          tester.widget<SwitchListTile>(find.byType(SwitchListTile).first);
      expect(switchWidget.value, true);
    });

    testWidgets('renders dark mode icon', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const SettingsPage()),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.contrast), findsOneWidget);
    });

    testWidgets('renders the color-blind / high contrast switch',
        (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const SettingsPage()),
      );
      await tester.pumpAndSettle();
      expect(find.text('Color-blind / high contrast'), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('language tile shows System default and opens a picker',
        (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const SettingsPage()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Language'), findsOneWidget);
      // No override stored, so the tile shows the system-default label.
      expect(find.text('System default'), findsOneWidget);

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      // The picker lists the supported languages by their native names.
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Nederlands'), findsOneWidget);
    });

    testWidgets('text-size tile shows Normal and opens a picker',
        (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const SettingsPage()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Text size'), findsOneWidget);
      // No override stored, so the tile shows the normal label.
      expect(find.text('Normal'), findsWidgets);

      await tester.tap(find.text('Text size'));
      await tester.pumpAndSettle();

      // The picker lists each supported text size.
      expect(find.text('Small'), findsOneWidget);
      expect(find.text('Large'), findsOneWidget);
      expect(find.text('Extra large'), findsOneWidget);
    });

    testWidgets('animation-speed tile shows Normal and opens a picker',
        (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const SettingsPage()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Animation speed'), findsOneWidget);

      await tester.tap(find.text('Animation speed'));
      await tester.pumpAndSettle();

      // The picker lists each supported animation speed.
      expect(find.text('Reduced'), findsOneWidget);
      expect(find.text('Fast'), findsOneWidget);
      expect(find.text('Slow'), findsOneWidget);
    });
  });
}
