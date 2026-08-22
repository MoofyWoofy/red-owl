// Widget tests for the PracticePage.
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/database/database.dart';
import 'package:red_owl/routes/shared.dart' show PracticePage;
import 'package:red_owl/routes/game/widgets/shared.dart'
    show GameBoard, Letter, Tile;
import 'package:red_owl/util/shared.dart'
    show SharedPreferenceService, WordleService;

import '../../helpers/test_helpers.dart';

const _testWords = ['apple', 'berry', 'chair', 'dwarf'];

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

  testWidgets('renders the practice title, board and new-word action',
      (tester) async {
    await tester.pumpWidget(makeTestAppRaw(child: const PracticePage()));
    await tester.pumpAndSettle();

    expect(find.text('Practice'), findsOneWidget);
    expect(find.byType(GameBoard), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
    // No settings gear on the practice page.
    expect(find.byIcon(Icons.settings), findsNothing);
  });

  testWidgets('the new-word action can be tapped without error',
      (tester) async {
    await tester.pumpWidget(makeTestAppRaw(child: const PracticePage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();
    expect(find.byType(GameBoard), findsOneWidget);
  });

  // Regression: the flip AnimationController was driven with a plain
  // `forward()` and never reset, so after `resetGrid()` it was still at 1.0 and
  // the next `forward()` completed instantly — tiles snapped to their colour
  // with no flip. Practice mode resets on every "New word", so only the first
  // game of a session animated.
  testWidgets('tiles still flip after the board is reset', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(makeTestAppRaw(child: const PracticePage()));
    await tester.pumpAndSettle();

    Future<void> tapKey(String label) async {
      await tester.tap(find.descendant(
        of: find.byType(Letter),
        matching: find.text(label),
      ));
      await tester.pump();
    }

    Future<void> submit(String word) async {
      for (final ch in word.split('')) {
        await tapKey(ch);
      }
      await tapKey('ENTER');
    }

    /// The transform matrix of the first tile, which drives the flip.
    Matrix4 firstTileTransform() {
      final transform = tester.widgetList<Transform>(find.descendant(
        of: find.byType(Tile).first,
        matching: find.byType(Transform),
      )).first;
      return transform.transform;
    }

    // The practice answer is random, so a guess may or may not win. Either way
    // the flip runs; drain the snack-bar timers a win schedules so the test
    // does not end with timers pending.
    Future<void> drainSnackBars() => tester.pump(const Duration(seconds: 4));

    // Game 1 — play a full guess and let its flip finish.
    await submit('APPLE');
    await tester.pumpAndSettle();
    await drainSnackBars();

    // Reset the board the way the "New word" action does.
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();

    // Game 2 — halfway through the flip the tile must be mid-rotation.
    await submit('BERRY');
    await tester.pump(const Duration(milliseconds: 200));
    final midFlip = firstTileTransform().clone();

    await tester.pumpAndSettle();
    final settled = firstTileTransform().clone();

    expect(midFlip, isNot(equals(settled)),
        reason: 'the second game\'s tile jumped straight to its final '
            'transform, so the flip animation did not run');

    await drainSnackBars();
    await tester.pumpAndSettle();
  });
}
