const animationTiming = _AnimationTiming(
  popIn: _IndividualAnimationTimings(duration: 200),
  flip: _IndividualAnimationTimings(duration: 400, intervalDelay: 100),
  bounce: _IndividualAnimationTimings(
      duration: 500, intervalDelay: 100, initialDelay: 1300),
);

class _AnimationTiming {
  final _IndividualAnimationTimings popIn;
  final _IndividualAnimationTimings flip;
  final _IndividualAnimationTimings bounce;

  const _AnimationTiming({
    required this.popIn,
    required this.flip,
    required this.bounce,
  });
}

class _IndividualAnimationTimings {
  final int duration;
  final int? intervalDelay;
  final int? initialDelay;

  const _IndividualAnimationTimings({
    required this.duration,
    this.intervalDelay,
    this.initialDelay,
  });
}
