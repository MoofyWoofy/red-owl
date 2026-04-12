// Widget tests for WordlePage (the main game screen).
//
// Verifies: 30-tile 5×6 grid, three keyboard rows, GridView presence,
// current date in AppBar, settings/help icons, and HOW TO PLAY dialog.
// Uses a larger viewport (1080×1920) so the GridView renders all 30 tiles.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/routes/game/widgets/shared.dart'
    show KeyboardRow, Tile;
import 'package:red_owl/routes/shared.dart' show WordlePage;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

import '../../helpers/test_helpers.dart';

void main() {
  group('WordlePage (GamePage)', () {
    setUp(() async {
      setSharedPreferencesMock({
        'isDarkMode': false,
      });
      await SharedPreferenceService().init();
    });

    testWidgets('renders a 5x6 grid of tiles', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(
        makeTestAppRaw(child: const WordlePage()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Tile), findsNWidgets(30));
    });

    testWidgets('renders three keyboard rows', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const WordlePage()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(KeyboardRow), findsNWidgets(3));
    });

    testWidgets('renders a GridView', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const WordlePage()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('AppBar shows the current date', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const WordlePage()),
      );
      await tester.pumpAndSettle();
      final now = DateTime.now();
      final expectedDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      expect(find.text(expectedDate), findsOneWidget);
    });

    testWidgets('renders settings icon in AppBar', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const WordlePage()),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('renders help icon in AppBar', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const WordlePage()),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.help), findsOneWidget);
    });

    testWidgets('help button opens HOW TO PLAY dialog', (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const WordlePage()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.help));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('HOW TO PLAY'), findsOneWidget);
    });
  });
}
