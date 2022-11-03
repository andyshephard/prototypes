import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CGDraggable extends StatefulWidget {
  CGDraggable({
    super.key,
    required this.size,
    required this.position,
    required this.child,
    required this.feedback,
    required this.childWhenDragging,
    required this.onReject,
    this.affinity,
    this.data,
  });

  final double size;
  final Offset position;
  final Widget child;
  final Widget childWhenDragging;
  final Widget feedback;

  final Function(Offset) onReject;

  dynamic affinity;
  Object? data;

  @override
  State<CGDraggable> createState() => CGDraggableState();
}

class CGDraggableState extends State<CGDraggable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Offset offset;

  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      Tween<Offset>(
        begin: offset,
        end: widget.position,
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
    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Draggable(
      onDragEnd: (details) {
        if (details.wasAccepted == false) {
          widget.onReject(details.offset);
        }
      },
      affinity: widget.affinity,
      data: widget.data,
      childWhenDragging: widget.childWhenDragging,
      feedback: widget.feedback,
      child: widget.child,
    );
  }
}
