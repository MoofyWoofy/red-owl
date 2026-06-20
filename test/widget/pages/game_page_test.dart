// Widget tests for WordlePage (the main game screen).
//
// Verifies: 30-tile 5×6 grid, three keyboard rows, GridView presence,
// current date in AppBar, settings/help icons, and HOW TO PLAY dialog.
// Uses a larger viewport (1080×1920) so the GridView renders all 30 tiles.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
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

    testWidgets('AppBar shows the current date in the regional format',
        (tester) async {
      await tester.pumpWidget(
        makeTestAppRaw(child: const WordlePage()),
      );
      await tester.pumpAndSettle();
      // Compute the expected text via the same locale-aware API the page uses,
      // so the test is independent of the exact pattern for the test locale.
      final context = tester.element(find.byType(WordlePage));
      final expectedDate =
          MaterialLocalizations.of(context).formatCompactDate(DateTime.now());
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

    testWidgets('hardware keyboard letters fill the grid', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(makeTestAppRaw(child: const WordlePage()));
      await tester.pumpAndSettle();

      // Before typing, 'H' appears only on the on-screen keyboard.
      expect(find.text('H'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.keyH);
      await tester.pumpAndSettle();

      // Now 'H' is on the keyboard AND in the first tile.
      expect(find.text('H'), findsNWidgets(2));
    });

    testWidgets('hardware backspace removes the last typed tile',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(makeTestAppRaw(child: const WordlePage()));
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.keyH);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyE);
      await tester.pumpAndSettle();
      expect(find.text('E'), findsNWidgets(2));

      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pumpAndSettle();
      // The 'E' tile is gone; only the keyboard key remains.
      expect(find.text('E'), findsOneWidget);
    });
  });
}
