import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show animationTiming;

/// Plays a quick scale "pop-in" effect on [child] each time [runAnimation]
/// flips to `true`.
///
/// Used on the tile grid: when the player presses a letter key the
/// corresponding tile briefly shrinks to 70 % then springs back to 100 %,
/// giving tactile feedback that the key press was registered.
///
/// The animation is reset and replayed on every trigger (via [didUpdateWidget])
/// so it fires for every letter typed in succession.
class PopInAnimation extends StatefulWidget {
  const PopInAnimation({
    super.key,
    required this.child,
    /// Whether the pop-in should play on the next frame.
    required this.runAnimation,
  });

  /// The widget to scale-animate.
  final Widget child;

  /// Trigger: set to true to replay the animation.
  final bool runAnimation;

  @override
  State<PopInAnimation> createState() => _PopInAnimationState();
}

class _PopInAnimationState extends State<PopInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationTiming.popIn.duration),
    );

    // 1 → 0.7 (compress, 25% of duration) then 0.7 → 1 (spring back, 75%).
    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 0.7), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1), weight: 3),
    ]).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.bounceInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Resets and replays whenever [runAnimation] changes to `true`.
  @override
  void didUpdateWidget(covariant PopInAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.runAnimation) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
