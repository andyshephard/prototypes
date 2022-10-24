import 'package:dragdrop/models/player.dart';
import 'package:dragdrop/shared/cg_drag_target.dart';
import 'package:flutter/material.dart';

import 'shared/player_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag Drop Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Drag Drop Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static double kTargetContainerSize = 150;
  static double kPlayerContainerSize = 120;
  var data = [];

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Row(
              children: [
                CGDragTarget(
                  size: kTargetContainerSize,
                  position: "ST",
                  didClear: (player) => setState(() {
                    data.add(player);
                  }),
                  didPopulate: (player) => setState(() {
                    data.remove(player);
                  }),
                ),
                const Spacer(),
                CGDragTarget(
                  size: kTargetContainerSize,
                  position: "GK",
                  didClear: (player) => setState(() {
                    data.add(player);
                  }),
                  didPopulate: (player) => setState(() {
                    data.remove(player);
                  }),
                ),
              ],
            ),
            const SizedBox(height: 200),
            SizedBox(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 15);
                },
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Draggable(
                    affinity: Axis.vertical,
                    data: data[index],
                    feedback: Material(
                      child: PlayerContainer(
                        size: kPlayerContainerSize,
                        player: data[index],
                      ),
                    ),
                    childWhenDragging: PlayerContainer(
                      size: kPlayerContainerSize,
                      player: data[index],
                    ),
                    child: PlayerContainer(
                      size: kPlayerContainerSize,
                      player: data[index],
                    ),
                    onDragEnd: (details) {
                      debugPrint('ended: ${details.offset}');
                    },
                    onDragCompleted: () {
                      debugPrint('drag completed');
                    },
                    onDragStarted: () {
                      debugPrint('drag started');
                    },
                    onDraggableCanceled: (velocity, offset) {
                      debugPrint('cancelled');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
