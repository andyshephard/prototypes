import 'package:dragdrop/models/player.dart';
import 'package:dragdrop/views/shared/cg_drag_target.dart';
import 'package:dragdrop/views/shared/cg_draggable.dart';
import 'package:dragdrop/views/shared/player_container.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late double kTargetContainerSize;
  late double kPlayerContainerSize;
  var data = [];
  var containers = ["GK", "RW", "ST", "CB", "ST", "ST"];

  Offset? currentOffset;
  Offset? originalOffset;
  Widget? feedbackChild;
  bool showFeedback = false;

  Offset position = Offset.zero;

  @override
  void initState() {
    data.addAll([
      Player(
        position: 'GK',
        color: Colors.red,
        name: 'Allison',
        globalKey: GlobalKey(),
      ),
      Player(
        position: 'ST',
        color: Colors.lightBlue,
        name: 'Haaland',
        globalKey: GlobalKey(),
      ),
      Player(
        position: 'CB',
        color: Colors.green,
        name: 'Shephard',
        globalKey: GlobalKey(),
      ),
      Player(
        position: 'ST',
        color: Colors.red,
        name: 'Ronaldo',
        globalKey: GlobalKey(),
      ),
      Player(
        position: 'RW',
        color: Colors.lightBlue,
        name: 'Messi',
        globalKey: GlobalKey(),
      ),
      Player(
        position: 'ST',
        color: Colors.yellow,
        name: 'Deeney',
        globalKey: GlobalKey(),
      ),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    kTargetContainerSize = MediaQuery.of(context).size.width / 2;
    kPlayerContainerSize = MediaQuery.of(context).size.width / 3;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: GridView.builder(
                itemCount: containers.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: CGDragTarget(
                      size: kTargetContainerSize,
                      position: containers[index],
                      didClear: (player) => setState(() {
                        data.insert(0, player);
                      }),
                      didPopulate: (player) => setState(() {
                        data.remove(player);
                      }),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                height: kPlayerContainerSize,
                child: ReorderableListView.builder(
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      Player widget = data.removeAt(oldIndex);
                      data.insert(newIndex, widget);
                    });
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final feedback = Material(
                      child: PlayerContainer(
                        size: kPlayerContainerSize,
                        player: data[index],
                      ),
                    );
                    return Draggable(
                      key: data[index].globalKey,
                      affinity: Axis.vertical,
                      data: data[index],
                      feedback: feedback,
                      childWhenDragging: Container(),
                      child: PlayerContainer(
                        size: kPlayerContainerSize,
                        player: data[index],
                      ),
                      onDragEnd: (details) {
                        if (details.wasAccepted == false) {
                          setState(() {
                            currentOffset = details.offset;
                            RenderBox? object = data[index]
                                .globalKey
                                .currentContext
                                ?.findRenderObject() as RenderBox?;
                            if (object != null) {
                              originalOffset =
                                  object.localToGlobal(Offset.zero);
                              feedbackChild = feedback;
                              showFeedback = true;
                            }
                          });
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            if (showFeedback)
              AnimatedFeedback(
                  currentOffset: currentOffset!,
                  originalOffset: originalOffset!,
                  size: Size(kPlayerContainerSize, kPlayerContainerSize),
                  child: feedbackChild!,
                  onEnd: () {
                    setState(() {
                      showFeedback = false;
                      feedbackChild = null;
                      currentOffset = null;
                      originalOffset = null;
                    });
                  })
          ],
        ),
      ),
    );
  }
}

class AnimatedFeedback extends StatefulWidget {
  const AnimatedFeedback({
    super.key,
    required this.currentOffset,
    required this.originalOffset,
    required this.size,
    required this.onEnd,
    required this.child,
  });

  final Offset currentOffset;
  final Offset originalOffset;
  final Size size;
  final VoidCallback onEnd;
  final Widget child;

  @override
  State<AnimatedFeedback> createState() => _AnimatedFeedbackState();
}

class _AnimatedFeedbackState extends State<AnimatedFeedback> {
  bool shouldAnimate = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        shouldAnimate = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      width: widget.size.width,
      height: widget.size.height,
      left: shouldAnimate ? widget.originalOffset.dx : widget.currentOffset.dx,
      top: shouldAnimate ? widget.originalOffset.dy : widget.currentOffset.dy,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: widget.child,
      onEnd: () {
        widget.onEnd();
      },
    );
  }
}
