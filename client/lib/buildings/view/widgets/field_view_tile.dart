import 'package:dartopia/consts/consts.dart';
import 'package:dartopia/consts/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../../consts/calors.dart';
import '../../../settlement/settlement.dart';
import '../../../utils/utils.dart';

class FieldViewTile extends StatelessWidget {
  final List<int> buildingRecord;
  final List<double> storage;
  final int? isUpgrading;
  final int constructionsTaskAmount;

  const FieldViewTile(
      {super.key,
      required this.buildingRecord,
      required this.constructionsTaskAmount,
      required this.storage,
      this.isUpgrading});

  @override
  Widget build(BuildContext context) {
    final specification = buildingSpecefication[buildingRecord[1]]!;
    final prod = specification.benefit(buildingRecord[2]).toInt();
    final prodNext = specification.benefit(buildingRecord[2] + 1).toInt();
    final cost = specification.getResourcesToNextLevel(buildingRecord[2] + 1);
    final canBeUpgraded = buildingRecord[3] == 1 ? true : false;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                    backgroundColor: _getColor(),
                    child: Text(
                      '${buildingRecord[2]}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: DartopiaColors.black),
                    )),
                Text(
                  '$prod/hr',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
            Expanded(
                child: isUpgrading != null
                    ? _upgradingBody(
                        context, isUpgrading!, buildingRecord[2] + 1)
                    : _notUpgradingBody(cost,
                        specification.time.valueOf(buildingRecord[2] + 1))),
            Column(
              children: [
                IconButton.outlined(
                    color: Colors.green,
                    onPressed: canBeUpgraded && isUpgrading == null
                        ? () {
                            final request = ConstructionRequest(
                                buildingId: buildingRecord[1],
                                position: buildingRecord[0],
                                toLevel: buildingRecord[2] + 1);
                            context.read<SettlementBloc>().add(
                                BuildingUpgradeRequested(request: request));
                          }
                        : null,
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

  Color _getColor() {
    final canBeUpgraded = buildingRecord[3] == 1 ? true : false;
    final canBeUpgradedWithGold = buildingRecord[3] == 2 ? true : false;
    Color labelBackground;
    if (canBeUpgraded) {
      labelBackground = DartopiaColors.primaryContainer;
    } else if (canBeUpgradedWithGold) {
      labelBackground = DartopiaColors.secondaryContainer;
    } else {
      labelBackground = DartopiaColors.grey;
    }
    return labelBackground;
  }

  Widget _upgradingBody(BuildContext context, int duration, int lvl) {
    return Column(
      children: [
        Text(
          'Upgrading to lvl: $lvl',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        CountdownTimer(
          startValue: duration,
          onFinish: () {
            context
                .read<SettlementBloc>()
                .add(const SettlementFetchRequested());
          },
        ),
      ],
    );
  }

  Widget _notUpgradingBody(List<int> cost, int time) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _resItemBuilder(
                cost: cost, assetPath: DartopiaImages.lumber, itemPosition: 0),
            _resItemBuilder(
                cost: cost, assetPath: DartopiaImages.clay, itemPosition: 1),
            _resItemBuilder(
                cost: cost, assetPath: DartopiaImages.iron, itemPosition: 2),
            _resItemBuilder(
                cost: cost, assetPath: DartopiaImages.crop, itemPosition: 3),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(DartopiaImages.clock, height: 11),
            const SizedBox(
              width: 3,
            ),
            Text(
              FormatUtil.formatTime(time),
              style: const TextStyle(fontSize: 13),
            )
          ],
        ),
      ],
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
