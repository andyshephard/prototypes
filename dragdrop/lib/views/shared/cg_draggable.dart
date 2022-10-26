import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CGDraggable extends StatefulWidget {
  CGDraggable({
    super.key,
    required this.child,
    required this.feedback,
    required this.childWhenDragging,
    this.affinity,
    this.data,
  });

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
  late Animation<Alignment> _animation;

  Alignment _dragAlignment = Alignment.center;

  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );

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
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
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
    return Align(
      alignment: _dragAlignment,
      child: Draggable(
        onDragUpdate: (details) {
          setState(() {
            _dragAlignment += Alignment(details.delta.dx / (size.width / 2),
                details.delta.dy / (size.height / 2));
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
      ),
    );
  }
}
