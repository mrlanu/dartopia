import 'package:flutter/material.dart';
import 'package:models/models.dart';

class BuildingCard extends StatelessWidget {
  final Building specification;
  final List<double> storage;
  final List<List<int>> buildingRecords;

  const BuildingCard(
      {super.key,
      required this.specification,
      required this.storage,
      required this.buildingRecords});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
        clipBehavior: Clip.none,
        //alignment: Alignment.center,
        children: [
          Card(
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.all(15),
                height: 390,
                //width: size.width * 0.9,
                child: Column(
                  children: [
                    Align(alignment: Alignment.topLeft, child: Text(specification.name, style: Theme.of(context).textTheme.titleLarge,)),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: size.width * 0.55,
                        height: 120,
                        child: Text(
                            overflow: TextOverflow.clip,
                            specification.description),
                      ),
                    ),
                    const Divider(),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Row(children: [
                        Image.asset(
                          'assets/images/resources/lumber.png',
                          width: 40,
                          height: 40,
                        ),
                        Text(
                          '${specification.cost[0]}',
                          style: TextStyle(
                              color: specification.cost[0] > storage[0]
                                  ? Colors.red
                                  : null),
                        )
                      ]),
                      Row(children: [
                        Image.asset(
                          'assets/images/resources/clay.png',
                          width: 40,
                          height: 40,
                        ),
                        Text(
                          '${specification.cost[1]}',
                          style: TextStyle(
                              color: specification.cost[1] > storage[1]
                                  ? Colors.red
                                  : null),
                        )
                      ]),
                      Row(children: [
                        Image.asset(
                          'assets/images/resources/iron.png',
                          width: 40,
                          height: 40,
                        ),
                        Text(
                          '${specification.cost[2]}',
                          style: TextStyle(
                              color: specification.cost[2] > storage[2]
                                  ? Colors.red
                                  : null),
                        )
                      ]),
                      Row(children: [
                        Image.asset(
                          'assets/images/resources/crop.png',
                          width: 40,
                          height: 40,
                        ),
                        Text(
                          '${specification.cost[3]}',
                          style: TextStyle(
                              color: specification.cost[3] > storage[3]
                                  ? Colors.red
                                  : null),
                        )
                      ]),
                    ]),
                    const Divider(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Requirements:',
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        ...specification.requirementBuildings
                            .map((e) => Text(
                                overflow: TextOverflow.clip,
                                '${specification.name} lvl ${e[1]}  ',
                                style: TextStyle(
                                    color: _isBuildingExistInVillage(e[0], e[1])
                                        ? null
                                        : Colors.red)))
                            .toList()
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/resources/clock.png',
                          width: 50,
                          height: 50,
                        ),
                        const Text('00:09:00'),
                        const SizedBox(width: 20),
                        FilledButton(
                            onPressed: _isMatchRequirements() ? () {} : null,
                            child: const Text('Build')),
                      ],
                    )
                  ],
                ),
              )),
          Positioned(
            right: 15,
            top: 40,
            child: Image.asset(
              fit: BoxFit.cover,
              specification.imagePath,
              width: 100,
              height: 100,
            ),
          )
        ]);
  }

  bool _isMatchRequirements() {
    for (var i = 0; i < 4; i++) {
      if (storage[i] < specification.cost[i]) {
        return false;
      }
    }
    for (var bR in specification.requirementBuildings) {
      if (!_isBuildingExistInVillage(bR[0], bR[1])) {
        return false;
      }
    }
    return true;
  }

  bool _isBuildingExistInVillage(int id, int level) {
    return buildingRecords
        .where((bR) => bR[1] == id && level <= bR[2])
        .isNotEmpty;
  }
}
