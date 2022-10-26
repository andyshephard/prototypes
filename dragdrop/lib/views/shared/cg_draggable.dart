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
    this.affinity,
    this.data,
  });

  final double size;
  final Offset position;
  final Widget child;
  final Widget childWhenDragging;
  final Widget feedback;

  dynamic affinity;
  Object? data;

  @override
  State<CGDraggable> createState() => _CGDraggableState();
}

class _CGDraggableState extends State<CGDraggable>
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
    offset = widget.position;
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      setState(() {
        offset = _animation.value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final draggable = Draggable(
      onDragUpdate: (details) {
        _controller.stop();
        setState(() {
          offset = Offset(details.localPosition.dx - (widget.size / 2),
              details.localPosition.dy - (widget.size / 2));
        });
      },
      onDragEnd: (details) {
        if (details.wasAccepted == false) {
          _runAnimation(details.velocity.pixelsPerSecond, size);
        }
      },
      affinity: widget.affinity,
      data: widget.data,
      childWhenDragging: widget.childWhenDragging,
      feedback: widget.feedback,
      child: widget.child,
    );
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: draggable,
    );
  }
}
