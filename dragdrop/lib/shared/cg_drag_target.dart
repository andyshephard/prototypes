import 'package:dragdrop/models/player.dart';
import 'package:dragdrop/shared/placeholder_container.dart';
import 'package:dragdrop/shared/player_container.dart';
import 'package:flutter/material.dart';

class CGDragTarget extends StatefulWidget {
  const CGDragTarget(
      {Key? key,
      required this.size,
      required this.didPopulate,
      required this.didClear,
      required this.position})
      : super(key: key);

  final double size;
  final Function(Player) didPopulate;
  final Function(Player) didClear;
  final String position;

  @override
  _CGDragTarget createState() => _CGDragTarget();
}

class _CGDragTarget extends State<CGDragTarget> {
  bool isPopulated = false;
  Player? playerData;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        return isPopulated
            ? PlayerContainer(
                size: widget.size,
                player: playerData!,
              )
            : PlaceholderContainer(
                height: widget.size,
                width: widget.size,
                position: widget.position,
              );
      },
      onMove: (details) {
        debugPrint(details.toString());
      },
      onAcceptWithDetails: (details) {
        setState(() {
          final player = details.data as Player;
          widget.didPopulate(player);
          playerData = player;
          isPopulated = true;
        });
      },
      onWillAccept: (Player? data) {
        if (isPopulated == true) {
          // If the cell is already populated, we should return the original player to the list.
          widget.didClear(playerData!);

          // TODO: What about switching players from one target to another?
        }
        return widget.position == data?.position;
      },
    );
  }
}
