import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class AnimatedFeedback extends StatefulWidget {
  const AnimatedFeedback({
    super.key,
    required this.currentOffset,
    required this.originalOffset,
    required this.velocity,
    required this.size,
    required this.onEnd,
    required this.child,
  });

  final Offset currentOffset;
  final Offset originalOffset;
  final Velocity velocity;
  final Size size;
  final VoidCallback onEnd;
  final Widget child;

  @override
  State<AnimatedFeedback> createState() => _AnimatedFeedbackState();
}

class _AnimatedFeedbackState extends State<AnimatedFeedback>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Offset offset;

  @override
  void initState() {
    offset = widget.currentOffset;

    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      setState(() {
        offset = _animation.value;
        debugPrint('stateOffset: $offset');
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runAnimation(widget.velocity.pixelsPerSecond, widget.size);
    });
    super.initState();
  }

  /// Calculates and runs a [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      Tween<Offset>(
        begin: widget.currentOffset,
        end: widget.originalOffset,
      ),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);
    _controller.animateWith(simulation).whenCompleteOrCancel(() {
      widget.onEnd();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLeft = offset.dx > widget.originalOffset.dx;
    bool isRight = widget.originalOffset.dx > offset.dx;

    bool isTop = offset.dy > widget.originalOffset.dy;
    bool isBottom = widget.originalOffset.dy > offset.dy;

    return Positioned(
      width: widget.size.width,
      height: widget.size.height,
      left: isLeft ? offset.dx - widget.originalOffset.dx : null,
      right: isRight ? widget.originalOffset.dx - offset.dx : null,
      top: isTop ? offset.dy - widget.originalOffset.dy : null,
      bottom: isBottom ? widget.originalOffset.dy - offset.dy : null,
      child: widget.child,
    );
  }
}
