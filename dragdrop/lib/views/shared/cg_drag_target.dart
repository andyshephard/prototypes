import 'package:dragdrop/models/player.dart';
import 'package:dragdrop/views/shared/placeholder_container.dart';
import 'package:dragdrop/views/shared/player_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CGDragTargetMode { none, accept, reject }

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
  CGDragTargetMode mode = CGDragTargetMode.none;
  Player? playerData;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        return isPopulated
            ? PlayerContainer(
                size: widget.size,
                player: playerData!,
                active: true,
                onEmpty: () {
                  setState(() {
                    widget.didClear(playerData!);
                    isPopulated = false;
                    playerData = null;
                  });
                },
              )
            : PlaceholderContainer(
                height: widget.size,
                width: widget.size,
                position: widget.position,
                mode: mode,
              );
      },
      onLeave: (data) {
        if (mode != CGDragTargetMode.none) {
          setState(() {
            mode = CGDragTargetMode.none;
          });
        }
      },
      onMove: (details) {
        final player = details.data as Player;
        if (player.position == widget.position) {
          if (mode != CGDragTargetMode.accept) {
            HapticFeedback.heavyImpact();
            setState(() {
              mode = CGDragTargetMode.accept;
            });
          }
        } else {
          if (mode != CGDragTargetMode.reject) {
            HapticFeedback.vibrate();
            setState(() {
              mode = CGDragTargetMode.reject;
            });
          }
        }
      },
      onAcceptWithDetails: (details) {
        setState(() {
          final player = details.data as Player;
          widget.didPopulate(player);
          playerData = player;
          isPopulated = true;
          mode = CGDragTargetMode.none;
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
