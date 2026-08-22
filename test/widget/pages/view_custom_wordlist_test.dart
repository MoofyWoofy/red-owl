// Widget tests for the "view word list" page.
//
// Covers the empty case in particular: `prototypeItem` reads `words.first`,
// which used to throw `Bad state: No element` for a list with no words.
//
// The word list is loaded in `setUp` rather than inside the test body on
// purpose: `WordleService` parses via `compute()`, and an isolate's future
// never completes inside `testWidgets`' fake-async zone.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/routes/settings/routes/view_custom_wordlist.dart';
import 'package:red_owl/util/shared.dart'
    show SharedPreferenceService, WordleService;

import '../../helpers/test_helpers.dart';

void main() {
  /// Installs [words] as the active list and clears WordleService's cache.
  Future<void> loadList(List<String> words) async {
    await installFakePathProvider();
    setSharedPreferencesMock();
    await SharedPreferenceService().init();
    setAssetBundleMock(words);
    try {
      await WordleService().init();
    } catch (_) {
      // An empty list has no word of the day; the page only needs the list,
      // which `init()` has already re-read into the cache.
    }
  }

  tearDown(() => setAssetBundleMock(null));

  group('with a populated list', () {
    setUp(() => loadList(const ['apple', 'berry', 'chair']));

    testWidgets('lists the words', (tester) async {
      await tester.pumpWidget(makeTestAppRaw(child: const ViewCustomListPage()));
      await tester.pump();

      expect(find.text('apple'), findsOneWidget);
      expect(find.text('berry'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('with an empty list', () {
    setUp(() => loadList(const []));

    testWidgets('shows a message instead of throwing', (tester) async {
      await tester.pumpWidget(makeTestAppRaw(child: const ViewCustomListPage()));
      await tester.pump();

      // Previously `prototypeItem: ListTile(title: Text(words.first))` raised
      // "Bad state: No element" here.
      expect(tester.takeException(), isNull);
      expect(find.byType(ListView), findsNothing);
    });
  });
}
