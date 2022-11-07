import 'package:dragdrop/views/shared/cg_drag_target.dart';
import 'package:flutter/material.dart';

class PlaceholderContainer extends StatelessWidget {
  const PlaceholderContainer({
    Key? key,
    required this.size,
    required this.position,
    required this.mode,
    required this.hoveringContent,
  }) : super(key: key);

  final Size size;
  final String position;
  final CGDragTargetMode mode;
  final bool hoveringContent;

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    switch (mode) {
      case CGDragTargetMode.none:
        borderColor = Colors.grey.withOpacity(0.25);
        break;
      case CGDragTargetMode.accept:
        borderColor = Colors.lime;
        break;
      case CGDragTargetMode.reject:
        borderColor = Colors.redAccent;
        break;
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(hoveringContent ? size.width / 8 : 0),
        border: Border.all(width: 5.0, color: borderColor),
        color: borderColor,
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
