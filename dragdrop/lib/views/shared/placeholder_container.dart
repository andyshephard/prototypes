import 'package:dragdrop/views/shared/cg_drag_target.dart';
import 'package:flutter/material.dart';

class PlaceholderContainer extends StatelessWidget {
  const PlaceholderContainer({
    Key? key,
    required this.height,
    required this.width,
    required this.position,
    required this.mode,
  }) : super(key: key);

  final double height;
  final double width;
  final String position;
  final CGDragTargetMode mode;

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    switch (mode) {
      case CGDragTargetMode.none:
        borderColor = Colors.transparent;
        break;
      case CGDragTargetMode.accept:
        borderColor = Colors.lime;
        break;
      case CGDragTargetMode.reject:
        borderColor = Colors.redAccent;
        break;
    }
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(width: 5.0, color: borderColor),
        color: Colors.grey.withOpacity(0.25),
      ),
      child: Center(
        child: Text(
          'Place\n$position\nHere',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
