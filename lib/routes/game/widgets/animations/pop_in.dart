import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show animationTiming;

class PopInAnimation extends StatefulWidget {
  const PopInAnimation({
    super.key,
    required this.child,
    required this.runAnimation,
  });
  final Widget child;
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
