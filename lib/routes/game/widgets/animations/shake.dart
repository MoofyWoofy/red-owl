import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show animationTiming;

class ShakeAnimation extends StatefulWidget {
  const ShakeAnimation({
    super.key,
    required this.child,
    required this.runAnimation,
  });
  final Widget child;
  final bool runAnimation;

  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  final Offset movement0 = const Offset(0, 0);
  final Offset movement1 = const Offset(-0.03125, 0);
  final Offset movement2 = const Offset(0.0625, 0);
  final Offset movement3 = const Offset(-0.125, 0);
  final Offset movement4 = const Offset(0.125, 0);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: animationTiming.shake.duration));
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
    // CurvedAnimation(parent: _animationController, curve: Curves.linear));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

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
