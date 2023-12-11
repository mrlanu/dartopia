import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../settlement/settlement.dart';
import '../../buildings.dart';

class Field extends StatelessWidget {
  const Field({super.key, required this.buildingRecord});

  final List<int> buildingRecord;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettlementBloc, SettlementState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ...state.settlement!.buildings
                  .where((bR) => bR[1] == buildingRecord[1])
                  .map((e) {
                final upgradingTask = state.settlement!.constructionTasks
                    .where((task) =>
                        task.position == e[0] && task.buildingId == e[1])
                    .toList();
                return upgradingTask.isNotEmpty
                    ? FieldViewTile(
                        buildingRecord: e,
                        storage: state.settlement!.storage,
                        isUpgrading: upgradingTask[0]
                            .executionTime
                            .difference(DateTime.now())
                            .inSeconds,
                      )
                    : FieldViewTile(
                        buildingRecord: e,
                        storage: state.settlement!.storage,
                      );
              }).toList()
            ],
          ),
        );
      },
    );
  }
}
