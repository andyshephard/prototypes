import 'package:dragdrop/domains/player.dart';
import 'package:dragdrop/views/shared/animated_feedback.dart';
import 'package:dragdrop/views/shared/cg_draggable.dart';
import 'package:dragdrop/views/shared/placeholder_container.dart';
import 'package:dragdrop/views/shared/player_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CGDragTargetMode { none, accept, reject }

class CGDragTarget extends StatefulWidget {
  CGDragTarget(
      {Key? key,
      required this.data,
      required this.targetSize,
      required this.feedbackSize,
      required this.didPopulate,
      required this.didClear,
      required this.position})
      : super(key: key);

  Player? data;
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

  CGDragTargetMode _mode = CGDragTargetMode.none;
  bool _hoveringContent = false;

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
            return widget.data != null
                ? Center(
                    child: CGDraggable(
                      size: widget.feedbackSize,
                      data: widget.data,
                      feedback: Material(
                        child: PlayerContainer(
                          size: widget.feedbackSize,
                          player: widget.data!,
                        ),
                      ),
                      child: PlayerContainer(
                        size: widget.feedbackSize,
                        player: widget.data!,
                      ),
                    ),
                  )
                : PlaceholderContainer(
                    size: widget.targetSize,
                    position: widget.position,
                    mode: _mode,
                    hoveringContent: _hoveringContent,
                  );
          },
          onLeave: (data) {
            if (_mode != CGDragTargetMode.none) {
              setState(() {
                _mode = CGDragTargetMode.none;
                _hoveringContent = false;
              });
            }
          },
          onMove: (details) {
            final player = details.data as Player;
            if (player.position == widget.position) {
              if (_mode != CGDragTargetMode.accept) {
                HapticFeedback.heavyImpact();
                setState(() {
                  _mode = CGDragTargetMode.accept;
                  _hoveringContent = true;
                });
              }
            } else {
              if (_mode != CGDragTargetMode.reject) {
                HapticFeedback.vibrate();
                setState(() {
                  _mode = CGDragTargetMode.reject;
                  _hoveringContent = true;
                });
              }
            }
          },
          onAcceptWithDetails: (details) {
            RenderBox? object =
                _globalKey.currentContext?.findRenderObject() as RenderBox?;
            if (object != null) {
              setState(() {
                widget.didPopulate(details.data as Player);
                _currentOffset = details.offset;

                // TODO: Configure central offset w/ AnimatedFeedback.

                final targetOffset = object.localToGlobal(Offset.zero);
                final offsetX = targetOffset.dx +
                    ((widget.targetSize.width / 2) -
                        (widget.feedbackSize.width / 2));
                final offsetY = targetOffset.dy +
                    ((widget.targetSize.height / 2) -
                        (widget.feedbackSize.height / 2));
                _originalOffset = Offset(offsetX, offsetY);

                // _originalOffset = object.localToGlobal(Offset.zero);
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
                _mode = CGDragTargetMode.none;
              });
            },
            child: PlayerContainer(
              player: widget.data!,
              size: widget.feedbackSize,
            ),
          )
      ],
    );
  }
}
