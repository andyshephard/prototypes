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
  Velocity? velocity;
  bool showFeedback = false;

  Offset position = Offset.zero;

  @override
  void initState() {
    data.addAll([
      Player(
        position: 'GK',
        color: Colors.red,
        name: 'Allison',
        globalKey: UniqueKey(),
      ),
      Player(
        position: 'ST',
        color: Colors.lightBlue,
        name: 'Haaland',
        globalKey: UniqueKey(),
      ),
      Player(
        position: 'CB',
        color: Colors.green,
        name: 'Shephard',
        globalKey: UniqueKey(),
      ),
      Player(
        position: 'ST',
        color: Colors.red,
        name: 'Ronaldo',
        globalKey: UniqueKey(),
      ),
      Player(
        position: 'RW',
        color: Colors.lightBlue,
        name: 'Messi',
        globalKey: UniqueKey(),
      ),
      Player(
        position: 'ST',
        color: Colors.yellow,
        name: 'Deeney',
        globalKey: UniqueKey(),
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
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: GridView.builder(
                clipBehavior: Clip.none,
                itemCount: containers.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                itemBuilder: (context, index) {
                  return CGDragTarget(
                    targetSize:
                        Size(kTargetContainerSize, kTargetContainerSize),
                    feedbackSize:
                        Size(kPlayerContainerSize, kPlayerContainerSize),
                    position: containers[index],
                    didClear: (player) => setState(() {
                      data.insert(0, player);
                    }),
                    didPopulate: (player) => setState(() {
                      data.remove(player);
                    }),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                height: kPlayerContainerSize,
                child: ReorderableListView.builder(
                  clipBehavior: Clip.none,
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
                    return CGDraggable(
                      key: ValueKey(index),
                      size: Size(kPlayerContainerSize, kPlayerContainerSize),
                      feedback: Material(
                        child: PlayerContainer(
                          size:
                              Size(kPlayerContainerSize, kPlayerContainerSize),
                          player: data[index],
                        ),
                      ),
                      affinity: Axis.vertical,
                      data: data[index],
                      child: PlayerContainer(
                        size: Size(kPlayerContainerSize, kPlayerContainerSize),
                        player: data[index],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
