import 'package:dartopia/consts/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../../../utils/countdown.dart';
import '../../../../utils/time_formatter.dart';
import '../../buildings.dart';

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
    return BlocBuilder<BuildingsBloc, BuildingsState>(
      builder: (context, state) {
        final specification = buildingSpecefication[buildingRecord[1]]!;
        final storage = state.settlement!.storage;
        final upgradingTask = state.settlement!.constructionTasks
            .where((task) =>
                task.position == buildingRecord[0] &&
                task.buildingId == buildingRecord[1])
            .toList();
        return Card(
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.all(15),
              height: 390,
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${specification.name} level ${buildingRecord[2]}',
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                  const Divider(),
                  Expanded(
                      child: child != null
                          ? child!(state.settlement!, buildingRecord)
                          : Container()),
                  const Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    _buildResItem(
                        imagePath: DartopiaImages.lumber,
                        specification: specification,
                        buildingRecord: buildingRecord,
                        storage: storage,
                        position: 0),
                    _buildResItem(
                        imagePath: DartopiaImages.clay,
                        specification: specification,
                        buildingRecord: buildingRecord,
                        storage: storage,
                        position: 1),
                    _buildResItem(
                        imagePath: DartopiaImages.iron,
                        specification: specification,
                        buildingRecord: buildingRecord,
                        storage: storage,
                        position: 2),
                    _buildResItem(
                        imagePath: DartopiaImages.crop,
                        specification: specification,
                        buildingRecord: buildingRecord,
                        storage: storage,
                        position: 3),
                  ]),
                  const Divider(),
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
                                        .read<BuildingsBloc>()
                                        .add(const SettlementFetchRequested());
                                  },
                                ),
                              ],
                            ),
                      const SizedBox(width: 20),
                      IconButton.outlined(
                          color: Colors.green,
                          onPressed: specification.canBeUpgraded(
                                  storage: storage,
                                  toLevel: buildingRecord[2] + 1)
                              ? () {
                                  final request = ConstructionRequest(
                                      buildingId: specification.id,
                                      position: buildingRecord[0],
                                      toLevel: buildingRecord[2] + 1);
                                  context.read<BuildingsBloc>().add(
                                      BuildingUpgradeRequested(
                                          request: request));
                                }
                              : null,
                          icon: const Icon(Icons.update)),
                      const SizedBox(width: 20),
                      enterable
                          ? IconButton.outlined(
                              color: Colors.green,
                              onPressed: () {
                                onEnter!();
                              },
                              icon: const Icon(Icons.input))
                          : const SizedBox(),
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }

  Widget _buildResItem(
      {required String imagePath,
      required Building specification,
      required List<int> buildingRecord,
      required List<double> storage,
      required int position}) {
    final resToNextLvl =
        specification.getResourcesToNextLevel(buildingRecord[2] + 1);
    return Row(children: [
      Image.asset(
        imagePath,
        width: 40,
        height: 40,
      ),
      Text(
        '${specification.getResourcesToNextLevel(buildingRecord[2] + 1)[position]}',
        style: TextStyle(
            color:
                resToNextLvl[position] > storage[position] ? Colors.red : null),
      )
    ]);
  }
}
