import 'package:red_owl/config/shared.dart' show keyboardStatus;
import 'package:red_owl/models/shared.dart' as models;
import 'package:red_owl/riverpod/grid/grid.dart' show Grid;
import 'package:red_owl/util/shared.dart' show WordleService;

/// Practice / unlimited-mode variant of the [Grid] notifier.
///
/// Installed in place of the daily notifier via a `ProviderScope` override of
/// `gridProvider`, so the existing tile and keyboard widgets work unchanged.
/// It differs from the daily game in three ways:
/// - the answer is a fresh **random** word per game (not the word of the day);
/// - it never touches stats or history ([recordOutcome] is a no-op);
/// - its board sets `persistState: false`, so the [Tile] widget skips writing
///   to SharedPreferences and the daily save is left untouched.
class PracticeGrid extends Grid {
  /// The current random answer. Empty until the first async load completes.
  String _answer = '';

  @override
  models.Grid build() {
    // Kick off the async answer load. The guard in [getGuessResult] ensures a
    // valid answer even if the player somehow submits before it resolves.
    _loadAnswer();
    return _emptyBoard();
  }

  /// Picks a fresh random answer.
  Future<void> _loadAnswer() async {
    _answer = await WordleService().randomWord();
  }

  /// A blank practice board that opts out of persistence.
  models.Grid _emptyBoard() => models.Grid(
        column: 0,
        row: 0,
        tiles: [],
        keyboardStatus: keyboardStatus,
        runFlipAnimation: false,
        isEnterOrDeletePressed: false,
        isGameWon: false,
        isGameOver: false,
        notEnoughCharacters: false,
        persistState: false,
      );

  @override
  Future<models.GuessResult> getGuessResult(String guess) async {
    // Ensure an answer exists before scoring (covers the race on first guess).
    if (_answer.isEmpty) {
      _answer = await WordleService().randomWord();
    }
    return models.GuessResult.fromJson(
      await WordleService().checkGuessWord(guess, answer: _answer),
    );
  }

  /// Practice play is unlimited and untracked: never record stats or history.
  @override
  Future<void> recordOutcome({required bool gameWon}) async {}

  /// Starts a new practice game with a fresh random word and a blank board.
  @override
  void resetGrid() {
    _answer = '';
    _loadAnswer();
    state = _emptyBoard();
  }

  /// The current answer (uppercase), exposed for the practice UI/tests.
  String get answer => _answer;
}
