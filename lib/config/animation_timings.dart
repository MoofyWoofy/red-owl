/// Central timing configuration for all tile and keyboard animations.
///
/// Each animation type (popIn, flip, bounce, shake) has its own duration,
/// optional stagger delay between tiles, and optional initial wait time.
/// All durations are specified in milliseconds.
const animationTiming = _AnimationTiming(
  /// Tile scale animation when a letter key is pressed and added to the grid.
  popIn: _IndividualAnimationTimings(duration: 200),

  /// Tile flip (3D rotation on X-axis) when the player presses ENTER to check a word.
  /// Each tile in the row flips sequentially, offset by [intervalDelay] ms.
  flip: _IndividualAnimationTimings(duration: 400, intervalDelay: 100),

  /// Victory bounce played after all tiles have flipped green on a correct guess.
  /// Waits [initialDelay] ms (for the flip to finish) before starting, then each
  /// tile bounces with an [intervalDelay] ms offset from the previous one.
  bounce: _IndividualAnimationTimings(
      duration: 500, intervalDelay: 100, initialDelay: 1300),

  /// Horizontal shake when the entered word is not in the word list or the row
  /// does not have enough characters.
  shake: _IndividualAnimationTimings(duration: 800),
);

/// Groups all animation timing presets used across the game.
class _AnimationTiming {
  /// Timing for the pop-in scale effect on letter entry.
  final _IndividualAnimationTimings popIn;

  /// Timing for the tile flip (reveal) animation.
  final _IndividualAnimationTimings flip;

  /// Timing for the victory bounce animation.
  final _IndividualAnimationTimings bounce;

  /// Timing for the error shake animation.
  final _IndividualAnimationTimings shake;

  const _AnimationTiming({
    required this.popIn,
    required this.flip,
    required this.bounce,
    required this.shake,
  });
}

/// Describes the timing parameters for a single animation type.
class _IndividualAnimationTimings {
  /// Total duration of the animation in milliseconds.
  final int duration;

  /// Stagger delay (ms) between successive tiles when the animation is applied
  /// to a row of tiles. Null if the animation is not staggered.
  final int? intervalDelay;

  /// Initial wait (ms) before the animation begins. Used by the bounce
  /// animation to wait until the flip animation completes.
  final int? initialDelay;

  const _IndividualAnimationTimings({
    required this.duration,
    this.intervalDelay,
    this.initialDelay,
  });
}
