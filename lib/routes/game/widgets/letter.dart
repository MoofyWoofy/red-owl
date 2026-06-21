import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart' show GameColors, LetterStatus;
import 'package:red_owl/riverpod/shared.dart';
import 'package:red_owl/routes/game/widgets/a11y_labels.dart'
    show letterStatusLabel;
import 'package:red_owl/util/shared.dart' show Localization;

/// A single key on the on-screen keyboard.
///
/// Colours itself based on the [LetterStatus] stored in the grid's
/// [keyboardStatus] map so that already-evaluated letters are highlighted
/// green, yellow, or grey. Interaction is disabled once the game is over
/// via [IgnorePointer].
///
/// The DELETE key renders a backspace icon instead of the raw text string.
class Letter extends ConsumerWidget {
  const Letter({super.key, required this.letter});

  /// The key label (uppercase letter, `'ENTER'`, or `'DELETE'`).
  final String letter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color? backgroundColor;
    Color? textColor;
    var grid = ref.watch(gridProvider);

    // Determine background and text color from the current keyboard status.
    switch (grid.keyboardStatus[letter]) {
      case LetterStatus.initial:
        backgroundColor = Theme.of(context).extension<GameColors>()?.initial;
        break;
      case LetterStatus.green:
        backgroundColor = Theme.of(context).extension<GameColors>()?.green;
        textColor = Colors.white;
        break;
      case LetterStatus.yellow:
        backgroundColor = Theme.of(context).extension<GameColors>()?.yellow;
        textColor = Colors.white;
        break;
      case LetterStatus.notInWord:
      case null:
        // null can occur for ENTER/DELETE which are not in keyboardStatus.
        backgroundColor = Theme.of(context).extension<GameColors>()?.notInWord;
        textColor = Colors.white;
        break;
    }

    // Screen-reader label: action keys read their name, letter keys read the
    // letter and (once evaluated) its status.
    final String semanticLabel;
    switch (letter) {
      case 'ENTER':
        semanticLabel = context.l10n.a11yEnterKey;
      case 'DELETE':
        semanticLabel = context.l10n.a11yDeleteKey;
      default:
        semanticLabel =
            letterStatusLabel(context, letter, grid.keyboardStatus[letter]);
    }

    // Forwards the key press to the grid notifier. Shared by pointer taps and
    // accessibility / keyboard activation.
    void press() {
      ref.read(gridProvider.notifier).onKeyboardPressed(
            key: letter,
            context: context,
          );
    }

    return IgnorePointer(
      // Disable all keys once the game is finished.
      ignoring: grid.isGameOver,
      child: Semantics(
        button: true,
        enabled: !grid.isGameOver,
        label: semanticLabel,
        // Let assistive tech activate the key directly (the inner InkWell's
        // own semantics are excluded to avoid a duplicate node).
        onTap: grid.isGameOver ? null : press,
        excludeSemantics: true,
        child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 5),
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.black38,
          // Keep keys out of the focus traversal once the game is over.
          canRequestFocus: !grid.isGameOver,
          onTap: press,
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.5),
                  blurRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            // Show a backspace icon for DELETE, plain text for all other keys.
            child: letter != "DELETE"
                ? Text(
                    letter,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor),
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      Icons.backspace_outlined,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
          ),
        ),
        ),
      ),
    );
  }
}
