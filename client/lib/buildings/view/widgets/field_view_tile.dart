import 'package:dartopia/buildings/bloc/buildings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../../utils/countdown.dart';
import '../../../utils/utils.dart';

class FieldViewTile extends StatelessWidget {
  final List<int> buildingRecord;
  final List<double> storage;
  final int? isUpgrading;

  const FieldViewTile({super.key,
    required this.buildingRecord,
    required this.storage,
    this.isUpgrading});

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
                    backgroundColor: canBeUpgraded && isUpgrading == null
                        ? null
                        : isUpgrading != null
                        ? const Color.fromRGBO(253, 216, 87, 1.0)
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
                child: isUpgrading != null
                    ? _upgradingBody(context, isUpgrading!, buildingRecord[2] + 1)
                    : _notUpgradingBody(
                    cost, specification.time.valueOf(buildingRecord[2] + 1))),
            Column(
              children: [
                IconButton.outlined(
                    color: Colors.green,
                    onPressed:
                    canBeUpgraded && isUpgrading == null ? () {
                      final request = ConstructionRequest(
                          buildingId: buildingRecord[1],
                          position: buildingRecord[0],
                          toLevel: buildingRecord[2] + 1);
                      context.read<BuildingsBloc>().add(
                          BuildingUpgradeRequested(request: request));
                    } : null,
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

  Widget _upgradingBody(BuildContext context, int duration, int lvl) {
    return Column(
      children: [
        Text(
          'Upgrading to lvl: $lvl',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        CountdownTimer(startValue: duration, onFinish: () {
          context.read<BuildingsBloc>().add(const SettlementFetchRequested());
        },),
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
            Image.asset('assets/images/resources/clock.png', height: 11),
            const SizedBox(
              width: 3,
            ),
            Text(
              '${formatTime(time)}',
              style: const TextStyle(fontSize: 13),
            )
          ],
        ),
      ],
    );
  }

  Widget _resItemBuilder({required List<int> cost,
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
