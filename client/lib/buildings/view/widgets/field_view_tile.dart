import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../../../utils/utils.dart';
import '../../models/building_view_model.dart';

class FieldViewTile extends StatelessWidget {
  final BuildingViewModel fieldModel;

  const FieldViewTile({super.key, required this.fieldModel});

  @override
  Widget build(BuildContext context) {
    final prod = buildingSpecefication[fieldModel.id]!.benefit(fieldModel.level).toInt();
    final prodNext = buildingSpecefication[fieldModel.id]!.benefit(fieldModel.level + 1).toInt();
    return Card(
      child: ListTile(
        leading: Column(
          children: [
            CircleAvatar(
                child: Text(
                  '${fieldModel.level}',
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
            _resItemBuilder(assetPath: 'assets/images/resources/lumber.png', fieldPosition: 0),
            _resItemBuilder(assetPath: 'assets/images/resources/clay.png', fieldPosition: 1),
            _resItemBuilder(assetPath: 'assets/images/resources/iron.png', fieldPosition: 2),
            _resItemBuilder(assetPath: 'assets/images/resources/crop.png', fieldPosition: 3),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/resources/clock.png', height: 11),
            const SizedBox(width: 3,),
            Text(
              '${formatTime(fieldModel.timeToNextLevel)}',
              style: const TextStyle(fontSize: 13),
            )
          ],
        ),
      ),
    );
  }

  Widget _resItemBuilder(
      {required String assetPath,
        required int fieldPosition,
        double fontSize = 13,
        double imageHeight = 11}) {
    return Row(
      children: [
        Image.asset(assetPath, height: imageHeight),
        const SizedBox(width: 2,),
        Text(
          '${fieldModel.costToNextLevel[fieldPosition]}00',
          style: TextStyle(fontSize: fontSize),
        )
      ],
    );
  }
}
