import 'package:flutter/material.dart';

class Player {
  Player({
    Key? key,
    required this.globalKey,
    required this.position,
    required this.color,
    required this.name,
  });

  final GlobalKey globalKey;
  final String position;
  final Color color;
  final String name;
}
