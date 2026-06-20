// Unit tests for PracticeGrid — the practice / unlimited-mode notifier.
//
// Installed via a gridProvider override so the host reads it exactly like the
// daily game would. Verifies the random-answer flow plus the guarantees that
// practice play never records stats or history and opts out of persistence.
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/database/database.dart';
import 'package:red_owl/riverpod/shared.dart' show gridProvider, PracticeGrid;
import 'package:red_owl/util/shared.dart'
    show SharedPreferenceService, WordleService;

import '../../helpers/test_helpers.dart';

const _testWords = ['apple', 'berry', 'chair', 'dwarf', 'eagle', 'flame'];

void main() {
  late WidgetRef capturedRef;
  late BuildContext capturedContext;

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

  Future<void> pumpHost(WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestApp(
        overrides: [gridProvider.overrideWith(PracticeGrid.new)],
        child: Consumer(
          builder: (context, ref, _) {
            capturedRef = ref;
            capturedContext = context;
            ref.watch(gridProvider);
            return const SizedBox();
          },
        ),
      ),
    );
    // Let the async random-answer load complete.
    await tester.pumpAndSettle();
  }

  PracticeGrid notifier() =>
      capturedRef.read(gridProvider.notifier) as PracticeGrid;

  Future<void> type(String word) async {
    final n = capturedRef.read(gridProvider.notifier);
    for (final ch in word.toUpperCase().split('')) {
      await n.onKeyboardPressed(key: ch, context: capturedContext);
    }
  }

  Future<void> enter() => capturedRef
      .read(gridProvider.notifier)
      .onKeyboardPressed(key: 'ENTER', context: capturedContext);

  Future<void> drainSnackBars(WidgetTester tester) =>
      tester.pumpAndSettle(const Duration(seconds: 4));

  testWidgets('starts on a non-persisted board with a random answer',
      (tester) async {
    await pumpHost(tester);
    final grid = capturedRef.read(gridProvider);
    expect(grid.persistState, isFalse);
    expect(grid.tiles, isEmpty);
    expect(_testWords.map((w) => w.toUpperCase()), contains(notifier().answer));
  });

  testWidgets('typing the random answer wins the game', (tester) async {
    await pumpHost(tester);
    await type(notifier().answer);
    await enter();

    final grid = capturedRef.read(gridProvider);
    expect(grid.isGameWon, isTrue);
    expect(grid.isGameOver, isTrue);
    await drainSnackBars(tester);
  });

  testWidgets('winning practice records no stats and no history',
      (tester) async {
    await pumpHost(tester);
    await type(notifier().answer);
    await enter();
    await tester.pumpAndSettle();

    // Stats arrays were never created, and no history row was written.
    expect(
      SharedPreferenceService().getStringList(SharedPreferencesKeys.statsData),
      isNull,
    );
    final rows = await AppDatabase().select(AppDatabase().history).get();
    expect(rows, isEmpty);
    await drainSnackBars(tester);
  });

  testWidgets('practice never writes the daily grid state', (tester) async {
    await pumpHost(tester);
    await type(notifier().answer);
    await enter();
    await tester.pumpAndSettle();

    expect(
      SharedPreferenceService().getString(SharedPreferencesKeys.gridState),
      isNull,
    );
    await drainSnackBars(tester);
  });

  testWidgets('resetGrid starts a fresh blank board', (tester) async {
    await pumpHost(tester);
    await type('APPLE');
    expect(capturedRef.read(gridProvider).tiles, hasLength(5));

    notifier().resetGrid();
    await tester.pumpAndSettle();
    final grid = capturedRef.read(gridProvider);
    expect(grid.tiles, isEmpty);
    expect(grid.row, 0);
    expect(grid.persistState, isFalse);
  });
}
