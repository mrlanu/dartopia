import 'package:flutter/material.dart';

import '../../models/building_model.dart';
import '../../models/buildings_consts.dart';

class BuildingCard extends StatelessWidget {
  final BuildingModel buildingModel;
  final List<double> storage;
  final List<BuildingModel> buildingList;

  const BuildingCard(
      {super.key,
      required this.buildingModel,
      required this.storage,
      required this.buildingList});

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
                    Align(alignment: Alignment.topLeft, child: Text(buildingModel.name, style: Theme.of(context).textTheme.titleLarge,)),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: size.width * 0.55,
                        height: 120,
                        child: Text(
                            overflow: TextOverflow.clip,
                            buildingModel.description),
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
                          '${buildingModel.cost[0]}',
                          style: TextStyle(
                              color: buildingModel.cost[0] > storage[0]
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
                          '${buildingModel.cost[1]}',
                          style: TextStyle(
                              color: buildingModel.cost[1] > storage[1]
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
                          '${buildingModel.cost[2]}',
                          style: TextStyle(
                              color: buildingModel.cost[2] > storage[2]
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
                          '${buildingModel.cost[3]}',
                          style: TextStyle(
                              color: buildingModel.cost[3] > storage[3]
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
                        ...buildingModel.buildingsReq
                            .map((e) => Text(
                                overflow: TextOverflow.clip,
                                '${buildingsMap[e.$1]!.name} lvl ${e.$2}  ',
                                style: TextStyle(
                                    color: _isBuildingExistInVillage(e.$1, e.$2)
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
              buildingModel.imagePath,
              width: 100,
              height: 100,
            ),
          )
        ]);
  }

  bool _isMatchRequirements() {
    for (var i = 0; i < 4; i++) {
      if (storage[i] < buildingModel.cost[i]) {
        return false;
      }
    }
    for ((BuildingId, int) bR in buildingModel.buildingsReq) {
      if (!_isBuildingExistInVillage(bR.$1, bR.$2)) {
        return false;
      }
    }
    return true;
  }

  bool _isBuildingExistInVillage(BuildingId id, int level) {
    return buildingList
        .where((element) => element.id == id && level <= element.level)
        .isNotEmpty;
  }
}
