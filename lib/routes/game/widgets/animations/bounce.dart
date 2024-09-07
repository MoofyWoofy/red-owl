import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show animationTiming;

class BounceAnimation extends StatefulWidget {
  const BounceAnimation({
    super.key,
    required this.child,
    required this.runAnimation,
    required this.delay,
  });
  final Widget child;
  final bool runAnimation;
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

  @override
  void didUpdateWidget(covariant BounceAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.runAnimation) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        _animationController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _animation, child: widget.child);
  }
}
