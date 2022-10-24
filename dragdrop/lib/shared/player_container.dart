import 'package:dragdrop/models/player.dart';
import 'package:flutter/material.dart';

class PlayerContainer extends StatelessWidget {
  const PlayerContainer({
    Key? key,
    required this.size,
    required this.player,
  }) : super(key: key);

  final double size;
  final Player player;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      color: player.color,
      child: Center(
        child: Text(
          '${player.name}\n${player.position}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
