import 'package:flutter/material.dart';

class Player {
  const Player({
    Key? key,
    required this.position,
    required this.color,
    required this.name,
  });

  final String position;
  final Color color;
  final String name;
}
