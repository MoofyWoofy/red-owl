import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show animationTiming;

/// Plays a horizontal shake on [child] when [runAnimation] flips to `true`.
///
/// Used on the active tile row to signal an invalid submission:
/// - The row does not yet have 5 characters (not enough letters).
/// - The entered word is not found in the word list.
///
/// The animation is a [SlideTransition] driven by a 10-step [TweenSequence]
/// that oscillates between small negative and positive x-offsets, mimicking
/// the classic "wrong password" shake effect.
class ShakeAnimation extends StatefulWidget {
  const ShakeAnimation({
    super.key,
    required this.child,
    /// Whether the shake should play on the next frame.
    required this.runAnimation,
  });

  /// The widget to shake.
  final Widget child;

  /// Trigger: set to true to play (or replay) the shake.
  final bool runAnimation;

  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  // Named offsets make the TweenSequence below easier to read.
  final Offset movement0 = const Offset(0, 0);         // rest
  final Offset movement1 = const Offset(-0.03125, 0);  // slight left
  final Offset movement2 = const Offset(0.0625, 0);    // right
  final Offset movement3 = const Offset(-0.125, 0);    // further left
  final Offset movement4 = const Offset(0.125, 0);     // further right

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: animationTiming.shake.duration));

    // 10 equal-weight steps: rest → slight left → right → further oscillations
    // → back to rest.  Linear (no curve) keeps the shaking consistent.
    _animation = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween(begin: movement0, end: movement1), weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: movement1, end: movement2), weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: movement2, end: movement3), weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: movement3, end: movement4), weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: movement4, end: movement3), weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: movement3, end: movement4), weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: movement4, end: movement3), weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: movement3, end: movement2), weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: movement2, end: movement1), weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: movement1, end: movement0), weight: 1),
    ]).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Resets and replays the shake whenever [runAnimation] becomes `true`.
  @override
  void didUpdateWidget(covariant ShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.runAnimation) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _animation, child: widget.child);
  }
}
