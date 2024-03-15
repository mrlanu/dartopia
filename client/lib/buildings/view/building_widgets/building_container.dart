import 'package:dartopia/consts/colors.dart';
import 'package:dartopia/consts/consts.dart';
import 'package:dartopia/consts/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../../../utils/countdown.dart';
import '../../../../utils/time_formatter.dart';
import '../../../settlement/settlement.dart';

class BuildingContainer extends StatelessWidget {
  final List<int> buildingRecord;
  final bool enterable;
  final Function()? onEnter;
  final Widget Function(Settlement settlement, List<int> buildingRecord)? child;

  const BuildingContainer(
      {super.key,
      required this.buildingRecord,
      this.child,
      this.enterable = false,
      this.onEnter});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettlementBloc, SettlementState>(
      builder: (context, state) {
        final specification = buildingSpecefication[buildingRecord[1]]!;
        final storage = state.settlement!.storage;
        final upgradingTask = state.settlement!.constructionTasks
            .where((task) =>
                task.buildingId == buildingRecord[0] &&
                task.specificationId == buildingRecord[1])
            .toList();
        return Card(
            elevation: 5,
            child: Column(
              children: [
                child != null
                    ? child!(state.settlement!, buildingRecord)
                    : Container(),
                _RequiredResourcesBar(
                    buildingRecord: buildingRecord,
                    specification: specification,
                    storage: storage),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    upgradingTask.isEmpty
                        ? Row(children: [
                            Image.asset(
                              DartopiaImages.clock,
                              width: 50,
                              height: 50,
                            ),
                            Text(FormatUtil.formatTime(specification.time
                                .valueOf(buildingRecord[2] + 1))),
                          ])
                        : Column(
                            children: [
                              Text(
                                'Upgrading to lvl: ${buildingRecord[2] + 1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              CountdownTimer(
                                startValue: upgradingTask[0]
                                    .executionTime
                                    .difference(DateTime.now())
                                    .inSeconds,
                                onFinish: () {
                                  context
                                      .read<SettlementBloc>()
                                      .add(const SettlementFetchRequested());
                                },
                              ),
                            ],
                          ),
                    const SizedBox(width: 20),
                    IconButton.outlined(
                        color: DartopiaColors.primary,
                        onPressed:
                            state.settlement!.constructionTasks.length <
                                        maxConstructionTasksAllowed &&
                                    specification.canBeUpgraded(
                                        storage: storage,
                                        toLevel: buildingRecord[2] + 1)
                                ? () {
                                    final request = ConstructionRequest(
                                        specificationId: specification.id,
                                        buildingId: buildingRecord[0],
                                        toLevel: buildingRecord[2] + 1);
                                    context.read<SettlementBloc>().add(
                                        BuildingUpgradeRequested(
                                            request: request));
                                  }
                                : null,
                        icon: const Icon(Icons.update)),
                    const SizedBox(width: 20),
                    enterable
                        ? IconButton.outlined(
                            color: DartopiaColors.primary,
                            onPressed: () {
                              onEnter!();
                            },
                            icon: const Icon(Icons.input))
                        : const SizedBox(),
                  ],
                )
              ],
            ));
      },
    );
  }
}

class _RequiredResourcesBar extends StatelessWidget {
  const _RequiredResourcesBar(
      {required this.buildingRecord,
        required this.specification,
        required this.storage});

  final List<int> buildingRecord;
  final Building specification;
  final List<double> storage;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _buildResItem(imagePath: DartopiaImages.lumber, position: 0),
      _buildResItem(imagePath: DartopiaImages.clay, position: 1),
      _buildResItem(imagePath: DartopiaImages.iron, position: 2),
      _buildResItem(imagePath: DartopiaImages.crop, position: 3),
    ]);
  }

  Widget _buildResItem({required String imagePath, required int position}) {
    final resToNextLvl =
    specification.getResourcesToNextLevel(buildingRecord[2] + 1);
    return Row(children: [
      Image.asset(imagePath, width: 40, height: 40,),
      Text(
        '${specification.getResourcesToNextLevel(buildingRecord[2] + 1)[position]}',
        style: TextStyle(
            color:
            resToNextLvl[position] > storage[position] ? Colors.red : null),
      )
    ]);
  }
}
