import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:models/models.dart';

import '../../../settings/cubit/settings_cubit.dart';
import '../../../settlement/settlement.dart';
import '../../../utils/time_formatter.dart';

class BuildingCard extends StatelessWidget {
  final int buildingId;
  final Building specification;
  final List<double> storage;
  final List<List<int>> buildingRecords;
  final int constructionsTaskAmount;

  const BuildingCard(
      {super.key,
      required this.buildingId,
      required this.specification,
      required this.storage,
      required this.buildingRecords,
      required this.constructionsTaskAmount});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final settings = context.read<SettingsCubit>().state.settings;
    return Stack(
        clipBehavior: Clip.none,
        //alignment: Alignment.center,
        children: [
          Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.all(15.w),
                height: 0.46.sh,
                //width: size.width * 0.9,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          specification.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        )),
                    SizedBox(height: 10.h),
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: size.width * 0.55,
                        height: 120.h,
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
                          width: 32.w,
                          height: 32.w,
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
                          width: 32.w,
                          height: 32.w,
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
                          width: 32.w,
                          height: 32.w,
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
                          width: 32.w,
                          height: 32.w,
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
                        padding: EdgeInsets.all(8.w),
                        child: Text('Requirements:',
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.w),
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
                          width: 40.w,
                          height: 40.w,
                        ),
                        Text(FormatUtil.formatTime(
                            specification.time.valueOf(1) ~/ settings!.buildingsSpeedX)),
                        SizedBox(width: 20.w),
                        FilledButton(
                            onPressed: _isMatchRequirements() &&
                                    constructionsTaskAmount <
                                        settings.maxConstructionTasksInQueue
                                ? () {
                                    final request = ConstructionRequest(
                                        specificationId: specification.id,
                                        buildingId: buildingId,
                                        toLevel: 1);
                                    context.read<SettlementBloc>()
                                      ..add(BuildingIndexChanged(
                                          index: buildingId - 14))
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
            right: 15.w,
            top: 40.h,
            child: Image.asset(
              fit: BoxFit.cover,
              specification.imagePath,
              width: 90.w,
              height: 90.w,
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
