// Widget tests for the GameStatusAnnouncer accessibility live region.
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show keyboardStatus;
import 'package:red_owl/database/database.dart';
import 'package:red_owl/models/shared.dart' as models;
import 'package:red_owl/riverpod/shared.dart' show gridProvider;
import 'package:red_owl/routes/game/widgets/shared.dart'
    show GameStatusAnnouncer;
import 'package:red_owl/util/shared.dart'
    show SharedPreferenceService, WordleService;

import '../../helpers/test_helpers.dart';

const _testWords = ['apple', 'berry', 'chair', 'dwarf'];

void main() {
  late WidgetRef capturedRef;

  setUp(() async {
    setSharedPreferencesMock();
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

  /// Builds a finished-game grid with the given outcome.
  models.Grid finishedGrid({required bool won, required int row}) => models.Grid(
        column: 0,
        row: row,
        tiles: const [],
        keyboardStatus: keyboardStatus,
        runFlipAnimation: false,
        isEnterOrDeletePressed: false,
        isGameWon: won,
        isGameOver: true,
        notEnoughCharacters: false,
      );

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestApp(
        child: Consumer(
          builder: (context, ref, _) {
            capturedRef = ref;
            return const GameStatusAnnouncer();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('is silent (empty label) while the game is in progress',
      (tester) async {
    await pump(tester);
    final semantics = tester.widget<Semantics>(
      find.descendant(
        of: find.byType(GameStatusAnnouncer),
        matching: find.byType(Semantics),
      ),
    );
    expect(semantics.properties.label, '');
    expect(semantics.properties.liveRegion, true);
  });

  testWidgets('announces the win message including the guess count',
      (tester) async {
    await pump(tester);
    capturedRef
        .read(gridProvider.notifier)
        .updateState(finishedGrid(won: true, row: 2));
    await tester.pumpAndSettle();

    // row 2 (0-based) → solved in 3 guesses.
    expect(find.bySemanticsLabel('You won! Solved in 3 of 6 guesses.'),
        findsOneWidget);
  });

  testWidgets('announces the loss message including the answer word',
      (tester) async {
    await pump(tester);
    capturedRef
        .read(gridProvider.notifier)
        .updateState(finishedGrid(won: false, row: 6));
    await tester.pumpAndSettle();

    final answer = WordleService().wordOfTheDay.toUpperCase();
    expect(find.bySemanticsLabel('Out of guesses. The word was $answer.'),
        findsOneWidget);
  });
}
