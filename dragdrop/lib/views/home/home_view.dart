import 'package:dragdrop/domains/player.dart';
import 'package:dragdrop/models/player_list_model.dart';
import 'package:dragdrop/models/target_model.dart';
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
  final _playerModel = PlayerListModel();
  final _targetModel = TargetModel();
  var containers = ["GK", "RW", "ST", "CB", "ST", "ST"];

  Offset? currentOffset;
  Offset? originalOffset;
  Widget? feedbackChild;
  Velocity? velocity;
  bool showFeedback = false;

  Offset position = Offset.zero;

  @override
  void initState() {
    _playerModel.players.addAll(
      [
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
      ],
    );

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
                    data: _targetModel.targets[index],
                    targetSize:
                        Size(kTargetContainerSize, kTargetContainerSize),
                    feedbackSize:
                        Size(kPlayerContainerSize, kPlayerContainerSize),
                    position: containers[index],
                    didClear: (player) => setState(() {
                      _targetModel.targets.remove(index);
                      _playerModel.players.insert(0, player);
                    }),
                    didPopulate: (player) => setState(() {
                      // Check if cell is already populated.
                      final myPlayer = _targetModel.targets[index];

                      // Check if new player is already in use.
                      final inUseIndex = _targetModel.targets.keys.firstWhere(
                          (key) => _targetModel.targets[key] == player,
                          orElse: () => -1);

                      if (myPlayer != null && inUseIndex != -1) {
                        // If populated && inUse, SWAP.
                        _targetModel.targets.remove(index);
                        _targetModel.targets.remove(inUseIndex);
                        _targetModel.targets[index] = player;
                        _targetModel.targets[inUseIndex] = myPlayer;
                      } else if (myPlayer == null && inUseIndex != -1) {
                        // If !populated && inUse, MOVE TO NEW.
                        _targetModel.targets.remove(inUseIndex);
                        _targetModel.targets[index] = player;
                      } else if (myPlayer != null && inUseIndex == -1) {
                        // If populated && !inUse, RETURN OLD TO LIST.
                        _targetModel.targets[index] = player;
                        _playerModel.players.insert(0, myPlayer);
                      } else {
                        // If !populated && !inUse, POPULATE, REMOVE FROM LIST.
                        _targetModel.targets[index] = player;
                        _playerModel.players.remove(player);
                      }
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
                      Player widget = _playerModel.players.removeAt(oldIndex);
                      _playerModel.players.insert(newIndex, widget);
                    });
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: _playerModel.players.length,
                  itemBuilder: (context, index) {
                    return CGDraggable(
                      key: ValueKey(index),
                      size: Size(kPlayerContainerSize, kPlayerContainerSize),
                      feedback: Material(
                        child: PlayerContainer(
                          size:
                              Size(kPlayerContainerSize, kPlayerContainerSize),
                          player: _playerModel.players[index],
                        ),
                      ),
                      affinity: Axis.vertical,
                      data: _playerModel.players[index],
                      child: PlayerContainer(
                        size: Size(kPlayerContainerSize, kPlayerContainerSize),
                        player: _playerModel.players[index],
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
