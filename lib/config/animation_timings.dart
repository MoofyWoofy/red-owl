const animationTiming = _AnimationTiming(
  popIn: _IndividualAnimationTimings(duration: 200),
  flip: _IndividualAnimationTimings(duration: 400, intervalDelay: 100),
  bounce: _IndividualAnimationTimings(
      duration: 500, intervalDelay: 100, initialDelay: 1300),
  shake: _IndividualAnimationTimings(duration: 800),
);

class _AnimationTiming {
  final _IndividualAnimationTimings popIn;
  final _IndividualAnimationTimings flip;
  final _IndividualAnimationTimings bounce;
  final _IndividualAnimationTimings shake;

  const _AnimationTiming({
    required this.popIn,
    required this.flip,
    required this.bounce,
    required this.shake,
  });
}

class _IndividualAnimationTimings {
  /// duration in milliseconds.
  final int duration;
  /// interval (ms) between animation if multiple Tweens.
  final int? intervalDelay;
  /// how long to wait before starting animation in milliseconds.
  final int? initialDelay;

  const _IndividualAnimationTimings({
    required this.duration,
    this.intervalDelay,
    this.initialDelay,
  });
}
