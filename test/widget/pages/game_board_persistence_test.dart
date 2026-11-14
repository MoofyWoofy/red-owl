// Widget tests for what the daily board persists once a guess has flipped.
//
// The Tile widget saves the board to SharedPreferences when a row's flip
// finishes. It must save the board only: `gameDate` names the day the board
// belongs to and is owned by the Grid notifier. It used to be re-stamped with
// `DateTime.now()` on every save, which moved a game that crossed midnight onto
// the new day.
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/database/database.dart';
import 'package:red_owl/routes/shared.dart' show WordlePage;
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
    // Loaded here, in the real zone: the list is parsed via `compute`, whose
    // isolate never completes inside a testWidgets body.
    await WordleService().init();
  });

  tearDown(() async {
    await AppDatabase().close();
    AppDatabase.resetSingleton();
    setAssetBundleMock(null);
  });

  testWidgets('saving a flipped row keeps the board\'s date stamp', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(makeTestAppRaw(child: const WordlePage()));
    await tester.pumpAndSettle();

    // Stand-in for "this board was created on an earlier day": whatever the
    // stamp says, a save must leave it alone.
    const boardDay = '2000-01-01';
    SharedPreferenceService().setString(
      SharedPreferencesKeys.gameDate,
      boardDay,
    );

    // A valid list word that is not today's answer, so the row flips and the
    // game carries on.
    final answer = WordleService().wordOfTheDay.toLowerCase();
    final guess = _testWords.firstWhere((word) => word != answer);
    for (final letter in guess.split('')) {
      // Logical keys a–z have consecutive ids matching their character codes.
      await tester.sendKeyEvent(
        LogicalKeyboardKey.findKeyByKeyId(letter.codeUnitAt(0))!,
      );
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    // Run the staggered flip to completion, then drain the snack-bar timer.
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(
      SharedPreferenceService().getString(SharedPreferencesKeys.gridState),
      isNotNull,
      reason: 'the flipped row should have been saved',
    );
    expect(
      SharedPreferenceService().getString(SharedPreferencesKeys.gameDate),
      boardDay,
    );
  });
}
