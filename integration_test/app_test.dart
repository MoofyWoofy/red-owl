import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:red_owl/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('Full App E2E', () {
    testWidgets('app launches and shows home page', (tester) async {
      SharedPreferences.setMockInitialValues({});
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Red Owl'), findsOneWidget);
      expect(find.text('Daily'), findsOneWidget);
      expect(find.text('Stats'), findsOneWidget);
    });

    testWidgets('navigate to game page via Daily button', (tester) async {
      SharedPreferences.setMockInitialValues({});
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Daily'));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
    });

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

    testWidgets('navigate to settings from home page', (tester) async {
      SharedPreferences.setMockInitialValues({});
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
    });

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

    testWidgets('type letters on game keyboard', (tester) async {
      SharedPreferences.setMockInitialValues({});
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Daily'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('H'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('E'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('L'));
      await tester.pumpAndSettle();

      expect(find.text('H'), findsWidgets);
      expect(find.text('E'), findsWidgets);
      expect(find.text('L'), findsWidgets);
    });

    testWidgets('navigate to game and back to home', (tester) async {
      SharedPreferences.setMockInitialValues({});
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Daily'));
      await tester.pumpAndSettle();

      final navigator = Navigator.of(
        tester.element(find.byType(GridView)),
      );
      navigator.pop();
      await tester.pumpAndSettle();

      expect(find.text('Red Owl'), findsOneWidget);
    });

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
