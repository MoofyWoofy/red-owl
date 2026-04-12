import 'package:flutter/material.dart';

/// A small colored square tile used inside the "HOW TO PLAY" help dialog.
///
/// Renders a single letter on a solid [background] color to illustrate the
/// green / yellow / grey tile meanings shown in the instructions.
/// Unlike the real game [Tile], this widget has no animation or interactivity.
class HelpTile extends StatelessWidget {
  const HelpTile({
    super.key,
    /// Solid fill color — use [GameColors.green], [GameColors.yellow], or
    /// [GameColors.notInWord] from the current theme.
    required this.background,
    /// Single uppercase letter to display.
    required this.letter,
  });

  /// Solid background color of the tile.
  final Color background;

  /// The letter character displayed centered inside the tile.
  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            color: Colors.transparent,
            width: 2,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                letter,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ));
  }
}
