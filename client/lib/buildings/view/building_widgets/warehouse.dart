import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'building_container.dart';

class Warehouse extends StatelessWidget {
  const Warehouse({super.key, required this.buildingRecord});

  final List<int> buildingRecord;

  @override
  Widget build(BuildContext context) {
    return BuildingContainer(
      key: ValueKey('${buildingRecord[1]} ${buildingRecord[0]}'),
      buildingRecord: buildingRecord,
      enterable: true,
      child: (settlement, buildingRecord) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Capacity: ${buildingSpecefication[buildingRecord[1]]!.getCapacity(buildingRecord[2])}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Capacity on level ${buildingRecord[2] + 1} : ${buildingSpecefication[buildingRecord[1]]!.getCapacity(buildingRecord[2] + 1)}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        );
      },
    );
  }
}
