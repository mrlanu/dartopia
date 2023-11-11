import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../../../utils/utils.dart';

class FieldViewTile extends StatelessWidget {
  final List<int> buildingRecord;
  final List<double> storage;

  const FieldViewTile(
      {super.key, required this.buildingRecord, required this.storage});

  @override
  Widget build(BuildContext context) {
    final specification = buildingSpecefication[buildingRecord[1]]!;
    final prod = specification.benefit(buildingRecord[2]).toInt();
    final prodNext = specification.benefit(buildingRecord[2] + 1).toInt();
    final cost = specification.getResourcesToNextLevel(buildingRecord[2] + 1);
    final canBeUpgraded = specification.canBeUpgraded(
        storage: storage,
        existingBuildings: [],
        toLevel: buildingRecord[2] + 1);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                    backgroundColor: canBeUpgraded
                        ? null
                        : const Color.fromRGBO(255, 176, 176, 1.0),
                    child: Text(
                      '${buildingRecord[2]}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    )),
                Text(
                  '$prod/hr',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
            Expanded(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _resItemBuilder(
                        cost: cost,
                        assetPath: 'assets/images/resources/lumber.png',
                        itemPosition: 0),
                    _resItemBuilder(
                        cost: cost,
                        assetPath: 'assets/images/resources/clay.png',
                        itemPosition: 1),
                    _resItemBuilder(
                        cost: cost,
                        assetPath: 'assets/images/resources/iron.png',
                        itemPosition: 2),
                    _resItemBuilder(
                        cost: cost,
                        assetPath: 'assets/images/resources/crop.png',
                        itemPosition: 3),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/resources/clock.png',
                        height: 11),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      '${formatTime(specification.time.valueOf(buildingRecord[2]))}',
                      style: const TextStyle(fontSize: 13),
                    )
                  ],
                ),
              ],
            )),
            Column(
              children: [
                IconButton.outlined(
                    color: Colors.green,
                    onPressed: canBeUpgraded ? () {} : null,
                    icon: const Icon(Icons.update)),
                Text(
                  '$prodNext/hr',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _resItemBuilder(
      {required List<int> cost,
      required String assetPath,
      required int itemPosition,
      double fontSize = 13,
      double imageHeight = 11}) {
    return Row(
      children: [
        Image.asset(assetPath, height: imageHeight),
        const SizedBox(
          width: 2,
        ),
        Text(
          '${cost[itemPosition]}',
          style: TextStyle(
              fontSize: fontSize,
              color: cost[itemPosition] < storage[itemPosition]
                  ? null
                  : Colors.red),
        )
      ],
    );
  }
}
