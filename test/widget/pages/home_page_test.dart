// Widget tests for the HomePage (home screen).
//
// Verifies: Red Owl title, Daily/Stats buttons with icons, Logo presence,
// OutlinedButton widgets, and settings gear icon in the AppBar.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/main.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('HomePage', () {
    setUp(() {
      setSharedPreferencesMock({
        'isDarkMode': false,
      });
    });

    testWidgets('renders the Red Owl title in the AppBar', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const HomePage(title: 'Red Owl')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Red Owl'), findsOneWidget);
    });

    testWidgets('renders Daily, Practice and Stats buttons', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const HomePage(title: 'Red Owl')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Daily'), findsOneWidget);
      expect(find.text('Practice'), findsOneWidget);
      expect(find.text('Stats'), findsOneWidget);
    });

    testWidgets('renders the Logo widget', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const HomePage(title: 'Red Owl')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders calendar icon on Daily button', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const HomePage(title: 'Red Owl')),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('renders bar chart icon on Stats button', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const HomePage(title: 'Red Owl')),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.bar_chart), findsOneWidget);
    });

    testWidgets('renders settings icon button in AppBar', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const HomePage(title: 'Red Owl')),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('renders the Practice (fitness) icon button', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const HomePage(title: 'Red Owl')),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.fitness_center), findsOneWidget);
    });

    testWidgets('has three OutlinedButtons', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const HomePage(title: 'Red Owl')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(OutlinedButton), findsNWidgets(3));
    });
  });
}
