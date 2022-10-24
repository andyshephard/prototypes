import 'package:flutter/material.dart';

class PlaceholderContainer extends StatelessWidget {
  const PlaceholderContainer(
      {Key? key,
      required this.height,
      required this.width,
      required this.position})
      : super(key: key);

  final double height;
  final double width;
  final String position;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0),
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
