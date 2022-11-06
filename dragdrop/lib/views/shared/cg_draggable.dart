import 'package:dragdrop/views/shared/animated_feedback.dart';
import 'package:flutter/material.dart';

class CGDraggable extends StatefulWidget {
  CGDraggable({
    super.key,
    required this.size,
    required this.feedback,
    required this.data,
    required this.child,
    this.childWhenDragging,
    this.affinity,
    this.onReject,
  });

  final Size size;
  final Widget? childWhenDragging;
  final Widget feedback;
  final Axis? affinity;
  final Object? data;
  final Widget child;

  Function(DraggableDetails)? onReject;

  @override
  State<CGDraggable> createState() => CGDraggableState();
}

class CGDraggableState extends State<CGDraggable> {
  final _globalKey = GlobalKey<CGDraggableState>();
  late Widget childWhenDragging;

  Offset? _originalOffset;
  Offset? _currentOffset;
  Velocity? _velocity;
  bool _showFeedback = false;

  @override
  void initState() {
    // TODO: Change this to access only from parent, not local instance.
    childWhenDragging = widget.childWhenDragging ??
        Opacity(
          opacity: 0.5,
          child: widget.child,
        );
    super.initState();
  }

  @override
  void dispose() {
    _originalOffset = null;
    _currentOffset = null;
    _velocity = null;
    _showFeedback = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Draggable(
          key: _globalKey,
          onDragEnd: (details) {
            if (details.wasAccepted == false) {
              // Check for callback. If present, return data to parent.
              if (widget.onReject != null) {
                widget.onReject!(details);
                return;
              }

              // Failed to hit target. Animate feedback return.
              RenderBox? object =
                  _globalKey.currentContext?.findRenderObject() as RenderBox?;
              if (object != null) {
                setState(() {
                  _velocity = details.velocity;
                  _currentOffset = details.offset;
                  _originalOffset = object.localToGlobal(Offset.zero);
                  _showFeedback = true;
                });
              }
            }
          },
          affinity: widget.affinity,
          data: widget.data,
          childWhenDragging: childWhenDragging,
          feedback: widget.feedback,
          child: _showFeedback ? childWhenDragging : widget.child,
        ),
        if (_showFeedback)
          AnimatedFeedback(
            currentOffset: _currentOffset!,
            originalOffset: _originalOffset!,
            velocity: _velocity!,
            size: widget.size,
            onEnd: () {
              setState(() {
                _showFeedback = false;
                _currentOffset = null;
                _velocity = null;
              });
            },
            child: widget.feedback,
          )
      ],
    );
  }
}
