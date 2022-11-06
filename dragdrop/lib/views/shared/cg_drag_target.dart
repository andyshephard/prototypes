import 'package:dragdrop/models/player.dart';
import 'package:dragdrop/views/shared/animated_feedback.dart';
import 'package:dragdrop/views/shared/cg_draggable.dart';
import 'package:dragdrop/views/shared/placeholder_container.dart';
import 'package:dragdrop/views/shared/player_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CGDragTargetMode { none, accept, reject }

class CGDragTarget extends StatefulWidget {
  const CGDragTarget(
      {Key? key,
      required this.targetSize,
      required this.feedbackSize,
      required this.didPopulate,
      required this.didClear,
      required this.position})
      : super(key: key);

  final Size targetSize;
  final Size feedbackSize;
  final String position;
  final Function(Player) didPopulate;
  final Function(Player) didClear;

  @override
  CGDragTargetState createState() => CGDragTargetState();
}

class CGDragTargetState extends State<CGDragTarget> {
  final _globalKey = GlobalKey<CGDragTargetState>();

  bool _isPopulated = false;
  CGDragTargetMode _mode = CGDragTargetMode.none;
  Player? _playerData;

  Offset? _originalOffset;
  Offset? _currentOffset;
  Velocity? _velocity;
  bool _showFeedback = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // TODO: Add didClear?
        DragTarget(
          key: _globalKey,
          builder: (context, candidateData, rejectedData) {
            return _isPopulated
                ? Center(
                    child: CGDraggable(
                      size: widget.feedbackSize,
                      data: _playerData!,
                      feedback: Material(
                        child: PlayerContainer(
                          size: widget.feedbackSize,
                          player: _playerData!,
                        ),
                      ),
                      child: PlayerContainer(
                        size: widget.feedbackSize,
                        player: _playerData!,
                      ),
                    ),
                  )
                : PlaceholderContainer(
                    size: widget.targetSize,
                    position: widget.position,
                    mode: _mode,
                  );
          },
          onLeave: (data) {
            // TODO: Can we animate the target here somehow?
            if (_mode != CGDragTargetMode.none) {
              setState(() {
                _mode = CGDragTargetMode.none;
              });
            }
          },
          onMove: (details) {
            // TODO: Can we animate the target here somehow?

            final player = details.data as Player;
            if (player.position == widget.position) {
              if (_mode != CGDragTargetMode.accept) {
                HapticFeedback.heavyImpact();
                setState(() {
                  _mode = CGDragTargetMode.accept;
                });
              }
            } else {
              if (_mode != CGDragTargetMode.reject) {
                HapticFeedback.vibrate();
                setState(() {
                  _mode = CGDragTargetMode.reject;
                });
              }
            }
          },
          onAcceptWithDetails: (details) {
            // Return existing player to list if populated.
            if (_isPopulated == true) widget.didClear(_playerData!);

            RenderBox? object =
                _globalKey.currentContext?.findRenderObject() as RenderBox?;
            if (object != null) {
              setState(() {
                _playerData = details.data as Player;
                widget.didPopulate(_playerData!);
                _currentOffset = details.offset;

                // TODO: Configure central offset w/ AnimatedFeedback.

                // final targetOffset = object.localToGlobal(Offset.zero);
                // final offsetX = targetOffset.dx +
                //     ((widget.targetSize.width / 2) -
                //         (widget.feedbackSize.width / 2));
                // final offsetY = targetOffset.dy +
                //     ((widget.targetSize.height / 2) -
                //         (widget.feedbackSize.height / 2));
                // _originalOffset = Offset(offsetX, offsetY);

                _originalOffset = object.localToGlobal(Offset.zero);
                _velocity = const Velocity(pixelsPerSecond: Offset.zero);
                _showFeedback = true;
              });
            }
          },
          onWillAccept: (Player? data) {
            return widget.position == data?.position;
          },
        ),
        if (_showFeedback)
          AnimatedFeedback(
            currentOffset: _currentOffset!,
            originalOffset: _originalOffset!,
            velocity: _velocity!,
            size: widget.feedbackSize,
            onEnd: () {
              setState(() {
                _showFeedback = false;
                _currentOffset = null;
                _velocity = null;

                _isPopulated = true;
                _mode = CGDragTargetMode.none;
              });
            },
            child: PlayerContainer(
              player: _playerData!,
              size: widget.feedbackSize,
            ),
          )
      ],
    );
  }
}
