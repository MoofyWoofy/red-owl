import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart' show CustomColors, LetterStatus;
import 'package:red_owl/riverpod/shared.dart' show gridProvider;
import 'package:red_owl/models/shared.dart' show Grid;

class Tile extends ConsumerStatefulWidget {
  const Tile({super.key, required this.index});
  final int index;

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
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Grid grid = ref.watch(gridProvider);
    Color borderColor =
        Theme.of(context).extension<CustomColors>()!.borderInactive!;

    if (widget.index < grid.tiles.length) {
      if (grid.runAnimation) {
        Future.delayed(Duration(milliseconds: (widget.index % 5) * 100), () {
          _animationController.forward();
          ref.read(gridProvider.notifier).setRunAnimationValue(false);
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
              color: flip > 0 ? backgroundColor : null,
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
                            color: flip > 0 ? textColor : null,
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
