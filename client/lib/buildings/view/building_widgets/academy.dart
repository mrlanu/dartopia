import 'package:flutter/material.dart';

import '../view.dart';


class Academy extends StatelessWidget {
  const Academy({super.key, required this.buildingRecord});

  final List<int> buildingRecord;

  @override
  Widget build(BuildContext context) {
    return BuildingContainer(
      key: ValueKey('${buildingRecord[1]} ${buildingRecord[0]}'),
      buildingRecord: buildingRecord,
      child: (settlement, buildingRecord) {
        return const Expanded(
          child: Text('Academy')
        );
      },
    );
  }
}
