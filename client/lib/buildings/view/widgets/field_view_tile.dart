import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../../../utils/utils.dart';

class FieldViewTile extends StatelessWidget {
  final List<int> buildingRecord;

  const FieldViewTile({super.key, required this.buildingRecord});

  @override
  Widget build(BuildContext context) {
    final specification = buildingSpecefication[buildingRecord[1]]!;
    final prod = specification.benefit(buildingRecord[2]).toInt();
    final prodNext = specification.benefit(buildingRecord[2] + 1).toInt();
    final cost = specification.getResourcesToNextLevel(buildingRecord[2]);
    return Card(
      child: ListTile(
        leading: Column(
          children: [
            CircleAvatar(
                child: Text(
                  '${buildingRecord[2]}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                )),
            Text('$prod/hr', style: const TextStyle(fontSize: 10),),
          ],
        ),
        trailing: Column(
          children: [
            const CircleAvatar(
                child: Text(
                  '^',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                )),
            Text('$prodNext/hr', style: const TextStyle(fontSize: 10),),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _resItemBuilder(cost: cost, assetPath: 'assets/images/resources/lumber.png', fieldPosition: 0),
            _resItemBuilder(cost: cost, assetPath: 'assets/images/resources/clay.png', fieldPosition: 1),
            _resItemBuilder(cost: cost, assetPath: 'assets/images/resources/iron.png', fieldPosition: 2),
            _resItemBuilder(cost: cost, assetPath: 'assets/images/resources/crop.png', fieldPosition: 3),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/resources/clock.png', height: 11),
            const SizedBox(width: 3,),
            Text(
              '${formatTime(specification.time.valueOf(buildingRecord[2]))}',
              style: const TextStyle(fontSize: 13),
            )
          ],
        ),
      ),
    );
  }

  Widget _resItemBuilder(
      {required List<int> cost,
        required String assetPath,
        required int fieldPosition,
        double fontSize = 13,
        double imageHeight = 11}) {
    return Row(
      children: [
        Image.asset(assetPath, height: imageHeight),
        const SizedBox(width: 2,),
        Text(
          '${cost[fieldPosition]}',
          style: TextStyle(fontSize: fontSize),
        )
      ],
    );
  }
}
