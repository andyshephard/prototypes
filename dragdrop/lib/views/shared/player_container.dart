import 'package:dragdrop/models/player.dart';
import 'package:flutter/material.dart';

class PlayerContainer extends StatelessWidget {
  PlayerContainer({
    Key? key,
    required this.size,
    required this.player,
    this.active = false,
    this.onEmpty,
  }) : super(key: key);

  final double size;
  final Player player;
  final bool active;
  VoidCallback? onEmpty;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
        ),
        if (active)
          Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => onEmpty!(),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
