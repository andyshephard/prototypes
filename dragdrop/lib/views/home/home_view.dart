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

  @override
  void initState() {
    data.addAll([
      const Player(position: 'GK', color: Colors.red, name: 'Allison'),
      const Player(position: 'ST', color: Colors.lightBlue, name: 'Haaland'),
      const Player(position: 'CB', color: Colors.green, name: 'Shephard'),
      const Player(position: 'ST', color: Colors.red, name: 'Ronaldo'),
      const Player(position: 'RW', color: Colors.lightBlue, name: 'Messi'),
      const Player(position: 'ST', color: Colors.yellow, name: 'Deeney'),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    kTargetContainerSize = MediaQuery.of(context).size.width / 3;
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
                        data.add(player);
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
                height: 120,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return CGDraggable(
                      key: UniqueKey(),
                      affinity: Axis.vertical,
                      data: data[index],
                      feedback: Material(
                        child: PlayerContainer(
                          size: kPlayerContainerSize,
                          player: data[index],
                        ),
                      ),
                      childWhenDragging: Container(),
                      child: PlayerContainer(
                        size: kPlayerContainerSize,
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