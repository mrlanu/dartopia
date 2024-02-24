import 'package:dartopia/consts/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../../settlement/settlement.dart';
import '../../../utils/time_formatter.dart';
import '../../buildings.dart';

class BuildingCard extends StatelessWidget {
  final int position;
  final Building specification;
  final List<double> storage;
  final List<List<int>> buildingRecords;

  const BuildingCard(
      {super.key,
      required this.position,
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
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          specification.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        )),
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
                          DartopiaImages.lumber,
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
                          DartopiaImages.clay,
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
                          DartopiaImages.iron,
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
                          DartopiaImages.crop,
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
                        ...specification.requirementBuildings.map((e) {
                          final building = buildingSpecefication[e[0]]!;
                          return Text(
                              overflow: TextOverflow.clip,
                              '${building.name} lvl ${e[1]}  ',
                              style: TextStyle(
                                  color: _isBuildingExistInVillage(e[0], e[1])
                                      ? null
                                      : Colors.red));
                        }).toList()
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          DartopiaImages.clock,
                          width: 50,
                          height: 50,
                        ),
                        Text(FormatUtil.formatTime(specification.time.valueOf(1))),
                        const SizedBox(width: 20),
                        FilledButton(
                            onPressed: _isMatchRequirements()
                                ? () {
                                    final request = ConstructionRequest(
                                        buildingId: specification.id,
                                        position: position,
                                        toLevel: 1);
                                    context.read<SettlementBloc>()
                                      ..add(BuildingIndexChanged(
                                          index: position - 14))
                                      ..add(BuildingUpgradeRequested(
                                          request: request));
                                    Navigator.of(context).pop();
                                  }
                                : null,
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
