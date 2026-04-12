import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/widgets/shared.dart' show HelpIconButton;

import '../../helpers/test_helpers.dart';

void main() {
  group('HelpIconButton', () {
    testWidgets('renders a help icon button', (tester) async {
      await tester.pumpWidget(makeTestApp(
        child: HelpIconButton(body: const [Text('Help content')]),
      ));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.help), findsOneWidget);
    });

    testWidgets('shows dialog when tapped', (tester) async {
      await tester.pumpWidget(makeTestApp(
        child: HelpIconButton(body: const [Text('Body text here')]),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.help));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Body text here'), findsOneWidget);
    });

    testWidgets('dialog shows title when provided', (tester) async {
      await tester.pumpWidget(makeTestApp(
        child: HelpIconButton(
          title: 'My Title',
          body: const [Text('Content')],
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.help));
      await tester.pumpAndSettle();
      expect(find.text('My Title'), findsOneWidget);
    });

    testWidgets('dialog hides title when not provided', (tester) async {
      await tester.pumpWidget(makeTestApp(
        child: HelpIconButton(body: const [Text('No title')]),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.help));
      await tester.pumpAndSettle();
      final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
      expect(dialog.title, isNull);
    });

    testWidgets('dialog has a Close button that dismisses it', (tester) async {
      await tester.pumpWidget(makeTestApp(
        child: HelpIconButton(body: const [Text('Closable')]),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.help));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('dialog renders multiple body widgets', (tester) async {
      await tester.pumpWidget(makeTestApp(
        child: HelpIconButton(body: const [
          Text('Line 1'),
          Text('Line 2'),
          Text('Line 3'),
        ]),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.help));
      await tester.pumpAndSettle();
      expect(find.text('Line 1'), findsOneWidget);
      expect(find.text('Line 2'), findsOneWidget);
      expect(find.text('Line 3'), findsOneWidget);
    });
  });
}
