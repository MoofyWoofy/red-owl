import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show animationTiming;

/// Plays a two-phase bounce (up then gently back up) on [child] when
/// [runAnimation] flips to `true`.
///
/// Used on the winning row tiles after a correct guess: each tile bounces
/// sequentially using an external [delay] offset so they ripple left-to-right.
/// The bounce is a [SlideTransition] driven by a [TweenSequence] of four
/// [Offset] keyframes:
///
/// 1. 0 → -0.60 (rapid upward leap, 16% of duration)
/// 2. -0.60 → 0 (falling back down, 12%)
/// 3. 0 → -0.25 (smaller second hop, 10%)
/// 4. -0.25 → 0 (settles, 8%)
class BounceAnimation extends StatefulWidget {
  const BounceAnimation({
    super.key,
    required this.child,
    /// Whether the bounce should play on the next frame.
    required this.runAnimation,
    /// Milliseconds to wait before starting — used to stagger the row.
    required this.delay,
  });

  /// The widget to animate.
  final Widget child;

  /// Trigger: set to true (via [didUpdateWidget]) to start the animation.
  final bool runAnimation;

  /// Initial delay in milliseconds before the animation begins.
  final int delay;

  @override
  State<BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: animationTiming.bounce.duration));

    // Four-keyframe bounce sequence (fractional pixel offset on the y-axis).
    _animation = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween(begin: const Offset(0, 0), end: const Offset(0, -0.6)),
          weight: 16),
      TweenSequenceItem(
          tween: Tween(begin: const Offset(0, -0.6), end: const Offset(0, 0)),
          weight: 12),
      TweenSequenceItem(
          tween: Tween(begin: const Offset(0, 0), end: const Offset(0, -0.25)),
          weight: 10),
      TweenSequenceItem(
          tween: Tween(begin: const Offset(0, -0.25), end: const Offset(0, 0)),
          weight: 8),
    ]).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Starts the animation after [widget.delay] ms whenever [runAnimation]
  /// transitions to `true`.
  @override
  void didUpdateWidget(covariant BounceAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.runAnimation) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        // The delay can outlive the widget (e.g. leaving the page right after a
        // win); don't drive a disposed controller.
        if (!mounted) return;
        _animationController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _animation, child: widget.child);
  }
}
