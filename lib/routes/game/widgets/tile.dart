import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart'
    show CustomColors, LetterStatus, SharedPreferencesKeys, animationTiming;
import 'package:red_owl/riverpod/shared.dart' show gridProvider;
import 'package:red_owl/models/shared.dart' show Grid;
import 'package:red_owl/util/shared.dart'
    show SharedPreferenceService, dateToString;

class Tile extends ConsumerStatefulWidget {
  const Tile({
    super.key,
    required this.index,
    required this.hasFlipAnimationPlayed,
  });
  final int index;
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
        Theme.of(context).extension<CustomColors>()!.borderInactive!;

    if (widget.index < grid.tiles.length) {
      if (grid.runFlipAnimation &&
          !grid.tiles[widget.index].hasFlipAnimationPlayed) {
        Future.delayed(
            Duration(
              milliseconds:
                  (widget.index % 5) * animationTiming.flip.intervalDelay!,
            ), () {
          _animationController.forward().whenComplete(() {
            // TODO: optimize code with map() instead
            var tiles = [...grid.tiles];
            var newTiles = tiles
                .map((e) => e.copyWith(hasFlipAnimationPlayed: true))
                .toList();
            var newGrid =
                grid.copyWith(runFlipAnimation: false, tiles: newTiles);

            ref.read(gridProvider.notifier).updateState(newGrid);

            // Save grid to share prefs.
            String gameState = jsonEncode(newGrid.toJson());
            String gameStateBase64 = base64.encode(utf8.encode(gameState));

            SharedPreferenceService()
                .setString(SharedPreferencesKeys.gridState, gameStateBase64);

            // Save game date
            SharedPreferenceService().setString(
                SharedPreferencesKeys.gameDate, dateToString(DateTime.now()));
          });
        });
      }

      switch (grid.tiles[widget.index].status) {
        case LetterStatus.initial:
          backgroundColor = null;
          borderColor =
              Theme.of(context).extension<CustomColors>()!.borderActive!;
          break;
        case LetterStatus.green:
          backgroundColor = Theme.of(context).extension<CustomColors>()!.green!;
          borderColor = Colors.transparent;
          textColor = Colors.white;
          break;
        case LetterStatus.yellow:
          backgroundColor =
              Theme.of(context).extension<CustomColors>()!.yellow!;
          borderColor = Colors.transparent;
          textColor = Colors.white;
          break;
        case LetterStatus.notInWord:
          backgroundColor =
              Theme.of(context).extension<CustomColors>()!.notInWord!;
          borderColor = Colors.transparent;
          textColor = Colors.white;
          break;
      }
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        double flip = 0;
        if (_animationController.value > 0.5) {
          flip = math.pi;
        }
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003)
            ..rotateX(_animationController.value * math.pi)
            ..rotateX(flip),
          alignment: Alignment.center,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: (flip > 0 || widget.hasFlipAnimationPlayed)
                  ? backgroundColor
                  : null,
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
                            color: (flip > 0 || widget.hasFlipAnimationPlayed)
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
    );
  }
}
