import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart'
    show GameColors, LetterStatus, SharedPreferencesKeys, animationTiming;
import 'package:red_owl/riverpod/shared.dart' show gridProvider;
import 'package:red_owl/models/shared.dart' show Grid;
import 'package:red_owl/routes/game/widgets/a11y_labels.dart'
    show letterStatusLabel;
import 'package:red_owl/util/shared.dart'
    show Localization, SharedPreferenceService, dateToString;

/// A single interactive tile in the 5×6 Wordle grid.
///
/// Each tile is responsible for:
/// - Displaying the letter at [index] in the grid's tile list (or empty if
///   no letter has been placed yet).
/// - Coloring itself according to the tile's [LetterStatus] (initial, green,
///   yellow, notInWord).
/// - Playing a 3-D flip animation ([AnimationController] rotating on the
///   X-axis) when a guess row is submitted. The color only appears after the
///   rotation passes 90° (the halfway point) to simulate revealing the result.
/// - After the flip completes, persisting the updated grid (with
///   `hasFlipAnimationPlayed: true` for each tile) to SharedPreferences so
///   the revealed colors survive an app restart.
class Tile extends ConsumerStatefulWidget {
  const Tile({
    super.key,
    /// Position of this tile in the flat 30-element tile list (0–29).
    required this.index,
    /// Whether the flip animation has already played for this tile.
    /// Passed from the grid state so the color is shown immediately on
    /// rebuild without re-animating.
    required this.hasFlipAnimationPlayed,
  });

  /// Flat index of this tile in [Grid.tiles] (row * 5 + column).
  final int index;

  /// Whether the reveal flip has already been played for this tile.
  final bool hasFlipAnimationPlayed;

  @override
  ConsumerState<Tile> createState() => _TileState();
}

class _TileState extends ConsumerState<Tile>
    with SingleTickerProviderStateMixin {
  Color? backgroundColor, textColor;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationTiming.flip.duration),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Grid grid = ref.watch(gridProvider);
    Color borderColor =
        Theme.of(context).extension<GameColors>()!.borderInactive!;
    bool hasFlipAnimationPlayed = widget.hasFlipAnimationPlayed;

    if (widget.index < grid.tiles.length) {
      // This tile has a letter — schedule the flip animation if needed.
      if (grid.runFlipAnimation &&
          !grid.tiles[widget.index].hasFlipAnimationPlayed) {
        // Stagger each tile in the row by (column % 5) * intervalDelay ms.
        Future.delayed(
            Duration(
              milliseconds:
                  (widget.index % 5) * animationTiming.flip.intervalDelay!,
            ), () {
          // The staggered delay means this can fire after the tile is gone
          // (e.g. navigating back mid-flip); bail out before touching the
          // disposed controller or ref.
          if (!mounted) return;
          _animationController.forward().whenComplete(() {
            if (!mounted) return;
            var tiles = [...grid.tiles];
            // Mark every tile as animated so colors persist after rebuild.
            var newTiles = tiles
                .map((e) => e.copyWith(hasFlipAnimationPlayed: true))
                .toList();
            var newGrid =
                grid.copyWith(runFlipAnimation: false, tiles: newTiles);

            ref.read(gridProvider.notifier).updateState(newGrid);

            // The practice board opts out of persistence so it never clobbers
            // the saved daily game.
            if (newGrid.persistState) {
              // Persist the updated grid to SharedPreferences as Base64 JSON.
              String gameState = jsonEncode(newGrid.toJson());
              String gameStateBase64 = base64.encode(utf8.encode(gameState));

              SharedPreferenceService()
                  .setString(SharedPreferencesKeys.gridState, gameStateBase64);

              // Update the date stamp alongside the grid.
              SharedPreferenceService().setString(
                  SharedPreferencesKeys.gameDate, dateToString(DateTime.now()));
            }
          });
        });
      }

      // Map [LetterStatus] to the corresponding theme color.
      switch (grid.tiles[widget.index].status) {
        case LetterStatus.initial:
          // Unpredicted tile with a letter: show active border, no fill.
          backgroundColor = null;
          borderColor =
              Theme.of(context).extension<GameColors>()!.borderActive!;
          break;
        case LetterStatus.green:
          backgroundColor = Theme.of(context).extension<GameColors>()!.green!;
          borderColor = Colors.transparent;
          textColor = Colors.white;
          break;
        case LetterStatus.yellow:
          backgroundColor =
              Theme.of(context).extension<GameColors>()!.yellow!;
          borderColor = Colors.transparent;
          textColor = Colors.white;
          break;
        case LetterStatus.notInWord:
          backgroundColor =
              Theme.of(context).extension<GameColors>()!.notInWord!;
          borderColor = Colors.transparent;
          textColor = Colors.white;
          break;
      }
    } else {
      // No tile at this index yet — reset to the default empty appearance.
      // Explicit reset is required because Flutter may reuse the State object
      // (e.g. when navigating back from Settings) and without it the tile
      // would incorrectly keep the previous colors.
      backgroundColor = null;
      borderColor = Theme.of(context).extension<GameColors>()!.borderActive!;
      hasFlipAnimationPlayed = false;
    }

    // Screen-reader description: the letter and its evaluated status, or
    // "Empty" for a tile with no letter yet.
    final String semanticLabel = widget.index < grid.tiles.length
        ? letterStatusLabel(
            context,
            grid.tiles[widget.index].letter,
            grid.tiles[widget.index].status,
          )
        : context.l10n.a11yEmptyTile;

    return Semantics(
      label: semanticLabel,
      child: AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        double flip = 0;
        // After the controller passes the halfway point (>0.5), add π radians
        // so the tile appears to have fully flipped and now shows its back face
        // (with the revealed color).
        if (_animationController.value > 0.5) {
          flip = math.pi;
        }
        return Transform(
          // Perspective entry (3, 2) gives a subtle depth effect.
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003)
            ..rotateX(_animationController.value * math.pi)
            ..rotateX(flip),
          alignment: Alignment.center,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              // Only show the status color once the tile has "flipped" past 90°
              // or if the animation was previously completed.
              color:
                  (flip > 0 || hasFlipAnimationPlayed) ? backgroundColor : null,
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
            ),
            child: widget.index < grid.tiles.length
                ? FittedBox(
                    fit: BoxFit.contain,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          grid.tiles[widget.index].letter,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // Text color also switches at the flip midpoint.
                            color: (flip > 0 || hasFlipAnimationPlayed)
                                ? textColor
                                : null,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        );
      },
      ),
    );
  }
}
