import 'package:flutter/material.dart';

// TODO: Complete this and leverage animation to return to original offset(s).

class CGDraggable extends StatefulWidget {
  const CGDraggable(
      {Key? key,
      required this.child,
      required this.originX,
      required this.originY,
      this.animationSpeed = 200})
      : super(key: key);

  final Widget child;
  final double originX;
  final double originY;
  final int animationSpeed;

  @override
  _CGDraggableState createState() => _CGDraggableState();
}

class _CGDraggableState extends State<CGDraggable> {
  double x = 200;
  double y = 200;
  int animationSpeed = 0;

  @override
  void initState() {
    x = widget.originX;
    y = widget.originY;
    animationSpeed = widget.animationSpeed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: x,
      top: y,
      duration: Duration(milliseconds: animationSpeed),
      child: Draggable(
        onDragUpdate: (details) {
          setState(() {
            animationSpeed = 0;
            x = x + details.delta.dx;
            y = y + details.delta.dy;
          });
        },
        onDragEnd: (details) {
          setState(() {
            animationSpeed = widget.animationSpeed;
            x = widget.originX;
            y = widget.originY;
          });
        },
        feedback: const SizedBox(),
        child: widget.child,
      ),
    );
  }
}
